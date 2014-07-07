package it.uniba.di.ia.ius.prologAPI;

import com.declarativa.interprolog.PrologEngine;
import com.declarativa.interprolog.SWISubprocessEngine;
import com.declarativa.interprolog.YAPSubprocessEngine;
import jpl.Query;
import jpl.Util;

import java.io.File;
import java.util.List;
import java.util.Map;

public class InterprologInterface extends PrologInterface {

    private PrologEngine engine;

    protected InterprologInterface(int type) {
        super(type);
    }

    @Override
    public void close() {

    }

    @Override
    public void consult(File file) {

    }

    @Override
    public void asserta(String pred, List<String> args) {

    }

    @Override
    public void assertz(String pred, List<String> args) {

    }

    @Override
    public void retract(String pred, List<String> args) {

    }

    @Override
    public void retractAll(String pred, List<String> args) {

    }

    @Override
    public boolean statisfied(String pred, List<String> args) {
        return false;
    }

    @Override
    public Map<String, String> oneSolution(String pred, List<String> args) {
        return null;
    }

    @Override
    public List<Map<String, String>> nSolutions(String pred, List<String> args, int size) {
        return null;
    }

    @Override
    public List<Map<String, String>> allSolutions(String pred, List<String> args) {
        return null;
    }

//    public InterprologInterface(int type) {
//        this.type = type;
//        switch (type) {
//            case SWI:
//                engine = new SWISubprocessEngine(SWI_BIN_PATH, true);
//                break;
//            case YAP:
//                engine = new YAPSubprocessEngine(YAP_BIN_PATH, true);
//                break;
//            default:
//                break;
//        }
//        System.err.println(engine.getPrologVersion());
//    }
//
//    @Override
//    public void consult(File file) {
//        boolean hasSolution = engine.consultAbsolute(file);
//        System.out.print("[Prolog] consult: " + file + " ");
//        System.out.println(hasSolution ? "succeeded" : "failed");
//    }
//
//
//    @Override
//    public void asserta(String term) {
//        String command = "asserta(" + term + ")";
//        boolean hasSolution = engine.deterministicGoal(command);
//        System.err.print("[Prolog] asserta( " + term + " ) ");
//        System.err.println(hasSolution ? "succeeded" : "failed");
//    }
//
//    @Override
//    public void assertz(String term) {
//        String command = "assertz(" + term + ")";
//        boolean hasSolution = engine.deterministicGoal(command);
//        System.err.print("[Prolog] assertz( " + term + " ) ");
//        System.err.println(hasSolution ? "succeeded" : "failed");
//    }
//
//    @Override
//    public void retract(String term) {
//        String command = "retract(" + term + ")";
//        boolean hasSolution = engine.deterministicGoal(command);
//        System.err.print("[Prolog] retract( " + term + " ) ");
//        System.err.println(hasSolution ? "succeeded" : "failed");
//    }
//
//    @Override
//    public void retractAll(String predicate, int arity) {
//        String command;
//        if (arity == 0)
//            command = "retractall(" + predicate + ")";
//        else {
//            command = "retractall(" + predicate + "(";
//            for (int i = 0; i < arity; i++) {
//                command += "_,";
//            }
//            command = command.substring(0, command.length() - 1);
//            command += "))";
//        }
//        boolean hasSolution = engine.deterministicGoal(command);
//        System.err.print("[Prolog] retract( " + predicate + " ) ");
//        System.err.println(hasSolution ? "succeeded" : "failed");
//    }
//
//    @Override
//    public boolean statisfied(String goal) {
//        boolean hasSolution = engine.deterministicGoal(goal);
//        System.err.print("[Prolog] query: " + goal + " ");
//        System.err.println(hasSolution ? "succeeded" : "failed");
//        return hasSolution;
//    }
//
//
//    @Override
//    public String oneSolution(String goal) {
//        String query = goal + ", term_to_atom(" + var + ",Result)";
//        System.out.println(query);
//        Object[] result = engine.deterministicGoal(query, "[string(Result)]");
//        return result[0].toString();
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
//
//    @Override
//    public void close() {
//        engine.shutdown();
//    }

}