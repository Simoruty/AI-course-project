package it.uniba.di.ia.ius.gui;

import it.uniba.di.ia.ius.Tag;
import it.uniba.di.ia.ius.prologAPI.NoVariableException;
import it.uniba.di.ia.ius.prologAPI.PrologInterface;

import javax.swing.*;
import java.awt.*;
import java.util.Arrays;
import java.util.Map;

public class Spiegazione {
    private final JFrame frame;
    private JTextPane spiegaTextPane;
    private JLabel image;
    private JPanel contentPane;

    public Spiegazione(Tag tag, PrologInterface pi) {
        frame = new JFrame("Spiegazione");
        frame.setContentPane(contentPane);
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
        int width = 500;
        int height = 500;
        screenSize = new Dimension(width, height);
        frame.setSize(screenSize);

        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);

        spiegaTextPane.setText("");
        try {
            Map<String, String> res = pi.oneSolution("kb:spiegaTutto", Arrays.asList(tag.getId(), "Spiegazione"));
            String spiegazione = res.get("Spiegazione");
            spiegazione = spiegazione.replace("\r", "");
            spiegaTextPane.setText(spiegazione);
            image = new JLabel(new ImageIcon("./prolog/spiegazioni/" + tag.getId() + ".png"));
        } catch (NoVariableException e) {
            e.printStackTrace();
        }
    }

    private void addListeners() {

    }
}
