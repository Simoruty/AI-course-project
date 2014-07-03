package it.uniba.di.ia.ius;

import com.declarativa.interprolog.PrologEngine;
import com.declarativa.interprolog.TermModel;
import com.declarativa.interprolog.YAPSubprocessEngine;

import java.io.File;
import java.util.List;

public class Interprolog {

    private static PrologEngine engine;

    public Interprolog(String coreConsultPath, String prolog_path) {

        engine = new YAPSubprocessEngine(prolog_path, true);
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

//        nonDeterministicGoal(InterestingVarsTerm,G,ListTM) :-
//                findall(InterestingVarsTerm,G,L), buildTermModel(L,ListTM).

//        String goal = "nonDeterministicGoal(A,nextTag(A),ListModel)";

//        String goal = "trace,findall(X,nextTag(X),Term),browseTerm(Term)";
//        TermModel solutionVars = (TermModel)(engine.deterministicGoal(go,"[ListModel]")[0]);
//        System.out.println("Solution bindings list:"+solutionVars);

        String goal = "findall(X,nextTag(X),L), buildTermModel(L,ListModel)";

        TermModel solutionVars = (TermModel)(engine.deterministicGoal(goal,"[Term]")[0]);
        System.out.println(solutionVars.getChildCount());

//        String goal = "findall(T, (nextTag(X), buildTermModel(X,T)), List)";
//        goal += ",buildTermModel(List, ListTM)";
//        goal += ",ipObjectSpec('ArrayOfObject',ListTM, LM)";
////        = "findall(TM, ( nextTag(T),buildTermModel(T,TM) ), L), ipObjectSpec('ArrayOfObject',L,LM)";
//        Object[] solutions = (Object[]) engine.deterministicGoal(goal, "[LM]")[0];
//        System.out.println("Number of solutions:" + solutions.length);
//        for (int I = 0; I < solutions.length; I++)
//            System.out.println("Solution " + I + ":" + solutions[I]);
// solutions will contain TermModels for ‘a’ and ‘b’
//
//
//

//        String goal = "findall(_X,nextTag(_X),_L), buildTermModel(_L,ListModel)";
//
//        TermModel solutionVars = (TermModel) (engine.deterministicGoal(goal, "[ListModel]")[0]);
//        System.out.println(solutionVars.getChildCount());

//        System.out.println("Solution bindings list:"+solutionVars);

    }
}