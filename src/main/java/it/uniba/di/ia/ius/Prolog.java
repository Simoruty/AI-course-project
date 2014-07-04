package it.uniba.di.ia.ius;

import jpl.*;

public class Prolog {

    public boolean consult(Atom atom) {
        Term t = new Compound("consult", new Term[]{atom});
        Query query = new Query(t);
        System.out.print("[Prolog] consult: " + t + " ");
        System.out.println(query.hasSolution() ? "succeeded" : "failed");
        return query.hasSolution();
    }

    public void asserta(Term term) {
        Term t = new Compound("asserta", new Term[]{term});
        Query query = new Query(t);
        System.err.print("[Prolog] asserta( " + term + " ) ");
        System.err.println(query.hasSolution() ? "succeeded" : "failed");
    }

    public void assertz(Term term) {
        Term t = new Compound("assertz", new Term[]{term});
        Query query = new Query(t);
        System.err.print("[Prolog] assertz( " + term + " ) ");
        System.err.println(query.hasSolution() ? "succeeded" : "failed");
    }

    public void retract(Term term) {
        Term t = new Compound("retract", new Term[]{term});
        Query query = new Query(t);
        System.err.print("[Prolog] retract( " + term + " ) ");
        System.err.println(query.hasSolution() ? "succeeded" : "failed");
    }

    public void retractAll(String predicate, int arity) {

        Term[] args = new Term[arity];
        for (int i = 0; i < args.length; i++)
            args[i] = new Variable("_");

        Term[] termToRetract = new Term[]{ new Compound(predicate, args) };

        Term t = new Compound("retractall", termToRetract);
        Query query = new Query(t);
        System.err.print("[Prolog] retract( " + predicate + " ) ");
        System.err.println(query.hasSolution() ? "succeeded" : "failed");
    }

    public boolean statisfied(Term t) {
        Query query = new Query(t);
        System.err.print("[Prolog] query: " + t + " ");
        System.err.println(query.hasSolution() ? "succeeded" : "failed");
        return query.hasSolution();
    }

    public java.util.Hashtable<String, Term> oneSolution(Term t) {
        Query query = new Query(t);
        System.err.print("[Prolog] query: " + t + " ");
        System.err.println(query.hasSolution() ? "succeeded" : "failed");
        return query.oneSolution();
    }

    public java.util.Hashtable<String, Term>[] nSolutions(Term t, long size) {
        Query query = new Query(t);
        System.err.print("[Prolog] query: " + t + " ");
        System.err.println(query.hasSolution() ? "succeeded" : "failed");
        return query.nSolutions(size);
    }

    public java.util.Hashtable<String, Term>[] allSolutions(Term t) {
        Query query = new Query(t);
        System.err.print("[Prolog] query: " + t + " ");
        System.err.println(query.hasSolution() ? "succeeded" : "failed");
        return query.allSolutions();
    }
}
