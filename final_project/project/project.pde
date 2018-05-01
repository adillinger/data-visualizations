import java.util.List;


List<UIElement> uiElements = new ArrayList<UIElement>();

void setup() {

    uiElements.add(new Keyboard());
    uiElements.add(new Text("Heatmap of Keyboard While Creating This Visualization", 50, width / 2, 60, color(50)));
    uiElements.add(new Graph((width / 4), height - 50));


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

    // line(mouseX, 0, mouseX, height);
    // line(0, mouseY, width, mouseY);
}
 