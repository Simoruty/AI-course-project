import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DatasetFormatter {
    private static boolean daDiscretizzare = true;
    private static String homeDir = System.getProperty("user.home");
    private static String datasetDir = "/dev/university/ia-ius-project/sperimentazioni/dataset/";
    private static String dir = "/dev/university/ia-ius-project/sperimentazioni/";

    //    private static String all
    private static String[] datasets = {"elsevier", "jmlr", "mlj", "svln"};
    //        private static String[] datasets = {"mlj"};
    private static SortedSet<String> positiviRAW;
    private static SortedSet<String> negativiRAW;
    private static SortedSet<String> fattiRAW;
    private static List<List<String>> examples; //Lista di fold che contiene lista di esempi
    private static List<List<String>> positivi; //Lista di fold che contiene lista di esempi
    private static List<List<String>> negativi; //Lista di fold che contiene lista di esempi
    private static SortedSet<String> documenti;
    private static SortedSet<String> pagine;
    private static TreeSet<String> frame;
    private static SortedSet<Fatto> fatti;

    private static List<Predicato> predicati;

    public static void main(String[] args) throws IOException {
        for (String dataset : datasets) {
            System.out.println("Begin dataset " + dataset);
            predicati = Predicato.allPredicati();
            fatti = new TreeSet<>();
            fattiRAW = new TreeSet<>();
            positivi = new ArrayList<>(10);
            positiviRAW = new TreeSet<>();
            negativi = new ArrayList<>(10);
            negativiRAW = new TreeSet<>();
            examples = new ArrayList<>(10);
            documenti = new TreeSet<>();
            pagine = new TreeSet<>();
            frame = new TreeSet<>();
            readDataset(dataset);
            fillObjects(dataset);
            readExamples(dataset);
            if ((daDiscretizzare) && (dataset.equals("mlj")))
                discretizza();

//            for (int i = 0; i < 10; i++) {
//                System.out.println("Fold"+i);
//                for (String pos : positivi.get(i)) {
//                    System.out.println("+"+pos);
//                }
//                for (String neg : negativi.get(i)) {
//                    System.out.println("-"+neg);
//                }
//            }


//            System.out.println(fatti.size());
//            System.out.println(fattiRAW.size());
//            System.out.println(positiviRAW.size());
//            System.out.println(positivi.size());
//            System.out.println(negativiRAW.size());
//            System.out.println(negativi.size());
//            System.out.println(examples.size());
//            System.out.println(documenti.size());
//            System.out.println(pagine.size());
//            System.out.println(frame.size());
//            writeFN(dataset);
//            writeB(dataset);
//            writeYAP(dataset);
            writeD(dataset);
        }
    }

    private static void fillObjects(String dataset) {
        for (String positive : positiviRAW)
            documenti.add(positive.replaceAll("^class_" + dataset + "\\((.+)\\)\\.$", "$1"));
        for (String negative : negativiRAW)
            documenti.add(negative.replaceAll("^class_" + dataset + "\\((.+)\\)\\.$", "$1"));

        Pattern arieta1 = Pattern.compile("^(.*)\\((.+)\\)\\.$");
        Pattern arieta2 = Pattern.compile("^(.*)\\((.+), (.+)\\)\\.$");
        for (String fattoRAW : fattiRAW) {
            Matcher m2 = arieta2.matcher(fattoRAW);
            Matcher m1 = arieta1.matcher(fattoRAW);
            if (m2.matches()) {
                String predicato = m2.group(1).trim();
                String arg1 = m2.group(2).trim();
                String arg2 = m2.group(3).trim();
                fatti.add(new Fatto(predicato, arg1, arg2));
                if (predicato.equals("numero_pagine")) documenti.add(arg1);
                if (predicato.equals("pagina_1")) {
                    documenti.add(arg1);
                    pagine.add(arg2);
                }
                if (predicato.equals("altezza_pagina")) pagine.add(arg1);
                if (predicato.equals("larghezza_pagina")) pagine.add(arg1);
                if (predicato.equals("frame")) {
                    pagine.add(arg1);
                    frame.add(arg2);
                }
                if (predicato.equals("altezza_rettangolo")) frame.add(arg1);
                if (predicato.equals("larghezza_rettangolo")) frame.add(arg1);
                if (predicato.equals("ascissa_rettangolo")) frame.add(arg1);
                if (predicato.equals("ordinata_rettangolo")) frame.add(arg1);
                if (predicato.equals("allineato_al_centro_orizzontale")) {
                    frame.add(arg1);
                    frame.add(arg2);
                }
                if (predicato.equals("allineato_al_centro_verticale")) {
                    frame.add(arg1);
                    frame.add(arg2);
                }
                if (predicato.equals("on_top")) {
                    frame.add(arg1);
                    frame.add(arg2);
                }
                if (predicato.equals("to_right")) {
                    frame.add(arg1);
                    frame.add(arg2);
                }
            } else if (m1.matches()) {
                String predicato = m1.group(1).trim();
                String arg1 = m1.group(2).trim();
                fatti.add(new Fatto(predicato, arg1));
                if (predicato.equals("ultima_pagina")) pagine.add(arg1);
                if (predicato.equals("tipo_immagine")) frame.add(arg1);
                if (predicato.equals("tipo_testo")) frame.add(arg1);
                if (predicato.equals("tipo_line_obbliqua")) frame.add(arg1);
                if (predicato.equals("tipo_line_orizzontale")) frame.add(arg1);
                if (predicato.equals("tipo_misto")) frame.add(arg1);
                if (predicato.equals("tipo_vuoto")) frame.add(arg1);
            }
        }
    }

    private static void readDataset(String dataset) throws IOException {
        File input = new File(homeDir + datasetDir + dataset + ".tun");
        BufferedReader br = new BufferedReader(new FileReader(input));

        String line;
        while ((line = br.readLine()) != null) {
            if (line.contains(":-")) {
                if (line.startsWith("neg")) {
                    negativiRAW.add(line.replaceAll("neg\\(", "").replaceAll("\\) :-", "."));
                } else {
                    positiviRAW.add(line.replaceAll(" :-", "."));
                }
            } else if (line.endsWith(").")) {
                fattiRAW.add(line.trim());
            } else if (line.trim() != "")
                fattiRAW.add(line.trim().replaceAll(",$", "."));
        }
        br.close();
    }


    private static void discretizza() {
        List<Fatto> daRimuovere = new ArrayList<>(5000);
        List<Fatto> daAggiungere = new ArrayList<>(5000);
        for (Fatto fatto : fatti) {
            if (fatto.getPredicato().equals("altezza_rettangolo")) {
                double altezza = Double.parseDouble(fatto.getArgomenti()[1]);
                if ((altezza >= 0) && (altezza <= 0.006)) {
                    daAggiungere.add(new Fatto("height_smallest", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.006) && (altezza <= 0.017)) {
                    daAggiungere.add(new Fatto("height_very_very_small", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.017) && (altezza <= 0.034)) {
                    daAggiungere.add(new Fatto("height_very_small", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.034) && (altezza <= 0.057)) {
                    daAggiungere.add(new Fatto("height_small", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.057) && (altezza <= 0.103)) {
                    daAggiungere.add(new Fatto("height_medium_small", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.103) && (altezza <= 0.160)) {
                    daAggiungere.add(new Fatto("height_medium", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.160) && (altezza <= 0.229)) {
                    daAggiungere.add(new Fatto("height_medium_large", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.229) && (altezza <= 0.406)) {
                    daAggiungere.add(new Fatto("height_large", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.406) && (altezza <= 0.571)) {
                    daAggiungere.add(new Fatto("height_very_large", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.571) && (altezza <= 0.777)) {
                    daAggiungere.add(new Fatto("height_very_very_large", fatto.getArgomenti()[0]));
                } else if ((altezza > 0.777) && (altezza <= 1)) {
                    daAggiungere.add(new Fatto("height_largest", fatto.getArgomenti()[0]));
                }
                daRimuovere.add(fatto);
            }


            if (fatto.getPredicato().equals("larghezza_rettangolo")) {
                double larghezza = Double.parseDouble(fatto.getArgomenti()[1]);
                if ((larghezza >= 0) && (larghezza <= 0.023)) {
                    daAggiungere.add(new Fatto("width_very_small", fatto.getArgomenti()[0]));
                } else if ((larghezza > 0.023) && (larghezza <= 0.047)) {
                    daAggiungere.add(new Fatto("width_small", fatto.getArgomenti()[0]));
                } else if ((larghezza > 0.047) && (larghezza <= 0.125)) {
                    daAggiungere.add(new Fatto("width_medium_small", fatto.getArgomenti()[0]));
                } else if ((larghezza > 0.125) && (larghezza <= 0.203)) {
                    daAggiungere.add(new Fatto("width_medium", fatto.getArgomenti()[0]));
                } else if ((larghezza > 0.203) && (larghezza <= 0.391)) {
                    daAggiungere.add(new Fatto("width_medium_large", fatto.getArgomenti()[0]));
                } else if ((larghezza > 0.391) && (larghezza <= 0.625)) {
                    daAggiungere.add(new Fatto("width_large", fatto.getArgomenti()[0]));
                } else if ((larghezza > 0.625) && (larghezza <= 1)) {
                    daAggiungere.add(new Fatto("width_very_large", fatto.getArgomenti()[0]));
                }
                daRimuovere.add(fatto);
            }


            if (fatto.getPredicato().equals("ascissa_rettangolo")) {
                double ascissa = Double.parseDouble(fatto.getArgomenti()[1]);
                if ((ascissa >= 0) && (ascissa <= 0.333)) {
                    daAggiungere.add(new Fatto("pos_left", fatto.getArgomenti()[0]));
                } else if ((ascissa > 0.333) && (ascissa <= 0.666)) {
                    daAggiungere.add(new Fatto("pos_center", fatto.getArgomenti()[0]));
                } else if ((ascissa > 0.666) && (ascissa <= 1)) {
                    daAggiungere.add(new Fatto("pos_right", fatto.getArgomenti()[0]));
                }
                daRimuovere.add(fatto);
            }


            if (fatto.getPredicato().equals("ordinata_rettangolo")) {
                double ordinata = Double.parseDouble(fatto.getArgomenti()[1]);
                if ((ordinata >= 0) && (ordinata <= 0.333)) {
                    daAggiungere.add(new Fatto("pos_upper", fatto.getArgomenti()[0]));
                } else if ((ordinata > 0.333) && (ordinata <= 0.666)) {
                    daAggiungere.add(new Fatto("pos_middle", fatto.getArgomenti()[0]));
                } else if ((ordinata > 0.666) && (ordinata <= 1)) {
                    daAggiungere.add(new Fatto("pos_lower", fatto.getArgomenti()[0]));
                }
                daRimuovere.add(fatto);
            }
        }

        fatti.removeAll(daRimuovere);
        fatti.addAll(daAggiungere);


        List<Predicato> toRemove = new ArrayList<>(4);
        for (Predicato predicato : predicati) {
            if (predicato.getPredicato().equals("altezza_rettangolo"))
                toRemove.add(predicato);
            if (predicato.getPredicato().equals("larghezza_rettangolo"))
                toRemove.add(predicato);
            if (predicato.getPredicato().equals("ascissa_rettangolo"))
                toRemove.add(predicato);
            if (predicato.getPredicato().equals("ordinata_rettangolo"))
                toRemove.add(predicato);
        }

        predicati.removeAll(toRemove);
        predicati.add(new Predicato("pos_upper", "Frame"));
        predicati.add(new Predicato("pos_middle", "Frame"));
        predicati.add(new Predicato("pos_lower", "Frame"));

        predicati.add(new Predicato("pos_left", "Frame"));
        predicati.add(new Predicato("pos_center", "Frame"));
        predicati.add(new Predicato("pos_right", "Frame"));

        predicati.add(new Predicato("height_smallest", "Frame"));
        predicati.add(new Predicato("height_very_very_small", "Frame"));
        predicati.add(new Predicato("height_very_small", "Frame"));
        predicati.add(new Predicato("height_small", "Frame"));
        predicati.add(new Predicato("height_medium_small", "Frame"));
        predicati.add(new Predicato("height_medium", "Frame"));
        predicati.add(new Predicato("height_medium_large", "Frame"));
        predicati.add(new Predicato("height_large", "Frame"));
        predicati.add(new Predicato("height_very_large", "Frame"));
        predicati.add(new Predicato("height_very_very_large", "Frame"));
        predicati.add(new Predicato("height_largest", "Frame"));

        predicati.add(new Predicato("width_very_small", "Frame"));
        predicati.add(new Predicato("width_small", "Frame"));
        predicati.add(new Predicato("width_medium_small", "Frame"));
        predicati.add(new Predicato("width_medium", "Frame"));
        predicati.add(new Predicato("width_medium_large", "Frame"));
        predicati.add(new Predicato("width_large", "Frame"));
        predicati.add(new Predicato("width_very_large", "Frame"));
    }

    private static void writeD(String dataset) throws IOException {

        String alg = "foil";
        for (int fold = 0; fold < 10; fold++) {

            StringBuilder sb = new StringBuilder(1300000);

            /*
             * SEZIONE 1: i tipi
             */

            sb.append("#Documento:");
            for (String d : documenti) {
                sb.append(" ");
                sb.append(d);
                sb.append(",");
            }
            sb.deleteCharAt(sb.length() - 1);
            sb.append(".\n");

            sb.append("#Pagina:");
            for (String p : pagine) {
                sb.append(" ");
                sb.append(p);
                sb.append(",");
            }
            sb.deleteCharAt(sb.length() - 1);
            sb.append(".\n");

            sb.append("#Frame:");
            for (String f : frame) {
                sb.append(" ");
                sb.append(f);
                sb.append(",");
            }
            sb.deleteCharAt(sb.length() - 1);
            sb.append(".\n");

            sb.append("NumeroPagine: continuous.\n");
            sb.append("LarghezzaPagina: continuous.\n");
            sb.append("AltezzaPagina: continuous.\n");
            if ((dataset.equals("mlj")) && (daDiscretizzare)) {
                sb.append("\n");
            } else {
                sb.append("AscissaRettangolo: continuous.\n");
                sb.append("OrdinataRettangolo: continuous.\n");
                sb.append("LarghezzaRettangolo: continuous.\n");
                sb.append("AltezzaRettangolo: continuous.\n\n");
            }

            /*
             * SEZIONE 2: le relazioni
             */

            sb.append("class_");
            sb.append(dataset);
            sb.append("(Documento)\n");

            List<String> trPos = new ArrayList<>();
            List<String> trNeg = new ArrayList<>();

            for (List<String> exampleOfFold : examples)
                if (examples.indexOf(exampleOfFold) != fold) {
                    for (String example : exampleOfFold)
                        if (!example.startsWith("-")) {
                            String id = example.replaceAll("^class_" + dataset + "\\((.+)\\)\\.$", "$1");
                            trPos.add(id);
                        } else {
                            String id = example.replaceAll("^-class_" + dataset + "\\((.+)\\)\\.$", "$1");
                            trNeg.add(id);
                        }
                }

            for (String pos : trPos)
                sb.append(pos + "\n");
            sb.append(";\n");
            for (String neg : trNeg) {
                sb.append(neg + "\n");
            }
            sb.append(".\n");


            for (Predicato p : predicati) {
                sb.append(p.getSignatureForD());
                sb.append("\n");
                sb.append(getListArgs(p.getPredicato()));
                sb.append(".\n");
            }

            sb.append("\n");

            /*
             * SEZIONE 3: Casi di test
             */

            sb.append("class_");
            sb.append(dataset);
            sb.append("\n");

            for (String doc : positivi.get(fold)) {
                sb.append(doc);
                sb.append(": +\n");
            }
            for (String doc : negativi.get(fold)) {
                sb.append(doc);
                sb.append(": -\n");
            }
            sb.append(".");

            File file = new File(homeDir + dir + alg + "/" + dataset + "/" + dataset + "_f" + fold + ".d");
            file.getParentFile().mkdirs();
            PrintWriter pwD = new PrintWriter(new FileWriter(file));
            pwD.println(sb.toString());
            pwD.close();
        }
    }

    private static String getListArgs(String predicato) {
        StringBuilder sb = new StringBuilder(2000);
        for (Fatto f : fatti) {
            if (f.getPredicato().equals(predicato)) {
                String[] args = f.getArgomenti();
                for (String arg : args) {
                    sb.append(arg + ", ");
                }
                sb.deleteCharAt(sb.length() - 1);
                sb.deleteCharAt(sb.length() - 1);
                sb.append("\n");
            }
        }
        return sb.toString();
    }

    private static void writeYAP(String dataset) throws IOException {
        for (String alg : new String[]{"aleph", "progol"})
            for (int fold = 0; fold < 10; fold++) {
                PrintWriter pwYap = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "/" + dataset + "_f" + fold + ".yap"));

                StringBuilder sb = new StringBuilder(200);
                sb.append("#!/usr/local/bin/yap -L --\n");
                sb.append("#\n");
                sb.append("# .\n");

                sb.append(":- consult('../" + alg + ".pl').\n");
                sb.append(":- read_all('" + dataset + "_f" + fold + "').\n");
                sb.append(":- induce.\n");
                sb.append(":- write_rules('" + dataset + "_f" + fold + ".rul').\n");

                pwYap.println(sb.toString());
                pwYap.close();
            }

    }

    private static void readExamples(String dataset) throws IOException {
        for (int fold = 0; fold < 10; fold++) {
            BufferedReader br = new BufferedReader(
                    new FileReader(homeDir + datasetDir + dataset + ".fold" + fold));

            List<String> examplesFold = new ArrayList<>(50);
            List<String> examplesFoldPos = new ArrayList<>(30);
            List<String> examplesFoldNeg = new ArrayList<>(30);

            String line;
            while ((line = br.readLine()) != null) {
                examplesFold.add(line);
                if (line.startsWith("-")) {
                    line = line.replace("-class_" + dataset + "(", "");
                    line = line.replace(").", "");
                    examplesFoldNeg.add(line);
                } else {
                    line = line.replace("class_" + dataset + "(", "");
                    line = line.replace(").", "");
                    examplesFoldPos.add(line);
                }
            }

            examples.add(examplesFold);
            positivi.add(examplesFoldPos);
            negativi.add(examplesFoldNeg);
            br.close();
        }
    }

    //TODO controllare i vari parametri
    private static String init(String dataset, int fold, boolean discretizzato) {
        StringBuilder sb = new StringBuilder();
        sb.append(":- set(cache_clauselength, 5).\n");
        sb.append(":- set(caching, true).\n");
        sb.append(":- set(check_useless, true).\n");
        sb.append(":- set(clauselength, 8). %max length of clauses\n");
        sb.append(":- set(clauses, 8). %max length of clauses when performing theory-level search\n");
        sb.append(":- set(depth, 15).\n");
        sb.append(":- set(i, 10). %numero massimo di possibili variabili nelle clausole\n");
        sb.append(":- set(minacc, 0.0). %accuratezza minima di ogni regola\n");
        sb.append(":- set(minpos, 2). % numero minimo di esempi positivi che una regola deve coprire. This can be used to prevent DatasetFormatter from adding ground unit clauses to the theory (by setting the value to 2).\n");
        sb.append(":- set(nodes, 50000).\n");
        sb.append(":- set(noise, 0). %Set an upper bound on the number of negative examples allowed to be covered by an acceptable clause.\n");
        sb.append("\n");
        sb.append(":- set(record, true).\n");
        sb.append(":- set(recordfile, './" + dataset + "_f" + fold + ".log').\n");
        sb.append(":- set(rulefile, './" + dataset + "_f" + fold + ".rul').\n");
//        sb.append(":- set(train_pos, '" + dataset + "_f" + fold + ".f').\n");
//        sb.append(":- set(train_neg, '" + dataset + "_f" + fold + ".n').\n");
        sb.append(":- set(test_pos, './" + dataset + "_f" + fold + "_test.f').\n");
        sb.append(":- set(test_neg, './" + dataset + "_f" + fold + "_test.n').\n");
        sb.append(":- set(thread, 8).\n");
        sb.append(":- set(verbosity, 0).\n");
        sb.append("\n");
        sb.append(":- modeh(*,class_" + dataset + "(+idd)).\n");
        sb.append("\n");
        sb.append(":- modeb(*,numero_pagine(+idd, #integer)).\n");
        sb.append(":- modeb(*,pagina_1(+idd, -idp)).\n");
        sb.append(":- modeb(*,ultima_pagina(+idp)).\n");
        sb.append(":- modeb(*,altezza_pagina(+idp, #float)).\n");
        sb.append(":- modeb(*,larghezza_pagina(+idp, #float)).\n");

        if (discretizzato) {
            sb.append(":- modeb(*,pos_upper(+idf)).\n");
            sb.append(":- modeb(*,pos_middle(+idf)).\n");
            sb.append(":- modeb(*,pos_lower(+idf)).\n");
            sb.append(":- modeb(*,pos_left(+idf)).\n");
            sb.append(":- modeb(*,pos_center(+idf)).\n");
            sb.append(":- modeb(*,pos_right(+idf)).\n");
            sb.append(":- modeb(*,height_smallest(+idf)).\n");
            sb.append(":- modeb(*,height_very_very_small(+idf)).\n");
            sb.append(":- modeb(*,height_very_small(+idf)).\n");
            sb.append(":- modeb(*,height_small(+idf)).\n");
            sb.append(":- modeb(*,height_medium_small(+idf)).\n");
            sb.append(":- modeb(*,height_medium(+idf)).\n");
            sb.append(":- modeb(*,height_medium_large(+idf)).\n");
            sb.append(":- modeb(*,height_large(+idf)).\n");
            sb.append(":- modeb(*,height_very_large(+idf)).\n");
            sb.append(":- modeb(*,height_very_very_large(+idf)).\n");
            sb.append(":- modeb(*,height_largest(+idf)).\n");
            sb.append(":- modeb(*,width_very_small(+idf)).\n");
            sb.append(":- modeb(*,width_small(+idf)).\n");
            sb.append(":- modeb(*,width_medium_small(+idf)).\n");
            sb.append(":- modeb(*,width_medium(+idf)).\n");
            sb.append(":- modeb(*,width_medium_large(+idf)).\n");
            sb.append(":- modeb(*,width_large(+idf)).\n");
            sb.append(":- modeb(*,width_very_large(+idf)).\n");
        } else {
            sb.append(":- modeb(*,ascissa_rettangolo(+idf, #float)).\n");
            sb.append(":- modeb(*,ordinata_rettangolo(+idf, #float)).\n");
            sb.append(":- modeb(*,altezza_rettangolo(+idf, #float)).\n");
            sb.append(":- modeb(*,larghezza_rettangolo(+idf, #float)).\n");
        }
        sb.append(":- modeb(*,frame(+idp, -idf)).\n");
        sb.append(":- modeb(*,tipo_immagine(+idf)).\n");
        sb.append(":- modeb(*,tipo_testo(+idf)).\n");
        sb.append(":- modeb(*,tipo_linea_obbliqua(+idf)).\n");
        sb.append(":- modeb(*,tipo_linea_orizzontale(+idf)).\n");
        sb.append(":- modeb(*,tipo_misto(+idf)).\n");
        sb.append(":- modeb(*,tipo_vuoto(+idf)).\n");
        sb.append(":- modeb(*,allineato_al_centro_orizzontale(+idf, -idf)).\n");
        sb.append(":- modeb(*,allineato_al_centro_verticale(+idf, -idf)).\n");
        sb.append(":- modeb(*,on_top(+idf, -idf)).\n");
        sb.append(":- modeb(*,to_right(+idf,idf)).\n");
        sb.append("\n");
        sb.append(":- determination(class_" + dataset + "/1, allineato_al_centro_orizzontale/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, allineato_al_centro_verticale/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, altezza_pagina/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, altezza_rettangolo/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, ascissa_rettangolo/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, frame/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, larghezza_pagina/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, larghezza_rettangolo/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, numero_pagine/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, on_top/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, ordinata_rettangolo/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, pagina_1/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, tipo_immagine/1).\n");
        sb.append(":- determination(class_" + dataset + "/1, tipo_linea_obbliqua/1).\n");
        sb.append(":- determination(class_" + dataset + "/1, tipo_linea_orizzontale/1).\n");
        sb.append(":- determination(class_" + dataset + "/1, tipo_misto/1).\n");
        sb.append(":- determination(class_" + dataset + "/1, tipo_testo/1).\n");
        sb.append(":- determination(class_" + dataset + "/1, tipo_vuoto/1).\n");
        sb.append(":- determination(class_" + dataset + "/1, to_right/2).\n");
        sb.append(":- determination(class_" + dataset + "/1, ultima_pagina/1).\n");
        return sb.toString();
    }

    public static void writeFN(String dataset) throws IOException {
        boolean c = new File(homeDir + dir + "aleph/" + dataset + "/").mkdir();
        boolean s = new File(homeDir + dir + "progol/" + dataset + "/").mkdir();
        for (String alg : new String[]{"aleph", "progol"})
            for (int fold = 0; fold < 10; fold++) {
                // write F and N files
                PrintWriter trPos = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "/" + dataset + "_f" + fold + ".f"));
                PrintWriter trNeg = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "/" + dataset + "_f" + fold + ".n"));
                PrintWriter tePos = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "/" + dataset + "_f" + fold + "_test.f"));
                PrintWriter teNeg = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "/" + dataset + "_f" + fold + "_test.n"));

                for (List<String> exampleOfFold : examples)
                    if (examples.indexOf(exampleOfFold) == fold)
                        for (String example : exampleOfFold)
                            if (example.startsWith("-"))
                                teNeg.println(example.replaceAll("^-", ""));
                            else
                                tePos.println(example);
                    else
                        for (String example : exampleOfFold)
                            if (example.startsWith("-"))
                                trNeg.println(example.replaceAll("^-", ""));
                            else
                                trPos.println(example);

                teNeg.close();
                tePos.close();
                trNeg.close();
                trPos.close();
            }
    }

    public static void writeB(String dataset) throws IOException {
        for (String alg : new String[]{"aleph", "progol"})
            for (int fold = 0; fold < 10; fold++) {
                //write B file
                PrintWriter pwB = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "/" + dataset + "_f" + fold + ".b"));
                if (dataset.equals("mlj"))
                    pwB.println(init(dataset, fold, daDiscretizzare));
                else
                    pwB.println(init(dataset, fold, false));

                for (Fatto fatto : fatti) {
                    pwB.println(fatto);
                }
                pwB.close();
            }
    }


}
