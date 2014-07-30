package it.uniba.di.ia.ius.prologAPI;

import java.io.File;
import java.util.List;
import java.util.Map;

public abstract class PrologInterface {

    public static final int SWI = 2;
    public int type = SWI;
    public static final int YAP = 4;
    public static final int JPL = 5;
    public static final int INTERPROLOG = 6;
    protected static PrologInterface self;
    protected static String YAP_BIN_PATH = "/usr/local/bin/yap";
    protected static String SWI_BIN_PATH = "/usr/local/bin/swipl";
    protected static String YAP_LIB_PATH = "/usr/local/lib/Yap";
    protected static String SWI_LIB_PATH = "/usr/local/lib/swipl-6.6.6/lib/x86_64-linux";

    protected PrologInterface(int type) {
        this.type = type;
    }

    public static PrologInterface getInstance() {
        return self;
    }

    public void setYAP() {
        type = YAP;
    }

    public void setSWI() {
        type = SWI;
    }

    public abstract void close();

    public abstract void consult(File file);

    public abstract void asserta(String pred, List<String> args);

    public abstract void assertz(String pred, List<String> args);

    public abstract void retract(String pred, List<String> args);

    public abstract void retractAll(String pred, List<String> args);

    public abstract boolean statisfied(String pred, List<String> args);

    public abstract Map<String, String> oneSolution(String pred, List<String> args) throws NoVariableException;

    public abstract List<Map<String, String>> allSolutions(String pred, List<String> args);

    protected boolean prologNamedVariable(String s) {
        if (s.substring(0, 1).matches("[A-Z]"))
            return true;
        return false;
    }

}
