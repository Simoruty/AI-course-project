package it.uniba.di.ia.ius.gui;

import it.uniba.di.ia.ius.Predicato;
import it.uniba.di.ia.ius.Tag;
import it.uniba.di.ia.ius.prologAPI.InterprologInterface;
import it.uniba.di.ia.ius.prologAPI.JPLInterface;
import it.uniba.di.ia.ius.prologAPI.PrologInterface;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MainWindow {

    private final JFrame frame;
    private DefaultListModel<Tag> listModel;
    private PrologInterface pi;
    private JTextPane textPane;
    private JList jlist;
    private JButton extractButton;

    private JButton resetButton;
    private JPanel contentPane;

    private JCheckBox comuniCB;
    private JCheckBox telCB;
    private JCheckBox dateCB;
    private JCheckBox cfCB;
    private JCheckBox richiestaValutaCB;
    private JCheckBox soggettoCB;
    private JCheckBox personeCB;
    private JCheckBox curatoreCB;
    private JCheckBox giudiceCB;
    private JCheckBox numeroPraticaCB;
    private JCheckBox eMailCB;


    public MainWindow() {
        frame = new JFrame("Tagger ius");
        assert contentPane != null;
        frame.setContentPane(contentPane);
//        this.createMenu();
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

        try {
            UIManager.setLookAndFeel(
                    UIManager.getSystemLookAndFeelClassName());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (UnsupportedLookAndFeelException e) {
            e.printStackTrace();
        }

        this.addListeners();

        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        int width = screenSize.width - (screenSize.width / 5);
        int height = screenSize.height;
//        int width = 800;
        screenSize = new Dimension(width, height);
        frame.setSize(screenSize);

//        columnPanel.setLayout(new BoxLayout(columnPanel, BoxLayout.Y_AXIS));
//
//        style = logTextPane.addStyle("Logger Style", null);
//        logger = logTextPane.getStyledDocument();

        listModel = new DefaultListModel<>();

        jlist.setModel(listModel);
//        jlist.setCellRenderer(new MyListCellRenderer());

        jlist.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent evt) {
//                JList list = (JList) evt.getSource();
                if (evt.getClickCount() == 2) {
//                    int index = list.locationToIndex(evt.getPoint());
                    Tag tag = (Tag) jlist.getSelectedValue();
                    new Spiegazione(tag, pi);
                }
            }
        });
        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);

        openInterface();


