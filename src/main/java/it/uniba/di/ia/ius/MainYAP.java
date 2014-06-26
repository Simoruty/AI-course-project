package it.uniba.di.ia.ius;

import it.uniba.di.ia.ius.gui.MainWindow;
import jpl.JPL;

public class MainYAP {
    public static String yapJPLPath = "/usr/local/lib/Yap";

    public static void main(String args[]) {
        JPL.setNativeLibraryDir(yapJPLPath);
        MainWindow mw = new MainWindow();

//        new Prolog().method();
    }
}

