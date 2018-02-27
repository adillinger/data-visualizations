// import processing.opengl.*;
import java.util.Calendar;
import java.util.Date;

Globe globe;
PImage lightEarth, darkEarth;
Timeline timeline = new Timeline();
Mouse mouse = new Mouse();
float scale = 0;
Vector3 offset = new Vector3(0, 0, 0.0);
Toggler toggler;
Map map;
Pin[] pins = new Pin[]{};
Scale magnitudeScale = new Scale();
Magnitude MagnitudeColor = new Magnitude();

public class Magnitude {
    public final color High = color(182,65,26);
    public final color Medium = color(238,195,216);
    public final color Low = color(138,43,226);
}

void setup() {
    cursor(HAND);
    textSize(20);
    // size(1200, 1000, P3D);
    fullScreen(P3D);
    background(0);
    lightEarth = loadImage("earth-light.jpg");
    darkEarth = loadImage("earth-dark.png");
    toggler = new Toggler();
    globe = new Globe(300, new Vector3(width / 2, height / 2, 0), new Vector3(0, 0, 0));
    map = new Map();
    createPinArray(300);
}

void draw() {
    background(0);

    if(toggler.status) {
        directionalLight(255, 255, 255, 0.4f, 0.2f, -2f);
        globe.draw(scale);
    } else {
        map.draw();
    }
    fill(255, 0, 0);
    text("Framerate: " + round(frameRate), 20, 30);
    timeline.draw();
    toggler.draw();
    magnitudeScale.draw();
}

void mousePressed() {
    cursor(MOVE);
    mouse.set(mouseX, mouseY);
    if (timeline.isHovering()) {
        timeline.drag();
    }
}

void mouseReleased() {
    cursor(HAND);
}

void mouseClicked() {
    if (toggler.isHovering()) {
        toggler.status = !toggler.status;
    }
}

void mouseWheel(MouseEvent event) {
    if(toggler.status) {
        scale += event.getCount() > 0 ? 10 : -10;
        scale = constrain(scale, 0, 500);
    }
}

void mouseDragged() {
    Mouse currentMouse = new Mouse(mouseX, mouseY);

    if(!timeline.isHovering() && !toggler.isHovering() && toggler.status) {
        globe.drag(mouse, currentMouse, scale);
        mouse = currentMouse;
    } else if (timeline.isHovering()) {
        timeline.drag();
    }
}

void createPinArray(float radius) {
    // int h = height - toggler.w - 60;
    // int w = (h * lightEarth.width) / lightEarth.height;

    // this.pins = new Pin[] {new Pin(1955, 1, -28.334493, 153.549068, radius, w, h, 20,  (height - h) / 2),
    // new Pin(1955, 1, 26.8206, 30.8025, radius, w, h, 20, (height - h) / 2)};
    Table data = loadTable("data.csv");
    for(TableRow row : data.rows()) {
        // icat,asol,isol,yr,mon,day,hr,min,sec,glat,glon,dep,greg,ntel,mag
        // 0    1    2    3  4   5   6  7   8   9    10   11  12   13   14
        int year = row.getInt(3);
        float latitude = row.getInt(9);
        float longitude = row.getInt(10);
        int magnitude = row.getInt(14);
        int h = height - toggler.w - 60;
        int w = (h * lightEarth.width) / lightEarth.height;

    pins = (Pin[]) append(pins, new Pin(year, magnitude, latitude, longitude, radius, w, h, 20, 20));
    }
}

void keyPressed(KeyEvent event) {
    if(event.getKeyCode() == 40) offset.x += 10;
    if(event.getKeyCode() == 38) offset.x -= 10;
    if(event.getKeyCode() == 37) offset.y += 100;
    if(event.getKeyCode() == 39) offset.y -= 100;
    if(event.getKeyCode() == 65) offset.z += .1;
    if(event.getKeyCode() == 68) offset.z -= .1;
}

class UiElement {
    public boolean isHovering () {
        return false;
    }
}

class Map {
    private final int margin = 20;
    public void draw() {
        pushMatrix();
        hint(DISABLE_DEPTH_TEST);
        int h = height - toggler.w - (3 * margin);
        int w = (h * lightEarth.width) / lightEarth.height;

        image(lightEarth, margin, margin, w, h);
        


        fill(255);
        hint(ENABLE_DEPTH_TEST);
        popMatrix();

        for(Pin pin : pins) {
            if(pin.year ==  timeline.year) {
                pin.draw2D();    
            }
        }

        hint(DISABLE_DEPTH_TEST);
        fill(0);
        rect(0,0, margin, height);
        fill(255);
        hint(ENABLE_DEPTH_TEST);
    }
}

class Scale extends UiElement {
    public final int w = 200, h = 200;
    public final int margin = 20;

    public boolean isHovering() {
        return (mouseX >= width - margin - w && mouseX <=  width - margin && mouseY >=  toggler.h + (2 * margin) && mouseY <=  toggler.h + (2 * margin) + h);
    }

