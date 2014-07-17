package it.uniba.di.ia.ius;

import java.util.ArrayList;
import java.util.List;

public class Tag {

    private String predicate;
    private String id;
    private int arity;
    private List<String> args;

    public Tag(String predicate, String id, String... args) {
        this.predicate = predicate;
        this.id = id;
        this.arity = args.length;
        this.args = new ArrayList<>(args.length);
        for (String arg : args) {
            this.args.add(arg);
        }
    }

    @Override
    public String toString() {
        String s = predicate;
        s += "(";
        for (String arg : args) {
            s += " " + arg + ',';
        }
        s = s.substring(0, s.length() - 1);
        s += " )";
        return s;
    }


    public String getId() {
        return id;
    }
}
