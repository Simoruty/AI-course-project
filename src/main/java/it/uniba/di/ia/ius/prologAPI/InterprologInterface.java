package it.uniba.di.ia.ius.prologAPI;

import com.declarativa.interprolog.PrologEngine;
import com.declarativa.interprolog.SWISubprocessEngine;
import com.declarativa.interprolog.TermModel;
import com.declarativa.interprolog.YAPSubprocessEngine;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InterprologInterface extends PrologInterface {

    private PrologEngine engine;

    public InterprologInterface(int type) {
        super(type);
        switch (type) {
            case SWI:
                engine = new SWISubprocessEngine(SWI_BIN_PATH, true);
                break;
            case YAP:
                engine = new YAPSubprocessEngine(YAP_BIN_PATH, true);
                break;
            default:
                break;
        }
        System.out.println(engine.getPrologVersion());
    }

    @Override
    public void consult(File file) {
        boolean hasSolution = engine.consultAbsolute(file);
        System.out.print("[Prolog] consult: " + file + " ");
        System.out.println(hasSolution ? "succeeded" : "failed");
    }

    @Override
    public void asserta(String pred, List<String> args) {
        metaCommand("asserta", pred, args);
    }

    @Override
    public void assertz(String pred, List<String> args) {
        metaCommand("assertz", pred, args);
    }

    @Override
    public void retract(String pred, List<String> args) {
        metaCommand("retract", pred, args);
    }

    @Override
    public void retractAll(String pred, List<String> args) {
        metaCommand("retractall", pred, args);
    }

    private void metaCommand(String what, String pred, List<String> args) {
        String command = what + "( " + pred;
        if ((args == null) || (args.size() == 0)) {
        } else {
            command += "(";
            for (String arg : args) {
                command += arg + ",";
            }
            command = command.substring(0, command.length() - 1);
            command += ")";
        }
        command += ")";

        boolean hasSolution = engine.command(command);

        System.err.print("[Prolog] " + what + "( " + pred + " ) ");
        System.err.println(hasSolution ? "succeeded" : "failed");
    }

    @Override
    public boolean statisfied(String pred, List<String> args) {
        String goal = "";
        if ((args == null) || (args.size() == 0))
            goal += pred;
        else {
            goal += pred + "(";
            for (String arg : args) {
                goal += arg + ",";
            }
            goal = goal.substring(0, goal.length() - 1);
            goal += ")";
        }
        boolean hasSolution = engine.deterministicGoal(goal);

        System.err.print("[Prolog] query: " + goal + " ");
        System.err.println(hasSolution ? "succeeded" : "failed");
        return hasSolution;

    }

    @Override
    public Map<String, String> oneSolution(String pred, List<String> args) throws NoVariableException {
        String goal = "";
        Map<String, String> map = new HashMap<>();
        List<String> vars = new ArrayList<>(args.size());

        if ((args == null) || (args.size() == 0))
            throw new NoVariableException();
        else {
            goal += pred + "(";
            for (String arg : args) {
                if (prologNamedVariable(arg)) {
                    vars.add(arg);
                }
                goal += arg + ",";
            }
            goal = goal.substring(0, goal.length() - 1);
            goal += ")";

            if (vars.isEmpty())
                throw new NoVariableException();
        }

        String rVars = "[";
        for (int i = 0; i < vars.size(); i++) {
            goal += ", term_to_atom(" + vars.get(i) + ", R" + i + ")";
            rVars += "string(R" + i + "),";
        }
        rVars = rVars.substring(0, rVars.length() - 1);
        rVars += "]";

        System.out.println(goal);

        Object[] result = engine.deterministicGoal(goal, null, null, rVars);

        for (int i = 0; i < result.length; i++) {
            map.put(vars.get(i), result[i].toString());
        }

        return map;
    }

    @Override
    public List<Map<String, String>> nSolutions(String pred, List<String> args, int size) {
        return null;
    }

    @Override
    public List<Map<String, String>> allSolutions(String pred, List<String> args) {

//        String goal = "nonDeterministicGoal(A+B,"+pred+"(A,B),ListModel)";
        String goal ="findall(B,"+pred+"(A,B),L), buildTermModel(L,ListModel)";
// Notice that 'ListModel' is referred in both deterministicGoal arguments:
        TermModel solutionVars = (TermModel)(engine.deterministicGoal(goal,"[ListModel]")[0]);
        System.out.println("Solution bindings list:"+solutionVars);

        return null;
    }

//    @Override
//    public String oneSolution(String goal) {

//    }
//
//    @Override
//    public List<String> nSolutions(String t, int size) {
//    }
//
//    @Override
//    public List<String> allSolutions(String t) {
//        String goal = "domanda(X),extract(X,Y), term_to_atom(Y,Result)";
//        return (String) (engine.deterministicGoal(goal, "[string(Result)]")[0]);
//
////        String goal = "findall(_X,nextTag(_X),_L), buildTermModel(_L,ListModel)";
////
////        TermModel solutionVars = (TermModel) (engine.deterministicGoal(goal, "[ListModel]")[0]);
////        System.out.println(solutionVars.getChildCount());
//
////        System.out.println("Solution bindings list:"+solutionVars);
//    }

    @Override
    public void close() {
        engine.shutdown();
    }

}