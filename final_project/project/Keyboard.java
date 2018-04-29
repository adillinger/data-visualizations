import processing.core.*;

public class Keyboard implements UIElement {

    private int clicked = 0;

    final int MARGIN = 100;
    final float SCALE_FACTOR = 0.20f;

    PImage keyboardImage;

    @Override
    public void start(PApplet p) {
        keyboardImage = p.loadImage("keyboard.png");
        keyboardImage.resize(Math.round(keyboardImage.width * SCALE_FACTOR),
                Math.round(keyboardImage.height * SCALE_FACTOR));
    }

    @Override
    public void update(PApplet p) {
        p.image(keyboardImage, (p.width - keyboardImage.width) / 2, p.height - keyboardImage.height - MARGIN);

        float x = p.mouseX - (p.width - keyboardImage.width) / 2;
        float y = p.mouseY - (p.height - keyboardImage.height - MARGIN);
        p.fill(0);
        p.stroke(0);
        p.textSize(40);
        p.text("X: " + x, 70, 70);
        p.text("Y: " + y, 70, 110);

        p.fill(255, 0, 0);
        p.text("Clicked: " + clicked, 70, 150);
    }

    @Override
    public void mouseReleased(PApplet p) {
        // float x = p.mouseX - (p.width - keyboardImage.width) / 2;
        // float y = p.mouseY - (p.height - keyboardImage.height - MARGIN);

        // System.out.println("{\"x\":" + x + ",\"y\":" + y + "},");
        // clicked++;
    }

    @Override
    public void keyPressed(PApplet p, int keyCode) {
        float x = p.mouseX - (p.width - keyboardImage.width) / 2;
        float y = p.mouseY - (p.height - keyboardImage.height - MARGIN);
        if (keyCode == 32) {
            System.out.println("{\"x\":" + x + ",\"y\":" + y + "},");
            clicked++;
        }
    }
}