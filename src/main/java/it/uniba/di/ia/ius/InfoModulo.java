package it.uniba.di.ia.ius;

import java.util.Arrays;
import java.util.List;

public class InfoModulo {

    private static List<String> nomi = Arrays.asList(
            "Luciano",
            "Simone",
            "Stefano",
            "Giuseppe",
            "Francesco",
            "Antonio",
            "Giovanni"
    );
    private static List<String> cognomi = Arrays.asList(
            "Quercia",
            "Rutigliano",
            "Simone",
            "Mazzilli",
            "Malerba",
            "Di Mauro",
            "Abbattista"
    );
    private static List<String> comuni = Arrays.asList(
            "Rutigliano",
            "Corato",
            "Terlizzi",
            "Bari",
            "San Giovanni Rotondo",
            "Giovinazzo",
            "Milano",
            "Roma",
            "Napoli",
            "Civitavecchia",
            "Rocca di Papa",
            "Rho",
            "Torino",
            "Ivrea",
            "Asti"
    );
    private static List<String> indirizzi = Arrays.asList(
            "viale Federico II di Svevia, 28",
            "via Roma, 12",
            "via Claudio Traina, 24",
            "p.za Caduti di Via Fani, 2",
            "piazza Vittorio Emanuele, 3",
            "via della Liberazione, 9",
            "viale Arno, 5"
    );
    private static List<String> telefoni = Arrays.asList(
            "346-8594782",
            "080-5584794",
            "3284699785",
            "+39-345 12 58 789"
    );
    private static List<String> codiciFiscali = Arrays.asList(
            "CCNGRT55A25C983Z",
            "ZCNCTL65B65A285K",
            "FCNSMN75L15L109J",
            "LCNLCN85C05L109I",
            "RCGGRZ92E54A285D",
            "QCNPLA88M04C983K"
    );
    private static List<String> numeriRichieste = Arrays.asList(
            "25/2008",
            "125/2008",
            "12/2007",
            "3/2009",
            "4/2009",
            "20/2010",
            "46/2011",
            "49/2011",
            "16/2010",
            "77/2012",
            "111/2013",
            "40/2014"
    );
    private static List<String> motivazioni = Arrays.asList(
            "prestazioni di lavoro subordinato in qualità di operaio",
            "acquisto utensili da lavoro",
            "prestazioni di lavoro occasionale",
            "interventi di manutenzione ordinaria",
            "acquisto materiale",
            "locazione immobile"
    );
    private static List<String> date = Arrays.asList(
            "25/5/2013",
            "12 febbraio 1995",
            "5-12-2013",
            "15 giugno 2003",
            "16 giu 1999"
            //TODO
    );
    private int numeroAllegati;
    private String dataOggi;
    private String nomeSottoscritto;
    private String cognomeSottoscritto;
    private String nomeAvvocato;
    private String cognomeAvvocato;
    private String nomeGiudice;
    private String cognomeGiudice;
    private String indirizzo;
    private String telefono;
    private String codiceFiscale;
    private String email;
    private String numeroPratica;
    private String motivazioneRichiesta;
    private String comuneTribunale;
    private String comuneNascita;
    private String dataNascita;
    private String dataInizio;
    private String dataFine;

    public InfoModulo() {
        this.nomeSottoscritto = estraiUno(nomi);
        this.cognomeSottoscritto = estraiUno(cognomi);
        this.nomeAvvocato = estraiUno(nomi);
        this.cognomeAvvocato = estraiUno(cognomi);
        this.nomeGiudice = estraiUno(nomi);
        this.cognomeGiudice = estraiUno(cognomi);
        this.indirizzo = estraiUno(indirizzi);
        this.telefono = estraiUno(telefoni);
        this.codiceFiscale = estraiUno(codiciFiscali);
        if (coin())
            this.email = nomeSottoscritto.substring(0, 1).toLowerCase() + "." + cognomeSottoscritto.toLowerCase() + "@libero.it";
        else
            this.email = nomeSottoscritto.toLowerCase() + "." + cognomeSottoscritto.toLowerCase() + "@gmail.it";
        this.numeroPratica = estraiUno(numeriRichieste);
        this.motivazioneRichiesta = estraiUno(motivazioni);
        this.comuneTribunale = estraiUno(comuni);
        this.comuneNascita = estraiUno(comuni);
        this.dataOggi = estraiUno(date);
        this.dataNascita = estraiUno(date);
        this.dataInizio = estraiUno(date);
        this.dataFine = estraiUno(date);
        this.numeroAllegati = (int) Math.round(Math.floor(Math.random() * 5)) + 1;
    }

    private static String estraiUno(List<String> list) {
        int idx = (int) Math.round(Math.floor(Math.random() * (list.size())));
        return list.get(idx);
    }

    private static boolean coin() {
        int num = (int) Math.round(Math.random());
        return (num == 0);
    }

    public String getNomeGiudice() {
        return nomeGiudice;
    }

    public String getCognomeGiudice() {
        return cognomeGiudice;
    }

    public String getNomeSottoscritto() {
        return nomeSottoscritto;
    }

    public String getCognomeSottoscritto() {
        return cognomeSottoscritto;
    }

    public String getNomeAvvocato() {
        return nomeAvvocato;
    }

    public String getCognomeAvvocato() {
        return cognomeAvvocato;
    }

    public String getIndirizzo() {
        return indirizzo;
    }

    public String getTelefono() {
        return telefono;
    }

    public String getCodiceFiscale() {
        return codiceFiscale;
    }

    public String getEmail() {
        return email;
    }

    public String getNumeroPratica() {
        return numeroPratica;
    }

    public String getMotivazioneRichiesta() {
        return motivazioneRichiesta;
    }

    public String getDataNascita() {
        return dataNascita;
    }

    public String getComuneNascita() {
        return comuneNascita;
    }

    public String getComuneTribunale() {
        return comuneTribunale;
    }

    public String getDataInizio() {
        return dataInizio;
    }

    public String getDataFine() {
        return dataFine;
    }

    public int getNumeroAllegati() {
        return numeroAllegati;
    }

    public String getDataOggi() {
        return dataOggi;
    }
}
