package it.uniba.di.ia.ius.gui;

import it.uniba.di.ia.ius.prologAPI.InterprologInterface;
import it.uniba.di.ia.ius.prologAPI.JPLInterface;
import it.uniba.di.ia.ius.prologAPI.ParseList;
import it.uniba.di.ia.ius.prologAPI.PrologInterface;
import jpl.Term;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
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
    private JCheckBox personeCheckBox;
    private JCheckBox indirizziEMailCheckBox;
    private JCheckBox comuniCheckBox;
    private JCheckBox valutaCheckBox;
    private JCheckBox dateCheckBox;
    private JCheckBox codiciFiscaliCheckBox;
    private JCheckBox numeriDiTelefonoCheckBox;
    private JButton resetButton;
    private JPanel contentPane;

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

    private void addListeners() {
        extractButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                defaultListModel.clear();
//                PrologInterface pi = new JPLInterface(PrologInterface.SWI);
                PrologInterface pi = new InterprologInterface(PrologInterface.SWI);
                pi.consult(new File("prolog/main.pl"));

                System.out.println("SONO QUI");

                pi.retractAll("domanda", Arrays.asList("_"));

                System.out.println("SONO QUI");


                pi.asserta("domanda", Arrays.asList("\"" + textPane.getText() + "\""));

                System.out.println("SONO QUI");

                Map<String, String> map = pi.oneSolution("extract", Arrays.asList("ListaTag"));

                ParseList pl = new ParseList(map.get("ListaTag"), 0);
                for (Term t : pl.getElementsFromList()) {

                    if (indirizziEMailCheckBox.isSelected() && t.toString().contains("mail"))
                        defaultListModel.addElement(t);

                    if (personeCheckBox.isSelected() && t.toString().contains("persona"))
                        defaultListModel.addElement(t);

                    if (numeriDiTelefonoCheckBox.isSelected() && t.toString().contains("tel"))
                        defaultListModel.addElement(t);

                    if (comuniCheckBox.isSelected() && t.toString().contains("comune"))
                        defaultListModel.addElement(t);

                    if (valutaCheckBox.isSelected() && t.toString().contains("richiesta"))
                        defaultListModel.addElement(t);

                    if (dateCheckBox.isSelected() && t.toString().contains("date"))
                        defaultListModel.addElement(t);

                    if (codiciFiscaliCheckBox.isSelected() && t.toString().contains("cf"))
                        defaultListModel.addElement(t);
                }
                JOptionPane.showMessageDialog(null, "Tagger finished");
                pi.close();
            }
        });
    }

//    private void Interprolog_GUI() {
//
//        //Interprolog
//        interprologInterface = new InterprologInterface("prolog/main.pl", "", 0);
//
//        PrintWriter writer = null;
//        try {
//            writer = new PrintWriter("prolog/domanda.pl", "UTF-8");
//        } catch (FileNotFoundException e) {
//            e.printStackTrace();
//        } catch (UnsupportedEncodingException e) {
//            e.printStackTrace();
//        }
//        writer.println("domanda(" + "\"" + textPane.getText() + "\").");
//        writer.close();
//        // Interprolog
//        interprologInterface.consult("prolog/domanda.pl");
//        String listTag = interprologInterface.allSolutions();
//        interprologInterface.close();
//
//        File file = new File("prolog/domanda.pl");
//        file.delete();
//
//        defaultListModel.addElement(listTag);
//        System.out.println(listTag);
//
//        try {
//            writer = new PrintWriter("result", "UTF-8");
//            writer.println(listTag);
//            writer.close();
//        } catch (FileNotFoundException e) {
//            e.printStackTrace();
//        } catch (UnsupportedEncodingException e) {
//            e.printStackTrace();
//        }
//
////        ParseList pl = new ParseList(listTag,0);
////        for (Term t : pl.getElementsFromList()) {
////
////            if (indirizziEMailCheckBox.isSelected() && t.toString().contains("mail"))
////                defaultListModel.addElement(t);
////
////            if (personeCheckBox.isSelected() && t.toString().contains("persona"))
////                defaultListModel.addElement(t);
////
////            if (numeriDiTelefonoCheckBox.isSelected() && t.toString().contains("tel"))
////                defaultListModel.addElement(t);
////
////            if (comuniCheckBox.isSelected() && t.toString().contains("comune"))
////                defaultListModel.addElement(t);
////
////            if (valutaCheckBox.isSelected() && t.toString().contains("richiesta"))
////                defaultListModel.addElement(t);
////
////            if (dateCheckBox.isSelected() && t.toString().contains("date"))
////                defaultListModel.addElement(t);
////
////            if (codiciFiscaliCheckBox.isSelected() && t.toString().contains("cf"))
////                defaultListModel.addElement(t);
////        }
//        JOptionPane.showMessageDialog(null, "Tagger finished");
//    }


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
