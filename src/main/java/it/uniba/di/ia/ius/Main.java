package it.uniba.di.ia.ius;

import it.uniba.di.ia.ius.gui.MainWindow;
import it.uniba.di.ia.ius.prologAPI.Interprolog;
import jpl.JPL;

public class Main {
    public static String yapJPLPath = "/usr/local/lib/Yap";
    public static String swiJPLPath = "/usr/local/lib/swipl-6.6.6/lib/x86_64-linux";

    public static void main(String args[]) {

        // JPL
        JPL.setNativeLibraryDir(swiJPLPath);
        MainWindow mw = new MainWindow();


        // INTERPROLOG
//        Interprolog ip = new Interprolog("prolog/main.pl", "/usr/local/bin/yap", 0);
//        String as="asserta(domanda(\"ciao luciano quercia\")";
//        System.out.println(as);
//        ip.sendCommand(as);
//        ip.allSolutions();
//        ip.close();
    }
}

