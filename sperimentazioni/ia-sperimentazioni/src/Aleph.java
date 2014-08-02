import java.io.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Aleph {
    private static String homeDir = System.getProperty("user.home");
    private static String datasetDir = "/dev/university/ia-ius-project/sperimentazioni/dataset/";
    private static String dir = "/dev/university/ia-ius-project/sperimentazioni/";

    //    private static String all
    private static String[] datasets = {"elsevier", "jmlr", "mlj", "svln"};
    private static List<String> positiviRAW;
    private static List<String> negativiRAW;
    private static List<String> fattiRAW;
    private static List<List<String>> examples; //Lista di fold che contiene lista di esempi
    private static Set<String> documenti;
    private static Set<Object> pagine;
    private static Set<Object> frame;
    private static List<Fatto> fatti;


    public static void main(String[] args) throws IOException {
        for (String dataset : datasets) {
            System.out.println("Begin dataset " + dataset);
            fattiRAW = new ArrayList<>(68300);
            positiviRAW = new ArrayList<>(122);
            negativiRAW = new ArrayList<>(292);
            examples = new ArrayList<>(10);
            documenti = new HashSet<>(355);
            pagine = new HashSet<>(355);
            frame = new HashSet<>(10000);
            fatti = new ArrayList<>(70000);
            readDataset(dataset);
            fillObjects(dataset);
            readExamples(dataset);
            writeFN(dataset);
            writeB(dataset);
            writeYAP(dataset);
            writeD(dataset);
        }
    }

    private static void fillObjects(String dataset) {
        for (String positive : positiviRAW)
            documenti.add(positive.replaceAll("^class_" + dataset + "\\((.+)\\)\\.$", "\\1"));
        for (String negative : negativiRAW)
            documenti.add(negative.replaceAll("^class_" + dataset + "\\((.+)\\)\\.$", "\\1"));

        Pattern arieta1 = Pattern.compile("^(.*)\\((.+)\\)\\.$");
        Pattern arieta2 = Pattern.compile("^(.*)\\((.+), (.+)\\)\\.$");
        for (String fattoRAW : fattiRAW) {
            Matcher m2 = arieta2.matcher(fattoRAW);
            Matcher m1 = arieta1.matcher(fattoRAW);
            if (m2.matches()) {
                String predicato = m2.group(1);
                String arg1 = m2.group(2);
                String arg2 = m2.group(3);
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
            }
            if (m1.matches()) {
                String predicato = m2.group(1);
                String arg1 = m2.group(2);
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

        Collections.sort(fattiRAW);
    }

    private static void writeD(String dataset) throws IOException {
        String alg = "foil";
        for (int fold = 0; fold < 10; fold++) {
            PrintWriter pwD = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + ".d"));

            pwD.print("#NomeDocumento: ");
            for (Fatto fatto : fatti) {
                //TODO non compila, sto lavorando
                !£$£"&" SYNTAX ERROR
                //TODO non compila, sto lavorando
            }




            pwD.print("#Pagina: ");

//            List<String> pagine =

            for (int i = 0; i < fattiRAW.size(); i++) {
                if (fattiRAW.get(i).startsWith("ultima_pagina")) {
                    String pagina = fattiRAW.get(i).replaceAll("^ultima_pagina\\((.+)\\)\\.$", "\\1");
                }
            }

            pwD.print(negativiRAW.get(0));
            for (int i = 1; i < negativiRAW.size(); i++) {
                pwD.print(", " + negativiRAW.get(i));
            }
            pwD.print(".\n");


            pwD.close();
        }
    }

    private static void writeYAP(String dataset) throws IOException {
        for (String alg : new String[]{"aleph", "progol"})
            for (int fold = 0; fold < 10; fold++) {
                PrintWriter pwYap = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + ".yap"));

                StringBuilder sb = new StringBuilder(200);
                sb.append("#!/usr/local/bin/yap -L --\n");
                sb.append("#\n");
                sb.append("# .\n");

                sb.append(":- consult('" + alg + ".pl').\n");
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

            String line;
            while ((line = br.readLine()) != null) {
                examplesFold.add(line);
            }

            examples.add(examplesFold);
            br.close();
        }
    }

    //TODO controllare i vari parametri
    private static String init(String dataset, int fold) {
        StringBuilder sb = new StringBuilder();
        sb.append(":- set(cache_clauselength, 5).\n");
        sb.append(":- set(caching, true).\n");
        sb.append(":- set(check_useless, true).\n");
        sb.append(":- set(clauselength, 8). %max length of clauses\n");
        sb.append(":- set(clauses, 8). %max length of clauses when performing theory-level search\n");
        sb.append(":- set(depth, 15).\n");
        sb.append(":- set(i, 10). %numero massimo di possibili variabili nelle clausole\n");
        sb.append(":- set(minacc, 0.0). %accuratezza minima di ogni regola\n");
        sb.append(":- set(minpos, 2). % numero minimo di esempi positivi che una regola deve coprire. This can be used to prevent Aleph from adding ground unit clauses to the theory (by setting the value to 2).\n");
        sb.append(":- set(nodes, 50000).\n");
        sb.append(":- set(noise, 0). %Set an upper bound on the number of negative examples allowed to be covered by an acceptable clause.\n");
        sb.append("\n");
        sb.append(":- set(record, true).\n");
        sb.append(":- set(recordfile, '" + dataset + "_f" + fold + ".log').\n");
        sb.append(":- set(rulefile, '" + dataset + "_f" + fold + ".rul').\n");
//        sb.append(":- set(train_pos, '" + dataset + "_f" + fold + ".f').\n");
//        sb.append(":- set(train_neg, '" + dataset + "_f" + fold + ".n').\n");
        sb.append(":- set(test_pos, '" + dataset + "_f" + fold + "_test.f').\n");
        sb.append(":- set(test_neg, '" + dataset + "_f" + fold + "_test.n').\n");
        sb.append(":- set(thread, 8).\n");
        sb.append(":- set(verbosity, 0).\n");
        sb.append("\n");
        sb.append("\n");
        sb.append(":- modeh(*,class_" + dataset + "(+idd)).\n");
        sb.append("\n");
        sb.append(":- modeb(*,numero_pagine(+idd, #integer)).\n");
        sb.append(":- modeb(*,pagina_1(+idd, -idp)).\n");
        sb.append(":- modeb(*,ultima_pagina(+idp)).\n");
        sb.append(":- modeb(*,altezza_pagina(+idp, #float)).\n");
        sb.append(":- modeb(*,larghezza_pagina(+idp, #float)).\n");
        sb.append("\n");
        sb.append(":- modeb(*,frame(+idp, -idf)).\n");
        sb.append(":- modeb(*,altezza_rettangolo(+idf, #float)).\n");
        sb.append(":- modeb(*,larghezza_rettangolo(+idf, #float)).\n");
        sb.append(":- modeb(*,ascissa_rettangolo(+idf, #float)).\n");
        sb.append(":- modeb(*,ordinata_rettangolo(+idf, #float)).\n");
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
        for (String alg : new String[]{"aleph", "progol"})
            for (int fold = 0; fold < 10; fold++) {
                // write F and N files
                PrintWriter trPos = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + ".f"));
                PrintWriter trNeg = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + ".n"));
                PrintWriter tePos = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + "_test.f"));
                PrintWriter teNeg = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + "_test.n"));

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
                PrintWriter pwB = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + ".b"));
                pwB.println(init(dataset, fold));
                for (String fact : fattiRAW) {
                    pwB.println(fact);
                }
                pwB.close();
            }
    }


}
