import java.util.ArrayList;

/**
 * Created by lusio on 16/08/14.
 */
public class Predicato {
    private String predicato;
    private int arieta;
    private String argTipo1;
    private String argTipo2;
//    private String key;

    public Predicato(String predicato, String argTipo1, String argTipo2) {
        this.predicato = predicato;
        this.arieta = 2;
        this.argTipo1 = argTipo1;
        this.argTipo2 = argTipo2;
    }

    public Predicato(String predicato, String argTipo1) {
        this.predicato = predicato;
        this.arieta = 1;
        this.argTipo1 = argTipo1;
        this.argTipo2 = null;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Predicato predicato1 = (Predicato) o;

        if (arieta != predicato1.arieta) return false;
        if (!argTipo1.equals(predicato1.argTipo1)) return false;
        if (argTipo2 != null ? !argTipo2.equals(predicato1.argTipo2) : predicato1.argTipo2 != null) return false;
        if (!predicato.equals(predicato1.predicato)) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = predicato.hashCode();
        result = 31 * result + arieta;
        result = 31 * result + argTipo1.hashCode();
        result = 31 * result + (argTipo2 != null ? argTipo2.hashCode() : 0);
        return result;
    }

    public String getPredicato() {
        return predicato;
    }

    public int getArieta() {
        return arieta;
    }

    public String getArgTipo1() {
        return argTipo1;
    }

    public String getArgTipo2() {
        return argTipo2;
    }

    public String getSignatureForD() {
        String s;
        if (arieta == 2)
            s = "*" + predicato + "(" + argTipo1 + ", " + argTipo2 + ")";
        else
            s = "*" + predicato + "(" + argTipo1 + ")";

//        s += " " + key;
        return s;
    }



    public static ArrayList<Predicato> allPredicati() {
        ArrayList<Predicato> predicati = new ArrayList<>(20);
        predicati.add(new Predicato("allineato_al_centro_orizzontale","Frame", "Frame"));
        predicati.add(new Predicato("allineato_al_centro_verticale","Frame", "Frame"));
        predicati.add(new Predicato("altezza_pagina","Pagina", "AltezzaPagina"));
        predicati.add(new Predicato("larghezza_pagina","Pagina", "LarghezzaPagina"));
        predicati.add(new Predicato("altezza_rettangolo","Frame", "AltezzaRettangolo"));
        predicati.add(new Predicato("ascissa_rettangolo","Frame", "AscissaRettangolo"));
        predicati.add(new Predicato("ordinata_rettangolo","Frame", "OrdinataRettangolo"));
        predicati.add(new Predicato("larghezza_rettangolo","Frame", "LarghezzaRettangolo"));
        predicati.add(new Predicato("frame","Pagina", "Frame"));
        predicati.add(new Predicato("numero_pagine","Documento", "NumeroPagine"));
        predicati.add(new Predicato("on_top","Frame", "Frame"));
        predicati.add(new Predicato("to_right","Frame", "Frame"));
        predicati.add(new Predicato("pagina_1","Documento", "Pagina"));
        predicati.add(new Predicato("ultima_pagina","Pagina"));
        predicati.add(new Predicato("tipo_immagine","Frame"));
        predicati.add(new Predicato("tipo_linea_obbliqua","Frame"));
        predicati.add(new Predicato("tipo_linea_orizzontale","Frame"));
        predicati.add(new Predicato("tipo_misto","Frame"));
        predicati.add(new Predicato("tipo_testo","Frame"));
        predicati.add(new Predicato("tipo_vuoto","Frame"));
        return predicati;
    }
}
