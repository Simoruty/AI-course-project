package it.uniba.di.ia.ius;

import it.uniba.di.ia.ius.gui.MainWindow;
import jpl.JPL;

public class MainSWI {
    public static String swiJPLPath = "/usr/local/lib/swipl-6.6.6/lib/x86_64-linux";

    public static void main(String args[]) {
        JPL.setNativeLibraryDir(swiJPLPath);
        MainWindow mw = new MainWindow();

//        new Prolog().method();
    }
}
