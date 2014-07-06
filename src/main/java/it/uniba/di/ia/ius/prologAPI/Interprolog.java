package it.uniba.di.ia.ius.prologAPI;

import com.declarativa.interprolog.PrologEngine;
import com.declarativa.interprolog.SWISubprocessEngine;
import com.declarativa.interprolog.YAPSubprocessEngine;

import java.io.File;

public class Interprolog {

    private static PrologEngine engine;
    private static final int YAPENGINE = 0;
    private static final int SWIENGINE = 1;

    public Interprolog(String coreConsultPath, String prolog_path, int type) {

        if (type== YAPENGINE)
        engine = new YAPSubprocessEngine(prolog_path, true);
        else if (type == SWIENGINE)
        engine = new SWISubprocessEngine(prolog_path,true);

        engine.consultAbsolute(new File(coreConsultPath));
        System.err.println(engine.getPrologVersion());
    }

    public void consult(String consultPath){
        engine.consultAbsolute(new File(consultPath));
    }

    public void close() {
        engine.shutdown();
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

    public String allSolutions() {

        String goal = "domanda(X),extract(X,Y), term_to_atom(Y,Result)";
        return (String)(engine.deterministicGoal(goal,"[string(Result)]")[0]);

//        String goal = "findall(_X,nextTag(_X),_L), buildTermModel(_L,ListModel)";
//
//        TermModel solutionVars = (TermModel) (engine.deterministicGoal(goal, "[ListModel]")[0]);
//        System.out.println(solutionVars.getChildCount());

//        System.out.println("Solution bindings list:"+solutionVars);

    }

    //    public void addFiles(List<String> sourceFiles) {
//        // loading files
//        String load = "load_all(['";
//        for (String file : sourceFiles) {
//            load += (file + "','");
//        }
//
//        load = load.substring(0, load.length() - 2);
//        load += "])";
//
//        engine.deterministicGoal(load);
//    }

}