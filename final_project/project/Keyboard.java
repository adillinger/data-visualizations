import processing.core.*;

public class Keyboard implements UIElement {

    final int MARGIN = 100;
    final float SCALE_FACTOR = 0.20f;

    int[] pixels;

    PImage keyboardImage;
    PImage heatmap;

    int startX, endX, startY, endY;

    @Override
    public void start(PApplet p) {
        keyboardImage = p.loadImage("keyboard.png");
        keyboardImage.resize(Math.round(keyboardImage.width * SCALE_FACTOR),
                Math.round(keyboardImage.height * SCALE_FACTOR));

        heatmap = p.createImage(keyboardImage.width, keyboardImage.height + 30, p.ARGB);

        startX = ((p.width - keyboardImage.width) / 2);
        endX = (startX + (keyboardImage.width));
        startY = p.height - keyboardImage.height - MARGIN;
        endY = startY + keyboardImage.height;

        for (int x = 0; x < heatmap.width; x++) {
            for (int y = 0; y < heatmap.height; y++) {
                int index = x + y * heatmap.width;
                float sum = 0;

                for (Key key : Key.keys) {
                    float d = p.dist(x, y, key.position.x, key.position.y);
                    d = p.constrain(d, 0.1f, p.width * p.height);
                    sum += 2 * key.amount / d;
                }

                float scale = p.map(sum, 100, 500, 0, 1);

                int blue = p.color(0, 0, 255, sum > 200 ? 200 : 0);
                int red = p.color(255, 0, 0, sum > 200 ? 200 : 0);

                heatmap.pixels[index] = p.lerpColor(blue, red, scale);
            }
        }
    }

    @Override
    public void update(PApplet p) {
        p.image(keyboardImage, startX, startY);
        p.image(heatmap, startX, startY);

        int blue = p.color(0, 0, 255, 200);
        int red = p.color(255, 0, 0, 200);

        drawBar(p, endX + 20, startY, 30, keyboardImage.height, red, blue);
        p.fill(0);
        p.textSize(25);
        p.text(Key.max, endX + 60, startY + 25);
        p.text("1 click", endX + 60, endY - 5);

    }

    private PVector getAbsolutePosition(PApplet p, PVector position) {
        return new PVector(position.x + startX, position.y + (startY));
    }

    void drawBar(PApplet p, int x, int y, float w, float h, int c1, int c2) {
        p.noFill();
        for (int i = y; i <= y + h; i++) {
            float inter = p.map(i, y, y + h, 0, 1);
            int c = p.lerpColor(c1, c2, inter);
            p.stroke(c);
            p.line(x, i, x + w, i);
        }

        p.stroke(0);
        p.rect(x, y, w, h);
    }
}