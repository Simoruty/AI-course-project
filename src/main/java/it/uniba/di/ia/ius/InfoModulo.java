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
            "Giovanni",
            "Paolo",
            "Christian",
            "Vincenzo",
            "Mario",
            "Carlo",
            "Nicola",
            "Riccardo",
            "Federico",
            "Michele",
            "Andrea",
            "Luca",
            "Marco",
            "Fabio",
            "Gianluca",
            "Rosanna",
            "Maria",
            "Paola",
            "Giovanna",
            "Francesca",
            "Stefania",
            "Lucia",
            "Luciana",
            "Simona"
    );
    private static List<String> cognomi = Arrays.asList(
            "Quercia",
            "Rutigliano",
            "Simone",
            "Mazzilli",
            "Malerba",
            "Di Mauro",
            "Livraghi",
            "Abbattista",
            "Amorese",
            "Torelli",
            "Mastrogiacomo",
            "Mastrototaro",
            "D'Oria",
            "D'Introno",
            "Di Francesco",
            "Mininno",
            "Scalfaro",
            "Napolitano",
            "Rossi",
            "Conti",
            "Ferilli",
            "Esposito",
            "Scotti",
            "Speranza",
            "Altobello",
            "Altobelli",
            "Riccardi",
            "Marchetti",
            "Lucatelli",
            "Vernice",
            "Saracino",
            "Maldera",
            "Ardito"
    );
    private static List<String> comuni = Arrays.asList(
            "Rutigliano",
            "Corato",
            "Mola",
            "Squinzano",
            "Terlizzi",
            "Molfetta",
            "Lecce",
            "Foggia",
            "Andria",
            "Barletta",
            "Caserta",
            "Casal di Principe",
            "Roccaporena",
            "Trani",
            "Bisceglie",
            "Barletta",
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
            "via pacecco, 12",
            "p.za Caduti di Via Fani, 2",
            "p.za Vittorio Emanuele, 3",
            "via della Liberazione, 9",
            "viale Arno, 5"
    );
    private static List<String> telefoni = Arrays.asList(
            "346-8594782",
            "080-5584794",
            "3284699785",
            "3475459798",
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
    private static List<String> dateNascita = Arrays.asList(
            "25/5/1989",
            "12 febbraio 1978",
            "5-12-1966",
            "15 giugno 1980",
            "16 giu 1947",
            "21 novembre 1978",
            "15-10-1957",
            "15 luglio 1974 ",
            "2 giu 1947"
    );

    private static List<String> dateInizio = Arrays.asList(
            "25/5/2000",
            "12 febbraio 2001",
            "5-12-2008",
            "15 giugno 2002",
            "16 giu 2003"
    );

    private static List<String> dateFine = Arrays.asList(
            "25/5/2010",
            "12 febbraio 2011",
            "5-12-2012",
            "15 giugno 2010",
            "16 giu 2009"
    );

    private static List<String> datePostFine = Arrays.asList(
            "25/5/2013",
            "21 luglio 2012",
            "12 maggio 2011",
            "24-04-2012",
            "12 febbraio 2012",
            "5-09-2013",
            "15 settembre 2013",
            "16 ago 2014"
    );

    private static List<String> valute = Arrays.asList(
            "1220 €",
            "200.50 €",
            "€120",
            "euro 2000",
            "12000 $",
            "1580 eur",
            "1980 USD",
            "1890 dollari",
            "3000 euro",
            "3330.00 eur",
            "10000 dollari",
            "2000 euro",
            "800 €",
            "1923 eur"
    );

    private static List<String> aziendeFallite = Arrays.asList(
            "Parmalat",
            "Lenovo",
            "Motorola",
            "Ducati",
            "Lamborghini",
            "Gilera",
            "Invernizzi",
            "FIAT",
            "Bridgestone",
            "Microsoft",
            "Fincons",
            "Algida",
            "Frisco",
            "Vodafone",
            "Kappa",
            "LG",
            "Samsung",
            "Acer",
            "IBM",
            "Apple",
            "Apple",
            "Apple INC.",
            "Apple INC.",
            "Sony"
    );

    private static List<String> tipiRichiesta = Arrays.asList(
            "in via chirografaria",
            "in via privilegiata",
            "chirografario",
            "privilegiato",
            "in modalità chirografaria",
            "in modalità privilegiata",
            "in modo chirografo",
            "in modo privilegiato"
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
    private String valuta;
    private String tipoRichiesta;
    private String cognomeCuratore;
    private String nomeCuratore;
    private String comuneResidenza;
    private String NValuta;
    private String NMotivazioneRichiesta;
    private String dataVerifica;
    private String aziendaFallimento;

    public InfoModulo() {
        this.nomeSottoscritto = estraiUno(nomi);
        this.cognomeSottoscritto = estraiUno(cognomi);
        this.nomeAvvocato = estraiUno(nomi);
        this.cognomeAvvocato = estraiUno(cognomi);
        this.nomeGiudice = estraiUno(nomi);
        this.cognomeGiudice = estraiUno(cognomi);
        this.nomeCuratore = estraiUno(nomi);
        this.cognomeCuratore = estraiUno(cognomi);
        this.indirizzo = estraiUno(indirizzi);
        this.telefono = estraiUno(telefoni);
        this.codiceFiscale = estraiUno(codiciFiscali);
        if (coin())
            this.email = nomeSottoscritto.substring(0, 1).toLowerCase() + "." + cognomeSottoscritto.toLowerCase().replaceAll("'", "") + "@libero.it";
        else
            this.email = nomeSottoscritto.toLowerCase() + "." + cognomeSottoscritto.toLowerCase().replaceAll("'", "") + "@gmail.it";
        this.numeroPratica = estraiUno(numeriRichieste);
        this.motivazioneRichiesta = estraiUno(motivazioni);
        this.NMotivazioneRichiesta = estraiUno(motivazioni);
        this.comuneTribunale = estraiUno(comuni);
        this.comuneNascita = estraiUno(comuni);
        this.comuneResidenza = estraiUno(comuni);
        this.dataOggi = estraiUno(datePostFine);
        this.dataNascita = estraiUno(dateNascita);
        this.dataInizio = estraiUno(dateInizio);
        this.dataFine = estraiUno(dateFine);
        this.numeroAllegati = (int) Math.round(Math.floor(Math.random() * 3)) + 1;
        this.valuta = estraiUno(valute);
        this.NValuta = estraiUno(valute);
        this.tipoRichiesta = estraiUno(tipiRichiesta);
        this.dataVerifica = estraiUno(dateFine);
        this.aziendaFallimento = estraiUno(aziendeFallite);
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

    public String getValuta() {
        return valuta;
    }

    public String getTipoRichiesta() {
        return tipoRichiesta;
    }

    public String getNomeCuratore() {
        return nomeCuratore;
    }

    public String getCognomeCuratore() {
        return cognomeCuratore;
    }

    public String getComuneResidenza() {
        return comuneResidenza;
    }

    public String getNValuta() {
        return NValuta;
    }

    public String getNMotivazioneRichiesta() {
        return NMotivazioneRichiesta;
    }

    public String getDataVerifica() {
        return dataVerifica;
    }

    public String getAziendaFallimento() {
        return aziendaFallimento;
    }
}
