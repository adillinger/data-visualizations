import java.util.List;


List<UIElement> uiElements = new ArrayList<UIElement>();

void setup() {

    uiElements.add(new Keyboard());
    uiElements.add(new Text("Heatmap of Keyboard While Creating This Visualization", 50, width / 2, 60, color(50)));

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

class Text implements UIElement {

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
        p.textAlign(CENTER, CENTER);
        p.fill(c);
        p.textSize(size);
        p.text(text, x, y);
        p.textAlign(LEFT);
    }
}

