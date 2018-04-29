import processing.core.*;

public interface UIElement {
    void start(PApplet p);

    void update(PApplet p);

    void mouseReleased(PApplet p);

    void keyPressed(PApplet p, int keyCode);
}