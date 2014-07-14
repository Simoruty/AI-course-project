package it.uniba.di.ia.ius.gui;

import it.uniba.di.ia.ius.prologAPI.InterprologInterface;
import it.uniba.di.ia.ius.prologAPI.JPLInterface;
import it.uniba.di.ia.ius.prologAPI.NoVariableException;
import it.uniba.di.ia.ius.prologAPI.PrologInterface;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class MainWindow {

    private final JFrame frame;
    DefaultListModel defaultListModel;
    private JPLInterface JPLInterface;
    private InterprologInterface interprologInterface;
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

        defaultListModel = new DefaultListModel();

        jlist.setModel(defaultListModel);
        jlist.setCellRenderer(new MyListCellRenderer());
        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);

        resetButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                String message = "Reset all?";
                String title = "Reset";
                int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
                if (reply == JOptionPane.YES_OPTION) {
                    defaultListModel.clear();
                    textPane.setText("");
                }
            }
        });
    }

    private void run() {
        defaultListModel.clear();

//        PrologInterface pi = new JPLInterface(PrologInterface.SWI);
              PrologInterface pi = new InterprologInterface(PrologInterface.YAP);

        pi.consult(new File("prolog/main.pl"));
//        pi.retractAll("documento", Arrays.asList("_"));
//        pi.asserta("documento", Arrays.asList("\"" + textPane.getText() + "\""));


        java.util.List<String> daElaborare2 = new ArrayList<>(11);
        java.util.List<String> daElaborare3 = new ArrayList<>(11);
        java.util.List<String> daElaborare4 = new ArrayList<>(11);

        if (comuniCB.isSelected()) daElaborare2.add("comune");
        if (telCB.isSelected()) daElaborare2.add("tel");
        if (dateCB.isSelected()) daElaborare4.add("data");
        if (cfCB.isSelected()) daElaborare2.add("cf");
        if (richiestaValutaCB.isSelected()) daElaborare3.add("richiesta_valuta");
        if (soggettoCB.isSelected()) daElaborare3.add("soggetto");
        if (personeCB.isSelected()) daElaborare3.add("persona");
        if (curatoreCB.isSelected()) daElaborare3.add("curatore");
        if (giudiceCB.isSelected()) daElaborare3.add("giudice");
        if (numeroPraticaCB.isSelected()) daElaborare2.add("numero_pratica");
        if (eMailCB.isSelected()) daElaborare2.add("mail");

        for (String s : daElaborare2) {
            pi.asserta("vuole", Arrays.asList(s));
        }

        for (String s : daElaborare3) {
            pi.asserta("vuole", Arrays.asList(s));
        }
        for (String s : daElaborare4) {
            pi.asserta("vuole", Arrays.asList(s));
        }

        pi.statisfied("start", null);

        List<List<Map<String, String>>> lists = new ArrayList<>();
        java.util.List<Map<String, String>> listMap = null;
        for (String s : daElaborare2) {
            listMap = pi.allSolutions(s, Arrays.asList("ID", "Val"));
            lists.add(listMap);
        }

//        for (String s : daElaborare3) {
//            listMap = pi.allSolutions(s, Arrays.asList("ID", "Val", "Val2"));
//            lists.add(listMap);
//        }
////
//        for (String s : daElaborare4) {
//            listMap = pi.allSolutions(s, Arrays.asList("ID", "Val", "Val2", "Val3"));
//            lists.add(listMap);
//        }

        for (List<Map<String, String>> list : lists) {
            for (Map<String, String> solution : list) {
                if (solution.get("Val2")==null)
                    System.out.println(solution.get("ID") + " " + solution.get("Val"));
                else if (solution.get("Val3")==null)
                    System.out.println(solution.get("ID") + " " + solution.get("Val") + " " + solution.get("Val2"));
                else
                    System.out.println(solution.get("ID") + " " + solution.get("Val") + " " + solution.get("Val2") + " " + solution.get("Val3"));
            }
        }

        JOptionPane.showMessageDialog(null, "Tagger finished");
        pi.close();
    }

    private void addListeners() {
        extractButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                run();
            }
        });
    }

    private class MyListCellRenderer extends JLabel implements ListCellRenderer {
        public MyListCellRenderer() {
            setOpaque(true);
        }

        public Component getListCellRendererComponent(JList paramlist, Object value, int index, boolean isSelected, boolean cellHasFocus) {
            setText(value.toString());
            if (value.toString().contains("persona")) {
                setForeground(Color.BLACK);
                setBackground(Color.WHITE);
            }
            if (value.toString().contains("mail")) {
                setForeground(Color.BLUE);
                setBackground(Color.WHITE);
            }
            if (value.toString().contains("richiesta")) {
                setForeground(Color.RED);
                setBackground(Color.WHITE);
            }
            if (value.toString().contains("tel")) {
                setForeground(Color.GREEN);
                setBackground(Color.WHITE);
            }
            if (value.toString().contains("comune")) {
                setForeground(Color.ORANGE);
                setBackground(Color.WHITE);
            }
            if (value.toString().contains("date")) {
                setForeground(Color.magenta);
                setBackground(Color.WHITE);
            }
            if (value.toString().contains("cf")) {
                setForeground(Color.CYAN);
                setBackground(Color.WHITE);
            }
            return this;
        }
    }

}
