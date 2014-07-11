package it.uniba.di.ia.ius.gui;

import it.uniba.di.ia.ius.prologAPI.InterprologInterface;
import it.uniba.di.ia.ius.prologAPI.JPLInterface;
import it.uniba.di.ia.ius.prologAPI.PrologInterface;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
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

        PrologInterface pi = new JPLInterface(PrologInterface.SWI);
//              PrologInterface pi = new InterprologInterface(PrologInterface.YAP);

        pi.consult(new File("prolog/main.pl"));
//        pi.retractAll("documento", Arrays.asList("_"));
//        pi.asserta("documento", Arrays.asList("\"" + textPane.getText() + "\""));


        java.util.List<String> daElaborare = new ArrayList<String>(11);

        if (comuniCB.isSelected()) daElaborare.add("comune");
        if (telCB.isSelected()) daElaborare.add("tel");
        if (dateCB.isSelected()) daElaborare.add("data");
        if (cfCB.isSelected()) daElaborare.add("cf");
        if (richiestaValutaCB.isSelected()) daElaborare.add("richiesta_valuta");
        if (soggettoCB.isSelected()) daElaborare.add("soggetto");
        if (personeCB.isSelected()) daElaborare.add("persona");
        if (curatoreCB.isSelected()) daElaborare.add("curatore");
        if (giudiceCB.isSelected()) daElaborare.add("giudice");
        if (numeroPraticaCB.isSelected()) daElaborare.add("numero_pratica");
        if (eMailCB.isSelected()) daElaborare.add("mail");

        for (String s : daElaborare) {
            pi.asserta("vuole", Arrays.asList(s));
        }

        pi.statisfied("start", null);


        java.util.List<Map<String, String>> listMap = null;
        for (String s : daElaborare) {
            listMap = pi.allSolutions(s, Arrays.asList("X"));

            for (Map<String, String> solution : listMap) {
                System.out.println(solution.get("X"));
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
