package it.uniba.di.ia.ius.prologAPI;

import com.declarativa.interprolog.PrologEngine;
import com.declarativa.interprolog.SWISubprocessEngine;
import com.declarativa.interprolog.YAPSubprocessEngine;

import java.io.File;
import java.util.List;

public class Interprolog {

    private static PrologEngine engine;
    private static final int YAPENGINE = 0;
    private static final int SWIENGINE = 1;

    public Interprolog(String coreConsultPath, String prolog_path, int type) {

        if (type== YAPENGINE)
        engine = new YAPSubprocessEngine(prolog_path, true);
        else if (type == SWIENGINE)
        engine = new SWISubprocessEngine(prolog_path,true);

        engine.consultAbsolute(new File(coreConsultPath));
        System.err.println(engine.getPrologVersion());
    }

    public void close() {
        engine.shutdown();
    }

    public void addFiles(List<String> sourceFiles) {
        // loading files
        String load = "load_all(['";
        for (String file : sourceFiles) {
            load += (file + "','");
        }

        load = load.substring(0, load.length() - 2);
        load += "])";

        engine.deterministicGoal(load);
    }

    public boolean sendCommand(String command) {
        return engine.deterministicGoal(command);
    }

    public String oneSolution(String command, String var) {
        String query = command + "(" + var + ") , term_to_atom(" + var + ",Result)";
        System.out.println(query);
        Object[] result = engine.deterministicGoal(query, "[string(Result)]");
        return result[0].toString();
    }

    public void allSolutions() {

//        String goal = "domanda(X),extract(X,Y), term_to_atom(Y,Result)";
        String goal = "extract(\"ciao luciano quercia\",Y), term_to_atom(Y,Result)";
//String goal = "extract(\"TRIBUNALE CIVILE DI Bari All’Ill.mo Giudice Delegato al fallimento Giovanni Tarantini n. 618/2011 ISTANZA DI INSINUAZIONE ALLO STATO PASSIVO Il sottoscritto Quercia Luciano elettivamente domiciliato agli effetti del presente atto in via Federico II, 28 Recapito tel. 080-8989898 DICHIARA di essere creditore nei confronti della Ditta di cui sopra, della somma dovutagli per prestazioni di lavoro subordinato in qualità di operaio per il periodo dal 25/7/1999 al 12/2/2001. Totale avere 122 €. Come da giustificativi allegati. PERTANTO CHIEDE l’ammissione allo stato passivo della procedura in epigrafe dell’ importo di euro 122 chirografo oltre rivalutazione monetaria ed interessi di legge fino alla data di chiusura dello stato passivo e soli interessi legali fino alla liquidazione delle attività mobiliari da quantificarsi in sede di liquidazione, lì 9/6/2014 Luciano Quercia Si allegano 1. fattura n.12 PROCURA SPECIALE Delego a rappresentarmi e difendermi in ogni fase, anche di eventuale gravame, del presente giudizio, l’Avv.to Felice Soldano, conferendo loro, sia unitamente che disgiuntamente, ogni potere di legge, compreso quello di rinunciare agli atti ed accettare la rinuncia, conciliare, transigere, quietanzare, incassare somme, farsi sostituire, nominare altri difensori o domiciliatari, chiedere misure cautelari, promuovere procedimenti esecutivi ed atti preliminari ad essi, chiamare in causa terzi, proporre domande riconvenzionali e costituirsi. Eleggo domicilio presso lo studio del suddetto avv. Soldano Felice.\",Y), term_to_atom(Y,Result)";

        String sol=(String)(engine.deterministicGoal(goal,"[string(Result)]")[0]);
        System.out.println(sol);

//        String goal = "findall(_X,nextTag(_X),_L), buildTermModel(_L,ListModel)";
//
//        TermModel solutionVars = (TermModel) (engine.deterministicGoal(goal, "[ListModel]")[0]);
//        System.out.println(solutionVars.getChildCount());

//        System.out.println("Solution bindings list:"+solutionVars);

    }
}