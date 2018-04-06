// Maxwell Chehab

ArrayList<UIElement> uiElements = new ArrayList<UIElement>();

void setup() {
    // If this doesn't work on your computer, you can remove the 'P3D'
    // parameter.  On many computers, having P3D should make it run faster
    size(1000, 600, P3D);
    uiElements.add(new Map(150, 100, 700, 400));
    uiElements.add(new TextBox("United States Wind Pattern", color(0), 225, 60, 42));
}

void draw() {
    for(UIElement element : uiElements) {
       element.update();
    }
}

int getWindowWidth() {
  return width;
}

int getWindowHeight() {
  return height;
}

interface UIElement {
    public PVector getPosition();
    public float getHeight();
    public float getWidth();
    public void update();
    public boolean isHovering(float x, float y);
}

class TextBox implements UIElement {
    private PVector position;
    private float width;
    private float height;
    private color c;
    private String text;
    private float size;

    public TextBox(String text, color c, float xPos, float yPos, float size) {
      this.position = new PVector(xPos, yPos);
      this.text = text;
      this.c = c;
      this.size = size;
    }

    public void update() {
      textSize(size);
      fill(c);
      text(text, position.x, position.y);
    } 

    boolean isHovering(float x, float y) {
      return (x >= getPosition().x && 
                x <= getPosition().x + getWidth() && 
                y >= getPosition().y && 
                y <= getPosition().y + getHeight());
    }

    public PVector getPosition() {
      return this.position;
    }

    public float getHeight() {
      return 0;
    }

    public float getWidth() {
      return 0;
    }
}

class Map implements UIElement {

    private PVector position;
    private float width;
    private float height;
    // An image to use for the background.  The image I provide is a
    // modified version of this wikipedia image:
    //https://commons.wikimedia.org/wiki/File:Equirectangular_projection_SW.jpg
    // If you want to use your own image, you should take an equirectangular
    // map and pick out the subset that corresponds to the range from
    // 135W to 65W, and from 55N to 25N
    private PImage img;

    // uwnd stores the 'u' component of the wind.
    // The 'u' component is the east-west component of the wind.
    // Positive values indicate eastward wind, and negative
    // values indicate westward wind.  This is measured
    // in meters per second.
    private Table uwnd;

    // vwnd stores the 'v' component of the wind, which measures the
    // north-south component of the wind.  Positive values indicate
    // northward wind, and negative values indicate southward wind.
    private Table vwnd;


    public ArrayList <Particle> particles = new ArrayList <Particle>();

    public Map(float xPos, float yPos, float width, float height) {
      this.position = new PVector(xPos, yPos);
      this.width = width;
      this.height = height;

      img = loadImage("background.png");
      uwnd = loadTable("uwnd.csv");
      vwnd = loadTable("vwnd.csv");
      setupParticles();
    }


    boolean isHovering(float x, float y) {
      return (x >= getPosition().x && 
                x <= getPosition().x + getWidth() && 
                y >= getPosition().y && 
                y <= getPosition().y + getHeight());
    }

    void drawMouseLine() {
        // Convert from pixel coordinates into coordinates
        // corresponding to the data.
        
        float mx = mouseX;
        float my = mouseY;
        float a = mx * uwnd.getColumnCount() / width;
        float b = my * uwnd.getRowCount() / height;
        a = map(a, getPosition().x, getPosition().x + getWidth(), 0, uwnd.getColumnCount());
        b = map(b, getPosition().y, getPosition().y + getHeight(), 0, uwnd.getRowCount());

        // Since a positive 'v' value indicates north, we need to
        // negate it so that it works in the same coordinates as Processing
        // does.
        float dx = readInterp(uwnd, a, b) * 10;
        float dy = -readInterp(vwnd, a, b) * 10;
        line(mouseX, mouseY, mouseX + dx, mouseY + dy);
    }

    void setupParticles() {
        for (int y = 0; y < 2000; y++) {
            particles.add(new Particle());
        }
    }

    // Reads a bilinearly-interpolated value at the given a and b
    // coordinates.  Both a and b should be in data coordinates.
    float readInterp(Table tab, float a, float b) {
        int x = int(a);
        int y = int(b);

        float xf = a - x;
        float yf = b - y;

        return (readRaw(tab, x, y) * (1 - xf) * (1 - yf) +
            readRaw(tab, x + 1, y) * (xf) * (1 - yf) +
            readRaw(tab, x, y + 1) * (1 - xf) * (yf) +
            readRaw(tab, x + 1, y + 1) * (xf) * (yf));
    }

    // Reads a raw value 
    float readRaw(Table tab, int x, int y) {
        if (x < 0) {
            x = 0;
        }
        if (x >= tab.getColumnCount()) {
            x = tab.getColumnCount() - 1;
        }
        if (y < 0) {
            y = 0;
        }

        if (y >= tab.getRowCount()) {
            y = tab.getRowCount() - 1;
        }
        return tab.getFloat(y, x);
    }

    public PVector getPosition() {
      return this.position;
    }

    public float getHeight() {
      return this.height;
    }

    public float getWidth() {
      return this.width;
    }

    public void update() {
        background(255);
        image(img, this.position.x, this.position.y, this.width, this.height);
        for (Particle p: particles) {
            p.run();
        }
        if(isHovering(mouseX, mouseY)) {
          drawMouseLine();
        }
    }

    class Particle {
        private PVector initialPosition;
        private float initialLifespan;

        private PVector position;
        private PVector velocity;
        private float lifespan;

        // private float speed;

        public Particle() {
            this.initialPosition = new PVector( random(getWidth()) + getPosition().x, 
                                                random(getHeight()) + + getPosition().y);
            this.velocity = new PVector(0, 0);
            this.initialLifespan = random(200);
            rebirth();
        }

        public void run() {
            if (lifespan > 0) {
                if (frameCount % 1 == 0) {
                    update();
                }
                display();
            } else {
                rebirth();
                run();
            }
        }

        private void rebirth() {
            position = initialPosition.copy();
            lifespan = initialLifespan;
        }

        // Method to update position
        public void update() {
            float posX = position.x * uwnd.getColumnCount() / getWidth();
            float posY = position.y * uwnd.getRowCount() / getHeight();
            posX = map(posX, getPosition().x, getPosition().x + getWidth(), 0, uwnd.getColumnCount());
            posY = map(posY, getPosition().y, getPosition().y + getHeight(), 0, uwnd.getRowCount());

            velocity.x = readInterp(uwnd, posX, posY);
            velocity.y = -readInterp(vwnd, posX, posY);
            position.add(velocity);
            lifespan -= 1;
        }

        public void display() {
            if(isHovering(position.x, position.y)) { 

                noStroke();
                fill(0, 0, 0);
                ellipse(position.x, position.y, 3, 3);
                stroke(0);
              }
            
        }
    }
}