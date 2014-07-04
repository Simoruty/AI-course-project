package it.uniba.di.ia.ius;

import com.declarativa.interprolog.PrologEngine;
import com.declarativa.interprolog.TermModel;
import com.declarativa.interprolog.YAPSubprocessEngine;

import java.io.File;
import java.util.List;

public class Interprolog {

    private static PrologEngine engine;

    public Interprolog(String coreConsultPath, String prolog_path) {

        engine = new YAPSubprocessEngine(prolog_path, false);
        engine.consultAbsolute(new File(coreConsultPath));
        System.err.println(engine.getPrologVersion());
    }

    public void close() {
        engine.shutdown();
    }

    public void addFiles(List<String> sourceFiles) {
        // loading files
        String load = "load_all(['";
        for (String file : sourceFiles) {
            load += (file + "','");
        }

        load = load.substring(0, load.length() - 2);
        load += "])";

        engine.deterministicGoal(load);
    }

    public boolean sendCommand(String command) {
        return engine.deterministicGoal(command);
    }

    public String oneSolution(String command, String var) {
        String query = command + "(" + var + ") , term_to_atom(" + var + ",Result)";
        System.out.println(query);
        Object[] result = engine.deterministicGoal(query, "[string(Result)]");
        return result[0].toString();
    }

    public void allSolutions() {

        String goal = "findall(X,nextTag(X),L), term_to_atom(L,Result)";
        String sol=(String)(engine.deterministicGoal(goal,"[string(Result)]")[0]);
        System.out.println(sol);

//        String goal = "findall(_X,nextTag(_X),_L), buildTermModel(_L,ListModel)";
//
//        TermModel solutionVars = (TermModel) (engine.deterministicGoal(goal, "[ListModel]")[0]);
//        System.out.println(solutionVars.getChildCount());

//        System.out.println("Solution bindings list:"+solutionVars);

    }
}