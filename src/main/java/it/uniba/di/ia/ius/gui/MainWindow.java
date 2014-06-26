package it.uniba.di.ia.ius.gui;

import it.uniba.di.ia.ius.Prolog;
import jpl.Atom;
import jpl.Compound;
import jpl.Term;
import jpl.Util;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MainWindow {
    private Prolog prolog;
    private final JFrame frame;
    private JTextPane textPane1;
    private JList list1;
    private JButton extractButton;
    private JPanel contentPane;

    public MainWindow() {
        frame = new JFrame("MainWindow");
        frame.setContentPane(contentPane);
//        this.createMenu();
        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.pack();
        frame.setVisible(true);

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

        prolog = new Prolog();
    }

    private void addListeners() {
        extractButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                prolog.consult(new Atom("prolog/main.pl"));
                prolog.affirm(new Compound("domanda", new Term[]{Util.textToTerm("\"" + textPane1.getText() + "\"")}));
                prolog.oneSolution(new Compound("main", 0));
            }
        });
    }
}
