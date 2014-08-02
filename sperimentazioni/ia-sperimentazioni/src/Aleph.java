import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Aleph {
    private static String homeDir = System.getProperty("user.home");
    private static String datasetDir = "/dev/university/ia-ius-project/sperimentazioni/dataset/";
    private static String dir = "/dev/university/ia-ius-project/sperimentazioni/";


    private static String[] datasets = {"elsevier", "jmlr", "mlj", "svln"};
    private static List<String> facts = new ArrayList<>(68300);
    private static List<List<String>> examples = new ArrayList<>(10); //Lista di fold che contiene lista di esempi

    public static void main(String[] args) throws IOException {
        for (String dataset : datasets) {
            System.out.println("Begin dataset " + dataset);
            readExamples(dataset);
            readFacts(dataset);
            writeFN(dataset);
            writeB(dataset);
            writeYAP(dataset);
            facts = new ArrayList<>(68300);
            examples = new ArrayList<>(10);
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

                sb.append(":- consult('"+alg+".pl').\n");
                sb.append(":- read_all('"+dataset+"_f"+fold+"').\n");
                sb.append(":- induce.\n");
                sb.append(":- write_rules.\n");

                pwYap.println(sb.toString());
                pwYap.close();
            }

    }

    private static void readFacts(String dataset) throws IOException {
        BufferedReader brKB = new BufferedReader(new FileReader(homeDir + datasetDir + dataset + ".kb"));
        String row;
        while ((row = brKB.readLine()) != null) {
            facts.add(row);
        }
        brKB.close();
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
        sb.append(":- set(train_pos, '" + dataset + "_f" + fold + "_train.f').\n");
        sb.append(":- set(train_neg, '" + dataset + "_f" + fold + "_train.n').\n");
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
                PrintWriter trPos = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + "_train.f"));
                PrintWriter trNeg = new PrintWriter(new FileWriter(homeDir + dir + alg + "/" + dataset + "_f" + fold + "_train.n"));
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
                for (String fact : facts) {
                    pwB.println(fact);
                }
                pwB.close();
            }
    }

}
