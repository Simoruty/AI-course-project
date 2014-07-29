package it.uniba.di.ia.ius.gui;

import it.uniba.di.ia.ius.Tag;
import it.uniba.di.ia.ius.prologAPI.NoVariableException;
import it.uniba.di.ia.ius.prologAPI.PrologInterface;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.Arrays;
import java.util.Map;

public class Spiegazione {
    private final JFrame frame;
    private JTextPane spiegaTextPane;
    private JLabel imageLabel;
    private JPanel contentPane;

    public Spiegazione(Tag tag, PrologInterface pi) {
        frame = new JFrame("Spiegazione");
        frame.setContentPane(contentPane);
//        frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

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

        Dimension screenSize;
//        int width = 1000;
//        int height = 700;
//        screenSize = new Dimension(width, height);
//        frame.setSize(screenSize);

        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);

        spiegaTextPane.setText("");
        try {
            Map<String, String> res = pi.oneSolution("spiegaTutto", Arrays.asList(tag.getId(), "Spiegazione"));
            String spiegazione = res.get("Spiegazione");
            spiegazione = spiegazione.replaceAll("\r", "");
            spiegaTextPane.setText(spiegazione);

            imageLabel.setVerticalTextPosition(JLabel.BOTTOM);
            imageLabel.setHorizontalTextPosition(JLabel.CENTER);
            imageLabel.setHorizontalAlignment(JLabel.CENTER);
            imageLabel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));

            ImageIcon imgIcon = new ImageIcon("./img/" + tag.getId() + ".png");
            Image img = imgIcon.getImage();
            Image newimg = img.getScaledInstance(300, 500,  java.awt.Image.SCALE_SMOOTH);
            ImageIcon newIcon = new ImageIcon(img);
//            BufferedImage bi = new BufferedImage(img.getWidth(null), img.getHeight(null), BufferedImage.TYPE_INT_ARGB);
//            Graphics g = bi.createGraphics();
//            g.drawImage(img, 140, 199, imageW, imageH, null, null);
//            newIcon = new ImageIcon(bi);

            imageLabel.setIcon(newIcon);
        } catch (NoVariableException e) {
            e.printStackTrace();
        }
    }

    private void addListeners() {

    }
}
