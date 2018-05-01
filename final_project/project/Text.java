import processing.core.*;

public class Text implements UIElement {

    private String text;
    private int size, x, y, c;

    public Text(String text, int size, int x, int y, int c) {
        this.text = text;
        this.size = size;
        this.x = x;
        this.y = y;
        this.c = c;
    }

    @Override
    public void start(PApplet p) {
    }

    @Override
    public void update(PApplet p) {
        p.textAlign(p.CENTER, p.CENTER);
        p.fill(c);
        p.textSize(size);
        p.text(text, x, y);
        p.textAlign(p.LEFT);
    }
}