    public void draw() {
        pushMatrix();
        hint(DISABLE_DEPTH_TEST);

        rectMode(CORNERS);
        noStroke();
        fill(63, 133, 239, isHovering() ? 255 : 100);
        rect(width - margin - w, toggler.h + (2 * margin), width - margin, toggler.h + (2 * margin) + h );
        fill(58, 115, 219, isHovering() ? 255 : 100);
        rect(width - margin - w, toggler.h + (2 * margin), width - margin, toggler.h + (2 * margin) + 30);
        fill(221,221,221, isHovering() ? 255 : 100);

        textAlign(CENTER);
        text("Render Type", width - margin - (w / 2),  toggler.h + (2 * margin) + 22);

        stroke(0);
        fill(MagnitudeColor.High);
        rect(width - margin - w + 20, toggler.h + (2 * margin) + 50, width -margin - w + 80, toggler.h + (2 * margin) + 80);
        fill(MagnitudeColor.Medium);
        rect(width - margin - w + 20, toggler.h + (2 * margin) + 100, width -margin - w + 80, toggler.h + (2 * margin) + 130);
        fill(MagnitudeColor.Low);
        rect(width - margin - w + 20, toggler.h + (2 * margin) + 150, width -margin - w + 80, toggler.h + (2 * margin) + 180);
        fill(255);
        text(">= 9", width - margin - w + 120, toggler.h + (2 * margin) + 70);
        text(">= 5", width - margin - w + 120, toggler.h + (2 * margin) + 120);
        text(">= 0", width - margin - w + 120, toggler.h + (2 * margin) + 170);


        tint(255,255);
        fill(255);
        stroke(0);
        strokeWeight(1);
        textAlign(LEFT);
        hint(ENABLE_DEPTH_TEST);
        popMatrix();
    }
    
}

class Toggler extends UiElement {
    public final int w = 200, h = 260;
    private PImage globeImage, mapImage;
    public boolean status = false;
    public final int margin = 20;

    public boolean isHovering() {
        return (mouseX >= width - margin - w && mouseX <=  width - margin && mouseY >=  margin && mouseY <=  margin + h);
    }

    public Toggler() {
        globeImage = loadImage("globe.png");
        mapImage = loadImage("map.png");
    }

    public void draw(){
        pushMatrix();
        hint(DISABLE_DEPTH_TEST);

        rectMode(CORNERS);
        noStroke();
        fill(63, 133, 239, isHovering() ? 255 : 100);
        rect(width - margin - w, margin, width - margin, margin + h);
        fill(58, 115, 219, isHovering() ? 255 : 100);
        rect(width - margin - w, margin, width - margin, margin + 30);
        fill(221,221,221, isHovering() ? 255 : 100);

        textAlign(CENTER);
        text("Render Type", width - margin - (w / 2),  margin + 22);
        text("Click to Toggle", width - margin - (w / 2),  margin + h - 12);
        tint(255, isHovering() ? 255 : 100);
        if(status) {
            image(globeImage, width - margin - w + 10, margin + 40, w - 20, w - 20);
        } else {
            image(mapImage, width - margin - w + 5, margin + 40, w - 20, w - 20);
        }

        tint(255,255);
        fill(255);
        stroke(0);
        strokeWeight(1);
        textAlign(LEFT);
        hint(ENABLE_DEPTH_TEST);
        popMatrix();
    }
}

class Timeline extends UiElement {
    
    private final int margin = 20;
    private final int size = 75;
    private float year = 1955;

    public boolean isHovering() {
        float slidderX = map(year, 1900, 2007, margin + 40, width - margin - 40) - 60;
        return ((mouseX >= margin && mouseX <= 
            width - margin && mouseY <= 
            height - (2 * margin) && mouseY >= 
            height - margin - size) || 
            (mouseX >= slidderX && 
            mouseX <= slidderX + 120 && 
            mouseY <= height - margin - size && 
            mouseY >= height - margin - size - 70));
    }

    public void drag() {
        float minX = map(1900, 1900, 2007, margin + 40, width - margin - 40);
        float maxX = map(2007, 1900, 2007, margin + 40, width - margin - 40);
        year = map(mouseX, margin, width - margin, 1898, 2010);
        year = round(constrain(year, 1900, 2007));
    }

