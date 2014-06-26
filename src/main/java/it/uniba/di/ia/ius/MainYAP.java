package it.uniba.di.ia.ius;

import jpl.JPL;

public class MainYAP {
    public static String yapJPLPath = "/usr/local/lib/Yap";

    public static void main(String args[]) {
        JPL.setNativeLibraryDir(yapJPLPath);
        new Prolog().method();
    }
}

