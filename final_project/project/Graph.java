import processing.core.*;

public class Graph implements UIElement {

    private int x, y, blue, red;
    private char[] alphabet = "abcdefghijklmnopqrstuvwxyz".toCharArray();

    public Graph(int x, int y) {
        this.x = x;
        this.y = y;
    }

    @Override
    public void start(PApplet p) {
        blue = p.color(0, 0, 255, 200);
        red = p.color(255, 0, 0, 200);
    }

    @Override
    public void update(PApplet p) {
        int offset = 0;
        for (char c : alphabet) {
            p.textAlign(p.CENTER, p.CENTER);
            p.textSize(30);
            p.text(c, x + offset, y);
            p.textAlign(p.LEFT);

            int amount = Key.getKeyWithValue("" + c).amount;
            int height = Math.round(p.map(amount, Key.min, Key.max, 0, 400));

            drawBar(p, x + offset - 8, y - height - 30, 20, height, blue, red);

            offset += 40;
        }

        p.line(x - 40, y - 30, x + (alphabet.length * 40), y - 30);
    }

    void drawBar(PApplet p, int x, int y, int w, int h, int c1, int c2) {
        p.noFill();
        for (int i = y + h; i >= y; i--) {
            float inter = p.map(i, y + h, (y + h) - 100, 0, 1);
            int c = p.lerpColor(c1, c2, inter);
            p.stroke(c);
            p.line(x, i, x + w, i);
        }

        p.stroke(0);
        p.rect(x, y, w, h);
    }
}