    public void draw() {
        pushMatrix();
        hint(DISABLE_DEPTH_TEST);

        rectMode(CORNERS);
        fill(63, 133, 239);
        noStroke();
        rect(margin, height - margin - size, width - margin, height - (2 * margin));
        fill(58, 115, 219);
        noStroke();
        rect(margin, height - margin - size, width - margin, height - margin - size + 30);
        stroke(149, 200, 253);
        textSize(20);
        textAlign(CENTER);
        for(Integer i = 1900; i <= 2007; i++) {
            float x = map(i, 1900, 2007, margin + 40, width - margin - 40);
            if (i % 10 == 0) {
                String year = i.toString();
                fill(221,221,221);
                text(year, x, height - margin - size + 23);
                stroke(149, 200, 253);
                line(x, height - margin - size + 30, x, height - margin - size + 55);

            } else if (i % 5 == 0) {
                line(x, height - margin - size + 30, x, height - margin - size + 50);

            } else {
                line(x, height - margin - size + 30, x, height - margin - size + 40);
            }

            if( i == 2007) {
                String year = i.toString();
                fill(221,221,221);
                text(year, x, height - margin - size + 23);
            }
        }

        stroke(185, 185, 185, 150);
        strokeWeight(3);
        
        float highlightX = map(year, 1900, 2007, margin + 40, width - margin - 40);
        float slidderX = highlightX - 60;
        line(highlightX, height - margin - size, highlightX, height - (2 * margin));
        fill(58, 115, 219, isHovering() ? 255 : 100);
        noStroke();
        rect(slidderX, height - margin - size - 70, slidderX + 120, height - margin - size - 20);
        triangle(highlightX, height - margin - size, highlightX - 10, height - margin - size - 20, highlightX + 10, height - margin - size - 20);
        fill(221,221,221, isHovering() ? 255 : 100);
        text(((Integer)Math.round(year)).toString(), highlightX, height - margin - size - 38);


        fill(255);
        stroke(0);
        strokeWeight(1);
        textAlign(LEFT);
        hint(ENABLE_DEPTH_TEST);
        popMatrix();
    }
}

class Globe {
    public Vector3 position, rotation;
    private PShape xAxis, yAxis, zAxis, globe, pinShape;
    private float radius;

    public Globe(float radius, Vector3 position, Vector3 rotation) {
        this.position = position;
        this.rotation = rotation;
        this.radius = radius;
        globe = createShape(SPHERE, radius);
        globe.setTexture(darkEarth);
        globe.setStroke(color(0, 0, 0, 0)); 

        // xAxis = createShape(BOX, 1000, 10, 10);
        // xAxis.setFill(color(255,0,0));
        // yAxis = createShape(BOX, 10, 1000, 10);
        // yAxis.setFill(color(0,255,0));
        // zAxis = createShape(BOX, 10, 10, 1000);
        // zAxis.setFill(color(0,0,255));

        pinShape = createShape(SPHERE, 5);
        pinShape.setFill(color(146,20,12));
        pinShape.setStroke(color(0,0,0,0));
    }

    private void draw(float scale) { 
        pushMatrix();
        translate(position.x, position.y, position.z + scale);
        rotateX(rotation.x);
        rotateY(rotation.y);
        rotateZ(rotation.z);
        shape(globe);
        // shape(xAxis); // RED
        // shape(yAxis); // GREEN
        // shape(zAxis); // BLUE
        popMatrix();
        for(Pin pin : pins) {
            if(pin.year ==  timeline.year) {
                pin.draw3D(position, rotation, pinShape);    
            }
        }
    }

    public void drag(Mouse mouseA, Mouse mouseB, float scale) {
        scale = map(scale, 0, 500, 1, 0.2f); 
        if (mouseA.y > mouseB.y) rotation.x += 0.05f * scale;
        if (mouseA.y < mouseB.y) rotation.x -= 0.05f * scale;
        if (mouseA.x < mouseB.x) rotation.y += 0.05f * scale;
        if (mouseA.x > mouseB.x) rotation.y -= 0.05f * scale;
    }
}

class Pin {
    private Vector3 position;
    public int year;
    public float magnitude, x, y;

    public Pin(int year, int magnitude, float latitude, float longitude, float radius, float mapWidth, float mapHeight, float mapXOffset, float mapYOffset) {
        this.position = LongLatToVector(latitude, longitude, radius);
        this.year = year;
        this.magnitude = magnitude;
        this.x =  ((mapWidth/360.0) * (180 + longitude)) + mapXOffset;
        this.y =  ((mapHeight/180.0) * (90 - latitude)) + mapYOffset;
    }
    
    public void draw3D(Vector3 relativePosition, Vector3 relativeRotation, PShape pinShape) {
        pushMatrix();
        translate(relativePosition.x, relativePosition.y, relativePosition.z + scale);
        rotateX(relativeRotation.x);
        rotateY(relativeRotation.y);
        rotateZ(relativeRotation.z);
        translate(position.x, position.y, position.z);

        if(modelZ(0, 0, 0) > 0) {
            shape(pinShape);
        }
        popMatrix();
    }

    public void draw2D() {
        hint(DISABLE_DEPTH_TEST);
        if(this.magnitude >= 9) {
            fill(MagnitudeColor.High);
        } else if(this.magnitude >= 5) {
            fill(MagnitudeColor.Medium);
        } else {
            fill(MagnitudeColor.Low);
        }
        ellipseMode(RADIUS);
        ellipse(x, y, 10, 10);
        fill(255);
        hint(ENABLE_DEPTH_TEST);
    }

    

    private Vector3 LongLatToVector(float latitude, float longitude, float radius) {
        float lat = radians(-latitude);
        float lon = radians(-longitude - 180);
        float x = radius * cos(lat) * cos(lon);
        float y = radius * cos(lat) * sin(lon);
        float z = radius * sin(lat);
            
        return new Vector3(x, z ,y);
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