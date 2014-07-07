package it.uniba.di.ia.ius.prologAPI;

import java.io.File;
import java.util.List;
import java.util.Map;

public abstract class PrologInterface {

    public static final int SWI = 2;
    public static final int YAP = 4;
    protected static String YAP_BIN_PATH = "/usr/local/bin/yap";
    protected static String SWI_BIN_PATH = "/usr/local/bin/swipl";
    protected static String YAP_LIB_PATH = "/usr/local/lib/Yap";
    protected static String SWI_LIB_PATH = "/usr/local/lib/swipl-6.6.6/lib/x86_64-linux";

    public int type = SWI;

    public void setYAP() {
        type = YAP;
    }

    public void setSWI() {
        type = SWI;
    }

    protected PrologInterface(int type) {
        this.type = type;
    }

    public abstract void close();

    public abstract void consult(File file);

    public abstract void asserta(String pred, List<String> args);

    public abstract void assertz(String pred, List<String> args);

    public abstract void retract(String pred, List<String> args);

    public abstract void retractAll(String pred, List<String> args);

    public abstract boolean statisfied(String pred, List<String> args);

    public abstract Map<String, String> oneSolution(String pred, List<String> args);

    public abstract List<Map<String, String>> nSolutions(String pred, List<String> args, int size);

    public abstract List<Map<String, String>> allSolutions(String pred, List<String> args);

}
