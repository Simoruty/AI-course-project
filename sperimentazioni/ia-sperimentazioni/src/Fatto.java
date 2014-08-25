import java.util.Arrays;

public class Fatto implements Comparable {
    private String predicato;
    private String[] argomenti;

    public Fatto(String predicato, String... argomenti) {
        this.predicato = predicato;
        this.argomenti = argomenti;
    }

    public String getPredicato() {
        return predicato;
    }

    public String[] getArgomenti() {
        return argomenti;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Fatto fatto = (Fatto) o;

        if (!Arrays.equals(argomenti, fatto.argomenti)) return false;
        if (!predicato.equals(fatto.predicato)) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = predicato.hashCode();
        result = 31 * result + Arrays.hashCode(argomenti);
        return result;
    }

    @Override
    public int compareTo(Object o) {
        String a = this.predicato;
        for (String s : argomenti) {
            a += s;
        }
        Fatto f = (Fatto) o;
        String b = f.predicato;
        for (String s : f.argomenti) {
            b += s;
        }
        return a.compareTo(b);
    }

    @Override
    public String toString() {
        String s = predicato + '(';
        s += argomenti[0];

        if (argomenti.length == 2)
            s += ", " + argomenti[1];

        s += ").";
        return s;
    }
}
