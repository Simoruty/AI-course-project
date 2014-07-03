package it.uniba.di.ia.ius;

import java.io.File;
import java.util.List;
import com.declarativa.interprolog.PrologEngine;
import com.declarativa.interprolog.TermModel;
import com.declarativa.interprolog.YAPSubprocessEngine;

/**
 * Created by simo
 */

public class Interprolog {

        private static PrologEngine engine;

        public Interprolog(String coreConsultPath, String prolog_path) {

            engine = new YAPSubprocessEngine(prolog_path, true);
            engine.consultAbsolute(new File(coreConsultPath));
            System.err.println(engine.getPrologVersion());
        }

        public void close(){
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

        public String sendCommand(String command, String var) {
            String query = command + "(" + var + ") , term_to_atom("+var+",Result)";
            System.out.println(query);
            Object[] result = engine.deterministicGoal(query, "[string(Result)]");
            return result[0].toString();

//            TermModel list = (TermModel)bindings1[0];
//            System.out.println("Here is the result:"+list);
//            if (list.isList()) {
//                System.out.println(list.getChild(1).toString());
//            }
        }
}