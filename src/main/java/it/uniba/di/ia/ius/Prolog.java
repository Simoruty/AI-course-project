package it.uniba.di.ia.ius;

import jpl.Atom;
import jpl.Compound;
import jpl.Query;
import jpl.Term;

public class Prolog {

//    public void affirm(Atom a) {
//        Term t = new Compound("assert", new Term[] { a });
////        Query query = new Query("assert(" + s + ")");
//        Query query = new Query( t );
//        System.out.print("[Prolog] assert( " + a + " ) ");
//        System.out.println(query.hasSolution() ? "succeeded" : "failed");
//    }
//
//    public void affirm(Compound c) {
//        Term t = new Compound("assert", new Term[] { c });
////        Query query = new Query("assert(" + s + ")");
//        Query query = new Query( t );
//        System.out.print("[Prolog] assert( " + a + " ) ");
//        System.out.println(query.hasSolution() ? "succeeded" : "failed");
//    }


    public boolean consult(Atom atom) {
        Term t = new Compound("consult", new Term[]{atom});
        Query query = new Query(t);
        System.out.print("[Prolog] consult: " + t + " ");
        System.out.println(query.hasSolution() ? "succeeded" : "failed");
        return query.hasSolution();
    }

    public void affirm(Term term) {
        Term t = new Compound("assert", new Term[]{term});
        Query query = new Query(t);
        System.out.print("[Prolog] assert( " + term + " ) ");
        System.out.println(query.hasSolution() ? "succeeded" : "failed");
    }

    public boolean statisfied(Term t) {
        Query query = new Query(t);
        System.out.print("[Prolog] query: " + t + " ");
        System.out.println(query.hasSolution() ? "succeeded" : "failed");
        return query.hasSolution();
    }

    public java.util.Hashtable oneSolution(Term t) {
        Query query = new Query(t);
        System.out.print("[Prolog] query: " + t + " ");
        System.out.println(query.hasSolution() ? "succeeded" : "failed");
        return query.oneSolution();
    }

    public java.util.Hashtable[] nSolutions(Term t, long size) {
        Query query = new Query(t);
        System.out.print("[Prolog] query: " + t + " ");
        System.out.println(query.hasSolution() ? "succeeded" : "failed");
        return query.nSolutions(size);
    }

    public java.util.Hashtable[] allSolutions(Term t) {
        Query query = new Query(t);
        System.out.print("[Prolog] query: " + t + " ");
        System.out.println(query.hasSolution() ? "succeeded" : "failed");
        return query.allSolutions();
    }


    public void method() {

        String s = "working_directory(CWD, CWD)";
        Query q = new Query(s);
        System.out.println(q.oneSolution().get("CWD"));

        String consult = "consult('prolog/main.pl')";
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
