package it.uniba.di.ia.ius;

import jpl.Term;
import jpl.Util;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ParseList {

    private static final String PATTERN_STRING = "^#\\(([^#]+), (#\\(.*\\))\\)$";
    private static final Pattern PATTERN = Pattern.compile(PATTERN_STRING);
    private String text;
    private String temp;

    public ParseList(Term list) {
        String s = list.toString();
        s = s.replaceAll("'\\.'", "#");
        s = s.replaceAll("\\[\\]", "#()");
        System.out.println(s);
        this.text = s;
    }

    public List<Term> getElementsFromList() {
        reset();
        List<Term> list = new ArrayList<>(30);

        String head;
        while ( (head = getHead(temp)) != null ) {
            System.out.println(head);
            list.add(Util.textToTerm(head));
        }

        System.out.println(list);
        return list;
    }

    private String getHead(String text) {
        Matcher m = PATTERN.matcher(text);
        if (m.find()) {
            String head = text.substring(m.start(1), m.end(1));
            this.temp = text.substring(m.start(2), m.end(2));
            return head;
        } else
            return null;
    }

    private void reset() {
        temp = text;
    }
}
