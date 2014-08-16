import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class FoldSplitter {

    private static String homeDir = System.getProperty("user.home");
    private static String dir = "/dev/university/ia-ius-project/sperimentazioni/dataset/";
//    private static String[] datasets = {"elsevier", "jmlr", "mlj", "svln"};
    private static String[] datasets = {"mlj"};
    private static List<String> positives;
    private static List<String> negatives;
    private static List<String> facts;

    public static void main(String[] args) throws IOException {
        for (String dataset : datasets) {
            System.out.println("Begin dataset " + dataset);
            facts = new ArrayList<>(68300);
            positives = new ArrayList<>(122);
            negatives = new ArrayList<>(292);
            read(dataset);
            Collections.shuffle(positives);
            Collections.shuffle(negatives);
            split(dataset);
        }
    }

    private static int getNumPosInFold(String dataset, int fold) {
        switch (dataset) {
            case "elsevier":
                return new int[]{6, 6, 6, 6, 6, 6, 6, 6, 6, 7}[fold];
            case "jmlr":
                return 10;
            case "mlj":
                return new int[]{12, 12, 12, 12, 12, 12, 12, 12, 13, 13}[fold];
            case "svln":
                return 7;
        }
        assert false;
        return -1;
    }

    private static int getNumNegInFold(String dataset, int fold) {
        switch (dataset) {
            case "elsevier":
                return new int[]{29, 29, 29, 29, 29, 29, 29, 30, 30, 29}[fold];
            case "jmlr":
                return new int[]{25, 25, 25, 25, 25, 25, 25, 26, 26, 26}[fold];
            case "mlj":
                return new int[]{23, 23, 23, 23, 23, 23, 23, 24, 23, 23}[fold];
            case "svln":
                return new int[]{28, 28, 28, 28, 28, 28, 28, 29, 29, 29}[fold];
        }
        assert false;
        return -1;
    }

    private static void split(String dataset) throws FileNotFoundException {
        PrintWriter foldFiles[] = new PrintWriter[10];
        for (int fold = 0; fold < 10; fold++) {
            File foldFile = new File(homeDir + dir + dataset + ".fold" + fold);
            foldFiles[fold] = new PrintWriter(foldFile);
        }

        int cFold = 0;
        int cPos = 0;
        for (String positive : positives) {
            foldFiles[cFold].println(positive);
            cPos++;
            if (cPos == getNumPosInFold(dataset, cFold)) {
                cPos = 0;
                cFold++;
            }
        }

        assert cFold == 9;
        assert cPos == 0;

        cFold = 0;
        int cNeg = 0;
        for (String negative : negatives) {
            foldFiles[cFold].println("-" + negative);
            cNeg++;
            if (cNeg == getNumNegInFold(dataset, cFold)) {
                cNeg = 0;
                cFold++;
            }
        }

        assert cFold == 9;
        assert cNeg == 0;

        for (int fold = 0; fold < 10; fold++) {
            foldFiles[fold].close();
        }
    }

    private static void read(String dataset) throws IOException {
        File input = new File(homeDir + dir + dataset + ".tun");
        BufferedReader br = new BufferedReader(new FileReader(input));

        String line;
        while ((line = br.readLine()) != null) {
            if (line.contains(":-")) {
                if (line.startsWith("neg")) {
                    negatives.add(line.replaceAll("neg\\(", "").replaceAll("\\) :-", "."));
                } else {
                    positives.add(line.replaceAll(" :-", "."));
                }
            } else if (line.endsWith(").")) {
                facts.add(line.trim());
            } else if (line.trim() != "")
                facts.add(line.trim().replaceAll(",$", "."));
        }
        br.close();

        Collections.sort(facts);
    }
}