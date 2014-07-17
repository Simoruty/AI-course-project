package it.uniba.di.ia.ius;

public class GeneratoreDataset {

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            System.out.println(modulo1(new InfoModulo()));
        }
    }

    public static String modulo1(InfoModulo info) {
        StringBuilder sb = new StringBuilder();
        sb.append("TRIBUNALE CIVILE DI ");
        sb.append(info.getComuneTribunale());
        sb.append("\nAll’Ill.mo Giudice Delegato al fallimento ");
        sb.append(info.getCognomeGiudice() + " " + info.getNomeGiudice());
        sb.append("\nn. pratica ");
        sb.append(info.getNumeroPratica());
        sb.append("\nISTANZA DI INSINUAZIONE ALLO STATO PASSIVO\n");
        sb.append("\nIl sottoscritto, ");
        sb.append(info.getCognomeSottoscritto() + " " + info.getNomeSottoscritto());
        sb.append(", nato a ");
        sb.append(info.getComuneNascita());
        sb.append(" il ");
        sb.append(info.getDataNascita());
        sb.append(", elettivamente domiciliato agli effetti del presente atto in ");
        sb.append(info.getIndirizzo());
        sb.append("\nRecapito tel. ");
        sb.append(info.getTelefono());
        sb.append(", Codice Fiscale: ");
        sb.append(info.getCodiceFiscale());
        sb.append(", indirizzo e-mail ");
        sb.append(info.getEmail());
        sb.append("\nDICHIARA\ndi essere creditore nei confronti della Ditta di cui sopra, della somma dovutagli per ");
        sb.append(info.getMotivazioneRichiesta());
        sb.append(" per il periodo dal ");
        sb.append(info.getDataInizio());
        sb.append(" al ");
        sb.append(info.getDataFine());
        sb.append(".\nTotale avere: ");
//        sb.append();
        sb.append(". Come da giustificativi allegati.\nPERTANTO CHIEDE\nl’ammissione allo stato passivo della ");
        sb.append("procedura in epigrafe dell’importo di ");
//        sb.append();
//        sb.append();
        sb.append(" oltre rivalutazione monetaria ed interessi di legge fino alla data di chiusura dello stato ");
        sb.append("passivo e soli interessi legali fino alla liquidazione delle attività mobiliari da quantificarsi ");
        sb.append("in sede di liquidazione,\n");
        sb.append(info.getComuneTribunale());
        sb.append(", lì ");
        sb.append(info.getDataOggi());
        sb.append("\n");
        sb.append(info.getCognomeSottoscritto() + " " + info.getNomeSottoscritto());
        sb.append("\nSi allegano ");
        sb.append(info.getNumeroAllegati());
        sb.append(" documenti:");
        for (int idx = 1; idx <= info.getNumeroAllegati(); idx++) {
            sb.append("\nfattura n. " + idx);
        }
        sb.append("\nPROCURA SPECIALE\nDelego a rappresentarmi e difendermi in ogni fase, anche di eventuale gravame,");
        sb.append("del presente giudizio, l’Avv.to ");
        sb.append(info.getCognomeAvvocato() + " " + info.getNomeAvvocato());
        sb.append(", conferendo loro, sia unitamente che disgiuntamente, ogni potere di legge, compreso quello di ");
        sb.append("rinunciare agli atti ed accettare la rinuncia, conciliare, transigere, quietanzare, incassare ");
        sb.append("somme, farsi sostituire, nominare altri difensori o domiciliatari, chiedere misure cautelari, ");
        sb.append("promuovere procedimenti esecutivi ed atti preliminari ad essi, chiamare in causa terzi, proporre ");
        sb.append("domande riconvenzionali e costituirsi. Eleggo domicilio presso lo studio del suddetto avv. ");
        sb.append(info.getCognomeAvvocato() + " " + info.getNomeAvvocato());
        sb.append("\n");
        return sb.toString();
    }
}
