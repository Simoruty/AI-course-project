package it.uniba.di.ia.ius;

import jpl.Term;
import jpl.Util;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ParseList {

    private static final String PATTERN_STRING_JPL = "^#\\(([^#]+), (#\\(.*\\))\\)$";
    private static final String PATTERN_STRING_INTERPROLOG = "^$";
    private Pattern pattern;
    private String text;
    private String temp;

    public final int JPL = 0;
    public final int INTERPROLOG = 1;

    public ParseList(Term list, int type) {
        String s = list.toString();

        if (type == JPL) {
            pattern = Pattern.compile(PATTERN_STRING_JPL);
            s = s.replaceAll("'\\.'", "#");
            s = s.replaceAll("\\[\\]", "#()");
            this.text = s;
        }

        if ( type == INTERPROLOG ) {
            pattern = Pattern.compile(PATTERN_STRING_INTERPROLOG);
//            s = s.replaceAll("'\\.'", "#");
//            s = s.replaceAll("\\[\\]", "#()");
            this.text = s;
        }
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
        Matcher m = pattern.matcher(text);
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
