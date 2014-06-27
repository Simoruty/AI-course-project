package it.uniba.di.ia.ius.gui;

import it.uniba.di.ia.ius.Prolog;
import jpl.*;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MainWindow {
    private Prolog prolog;
    private final JFrame frame;
    private JTextPane textPane;
    private JList jlist;
    private JButton extractButton;
    private JPanel contentPane;
    private JCheckBox personeCheckBox;
    private JCheckBox indirizziEMailCheckBox;
    private JCheckBox comuniCheckBox;
    private JCheckBox valutaCheckBox;
    private JCheckBox dateCheckBox;
    private JCheckBox codiciFiscaliCheckBox;
    private JCheckBox numeriDiTelefonoCheckBox;
    DefaultListModel defaultListModel;

    public MainWindow() {
        frame = new JFrame("MainWindow");
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

        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);

        prolog = new Prolog();
    }

    private void addListeners() {
        extractButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                defaultListModel.clear();
                prolog.consult(new Atom("prolog/main.pl"));
                prolog.retractAll("domanda", 1);
                Term toAssert = new Compound("domanda", new Term[]{ Util.textToTerm("\"" + textPane.getText() + "\"")} );
                prolog.asserta( toAssert );
                java.util.Hashtable<String, Term>[] hashtables = prolog.allSolutions(new Compound("nextTag", new Term[]{new Variable("Tag")}));
                for (int i = 0; i < hashtables.length; i++) {
                    Term t = hashtables[i].get("Tag");
                    if (t.isCompound())
//                        System.out.println(t);
                        defaultListModel.addElement(t);
                }
            }
        });
    }
}
