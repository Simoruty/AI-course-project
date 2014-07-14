package it.uniba.di.ia.ius;

import it.uniba.di.ia.ius.prologAPI.PrologInterface;

import javax.swing.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class Predicato {

    private String nomePredicato;
    private int arity;
    private JCheckBox checkBox;
    private boolean vuole;
    private List<String> vars;
    private List<Tag> list;

    public Predicato(String nomePredicato, int arity, JCheckBox checkBox) {
        this.nomePredicato = nomePredicato;
        this.arity = arity;
        this.checkBox = checkBox;
        this.vuole = this.checkBox.isSelected();
        this.vars = new ArrayList<>(arity);
        this.list = new ArrayList<>(20);
        for (int i = 0; i < arity; i++) {
            this.vars.add("R" + i);
        }
        if (vuole)
            PrologInterface.getInstance().asserta("vuole", Arrays.asList(nomePredicato));
    }

    public List<Tag> run() {
        if (!vuole)
            return new ArrayList<>(0);

        List<Map<String, String>> listMap = null;
        listMap = PrologInterface.getInstance().allSolutions(nomePredicato, vars);

        for (Map<String, String> map : listMap) {
            String id = map.get(vars.get(0));
            String[] args = new String[arity-1];
            for (int i = 1; i < vars.size(); i++) {
                args[i-1] = map.get(vars.get(i));
            }
            Tag tag = new Tag(nomePredicato, id, args);
            list.add(tag);
        }

        return list;
    }
}
