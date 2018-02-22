import processing.opengl.*;

Globe globe;
Mouse mouse = new Mouse();
float scale = 0;

void setup() {
    size(1200,800, OPENGL);
    background(0);
    globe = new Globe(300, new Vector3(width / 2, height / 2, 0), new Vector3(0, 0, 0));
}

void draw() {
    background(0);
    globe.draw(scale);
}

void mousePressed() {
    mouse.set(mouseX, mouseY);
}

void mouseWheel(MouseEvent event) {
    scale += event.getCount() > 0 ? 10 : -10;
    scale = constrain(scale, 0, 320);
}

void mouseDragged() {
    Mouse currentMouse = new Mouse(mouseX, mouseY);
    globe.drag(mouse, currentMouse, scale);
    mouse = currentMouse;
}

class Globe {
    public Vector3 position, rotation;
    private PShape globe;
    private PImage texture;

    public Globe(float radius, Vector3 position, Vector3 rotation) {
        texture = loadImage("earth.jpg");
        this.position = position;
        this.rotation = rotation;
        globe = createShape(SPHERE, radius);
        globe.setTexture(texture);
        globe.setStroke(color(0, 0, 0, 0)); 
    }

    private void draw(float scale) { 
        pushMatrix();
        translate(position.x, position.y, position.z + scale);
        rotateX(rotation.x);
        rotateY(rotation.y);
        rotateZ(rotation.z);
        shape(globe);
        popMatrix();
    }

    public void drag(Mouse mouseA, Mouse mouseB, float scale) {
        scale = map(scale, 0, 320, 1, 0.2f);
        if (mouseA.y > mouseB.y) rotation.x += 0.05f * scale;
        if (mouseA.y < mouseB.y) rotation.x -= 0.05f * scale;
        if (mouseA.x < mouseB.x) rotation.y += 0.05f * scale;
        if (mouseA.x > mouseB.x) rotation.y -= 0.05f * scale;
    }
}

class Vector3 { 
    public float x, y, z;

    public Vector3(float x, float y, float z) {
        this.x = x;
        this.y = y; 
        this.z = z;
    }
}

class Mouse {
    float x, y;

    public Mouse() {
        this.x = 0;
        this.y = 0;
    }

    public Mouse(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void set(float x, float y) {
        this.x = x;
        this.y = y;
    }
}
