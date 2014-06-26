package it.uniba.di.ia.ius;

import jpl.Query;

public class Prolog {

    public void method() {
        String consult = "consult('~/dev/university/ia-prolog/main.pl')";
        Query queryConsult = new Query(consult);
        System.out.println(consult + " " + (queryConsult.hasSolution() ? "succeeded" : "failed"));

        String main = "main";
        Query queryMain = new Query(main);

        System.out.println(main + " is " + (queryMain.hasSolution() ? "provable" : "not provable"));

        java.util.Hashtable[] ss2 = queryMain.allSolutions();

        System.out.println("all solutions of " + main);
        for (int i = 0; i < ss2.length; i++) {
            System.out.println("X = " + ss2[i].get("X"));
        }
    }
}
