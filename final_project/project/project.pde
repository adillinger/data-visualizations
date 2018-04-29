import java.util.List;


List<UIElement> uiElements = new ArrayList<UIElement>();

void setup() {
    uiElements.add(new Keyboard());

    for(UIElement e : uiElements){
        e.start(this);
    }

    fullScreen();
}

void draw() {
    background(255);
    for(UIElement e : uiElements){
        e.update(this);
    }

    line(mouseX, 0, mouseX, height);
    line(0, mouseY, width, mouseY);
}

void mouseReleased() {
    for(UIElement e : uiElements){
        e.mouseReleased(this);
    }
}

void keyPressed() {
    for(UIElement e : uiElements){
        e.keyPressed(this, keyCode);
    }
}
