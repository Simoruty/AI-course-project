package it.uniba.di.ia.ius.prologAPI;

import com.declarativa.interprolog.PrologEngine;
import com.declarativa.interprolog.SWISubprocessEngine;
import com.declarativa.interprolog.YAPSubprocessEngine;

import java.io.File;
import java.util.*;

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

        String goal = "all" + pred;
        Map<String, String> map = null;
        try {
            map = oneSolution(goal, Arrays.asList("ResultList"));
        } catch (NoVariableException e) {
            e.printStackTrace();
        }
        String result= map.get("ResultList");
        List<Map<String, String>> listMap = new ArrayList<>(10);
        if (!result.equals("[]")) {
            String temp = map.get("ResultList").replaceAll("\\),\\(", "#").replaceAll("\\[\\(", "").replaceAll("\\)\\]", "");
            String[] parsered = temp.split("#");
            for (String s1 : parsered) {
                String[] tags = s1.split(",");
                int i = 0;
                Map<String, String> map1 = new HashMap<>();
                for (String arg : args) {
                    map1.put(arg, tags[i]);
                    i++;
                }
                listMap.add(map1);
            }
        }
        return listMap;

    }

    @Override
    public void close() {
        engine.shutdown();
    }

}