//        ListCellRenderer renderer = new MyListCellRenderer();
//        jlist.setCellRenderer(renderer);

    }

    private void openInterface() {
        pi = new JPLInterface(PrologInterface.SWI);
//        pi = new InterprologInterface(PrologInterface.YAP);
    }

    private void closeInterface() {
        pi.close();
    }

    private void resetAll() {
        listModel.clear();
        textPane.setText("");
        comuniCB.setSelected(true);
        telCB.setSelected(true);
        dateCB.setSelected(true);
        cfCB.setSelected(true);
        richiestaValutaCB.setSelected(true);
        soggettoCB.setSelected(true);
        personeCB.setSelected(true);
        curatoreCB.setSelected(true);
        giudiceCB.setSelected(true);
        numeroPraticaCB.setSelected(true);
        eMailCB.setSelected(true);
        try {
            Process p = Runtime.getRuntime().exec(new String[]{"bash", "-c", "rm ./graph/*"});
            Process p1 = Runtime.getRuntime().exec(new String[]{"bash", "-c", "rm ./img/*"});
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void reset() {
        listModel.clear();
        try {
            Process p = Runtime.getRuntime().exec(new String[]{"bash", "-c", "rm ./graph/*"});
            Process p1 = Runtime.getRuntime().exec(new String[]{"bash", "-c", "rm ./img/*"});
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void run() {
        reset();
        closeInterface();
        openInterface();
        pi.consult(new File("prolog/main.pl"));
        String textCorrect = textPane.getText().replace("€", " euro").replace("$", " dollari");
//        pi.retractAll("doc", Arrays.asList("_"));
//        pi.asserta("kb:doc", Arrays.asList("\"" + textCorrect + "\""));
        pi.statisfied("assertDoc", Arrays.asList("\"" + textCorrect + "\""));
        List<Predicato> predicatoList = new ArrayList<>(11);
        predicatoList.add(new Predicato("comune", 2, comuniCB));
        predicatoList.add(new Predicato("tel", 2, telCB));
        predicatoList.add(new Predicato("data", 4, dateCB));
        predicatoList.add(new Predicato("cf", 2, cfCB));
        predicatoList.add(new Predicato("richiesta_valuta", 4, richiestaValutaCB));
        predicatoList.add(new Predicato("soggetto", 3, soggettoCB));
        predicatoList.add(new Predicato("persona", 3, personeCB));
        predicatoList.add(new Predicato("curatore", 3, curatoreCB));
        predicatoList.add(new Predicato("giudice", 3, giudiceCB));
        predicatoList.add(new Predicato("numero_pratica", 2, numeroPraticaCB));
        predicatoList.add(new Predicato("mail", 2, eMailCB));

        pi.statisfied("startJava", null);

        for (Predicato predicato : predicatoList) {
            List<Tag> tagList = predicato.run();
            for (Tag tag : tagList) {
                if(!tag.toString().contains("null"))
                    listModel.addElement(tag);
            }
        }

        File folder = new File("./graph/");
        File[] listOfFiles = folder.listFiles();

        for (File file : listOfFiles) {
            if (file.isFile()) {
                try {
                    String command = "dot -Tpng ./graph/" + file.getName() + " > ./img/" + file.getName().replaceFirst("[.][^.]+$", "") + ".png";
                    Process p = Runtime.getRuntime().exec(new String[]{"bash", "-c", command});
                } catch (IOException e) {
                    e.printStackTrace();
                }
                System.out.println(file.getName());
            }
        }

        JOptionPane.showMessageDialog(null, "Tagger finished");
    }


    private void addListeners() {
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        extractButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                run();
            }
        });

        resetButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                int reply = JOptionPane.showConfirmDialog(null, "Reset all?", "Reset", JOptionPane.YES_NO_OPTION);
                if (reply == JOptionPane.YES_OPTION) {
                    resetAll();
                }
            }
        });


        frame.addWindowListener(new WindowListener() {
            @Override
            public void windowOpened(WindowEvent e) {

            }

            @Override
            public void windowClosing(WindowEvent e) {
                closeInterface();
            }

            @Override
            public void windowClosed(WindowEvent e) {

            }


            @Override
            public void windowIconified(WindowEvent e) {

            }

            @Override
            public void windowDeiconified(WindowEvent e) {

            }

            @Override
            public void windowActivated(WindowEvent e) {

            }

            @Override
            public void windowDeactivated(WindowEvent e) {

            }
        });
    }

//    private class MyListCellRenderer extends JLabel implements ListCellRenderer {
//        public MyListCellRenderer() {
//            setOpaque(true);
//        }
//
//        public Component getListCellRendererComponent(JList paramlist, Object value, int index, boolean isSelected, boolean cellHasFocus) {
//            setText(value.toString());
//            if (value.toString().contains("persona") || value.toString().contains("soggetto") || value.toString().contains("giudice") || value.toString().contains("curatore")) {
//                setForeground(Color.BLACK);
//                setBackground(Color.WHITE);
//            }
//            if (value.toString().contains("mail")) {
//                setForeground(Color.BLUE);
//                setBackground(Color.WHITE);
//            }
//            if (value.toString().contains("richiesta_valuta")) {
//                setForeground(Color.RED);
//                setBackground(Color.WHITE);
//            }
//            if (value.toString().contains("tel")) {
//                setForeground(Color.GREEN);
//                setBackground(Color.WHITE);
//            }
//            if (value.toString().contains("comune")) {
//                setForeground(Color.ORANGE);
//                setBackground(Color.WHITE);
//            }
//            if (value.toString().contains("data")) {
//                setForeground(Color.magenta);
//                setBackground(Color.WHITE);
//            }
//            if (value.toString().contains("cf")) {
//                setForeground(Color.CYAN);
//                setBackground(Color.WHITE);
//            }
//            return this;
//        }
//    }

}
