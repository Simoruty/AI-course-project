package it.uniba.di.ia.ius;

import it.uniba.di.ia.ius.gui.MainWindow;
import jpl.Atom;
import jpl.JPL;
import jpl.Query;

public class MainYAP {
    public static String yapJPLPath = "/usr/local/lib/Yap";

    public static void main(String args[]) {
        JPL.setNativeLibraryDir(yapJPLPath);
        Query query = new Query(new Atom("version"));
        System.out.println(query.hasSolution() ? "succeeded" : "failed");
        MainWindow mw = new MainWindow();



//        new Prolog().method();
    }
}

