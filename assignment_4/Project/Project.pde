// Max Chehab
// 313 Data Vis
// 01/03/18

Globe globe;
PImage lightEarth, darkEarth;
Timeline timeline = new Timeline();
Mouse mouse = new Mouse();
float scale = 0;
Vector3 offset = new Vector3(0, 0, 0.0);
Toggler toggler;
ColorToggler colorToggler;
Map map;
Pin[] pins = new Pin[]{};
Scale magnitudeScale = new Scale();
Magnitude MagnitudeColor = new Magnitude();

// 
void setup() {
    cursor(HAND);
    textSize(20);
    // size(1200, 1000, P3D); // Should scale within reason, toggle this if you don't want fullscreen
    fullScreen(P3D);
    background(0);
    lightEarth = loadImage("earth-light.jpg");
    darkEarth = loadImage("earth-dark.png");
    toggler = new Toggler();
    colorToggler = new ColorToggler();
    globe = new Globe(300, new Vector3(width / 2, height / 2, 0), new Vector3(0, 0, 0));
    map = new Map();
    createPinArray(300);
}

void draw() {
    background(0);

    // Toggle 3d to 2d model
    if(toggler.status) {
        directionalLight(255, 255, 255, 0.4f, 0.2f, -2f);
        globe.draw(scale);
    } else {
        map.draw();
    }

    // Draw ui components
    timeline.draw();
    toggler.draw();
    colorToggler.draw();
    magnitudeScale.draw();
}

// Timeline and globe dragging
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

// Check for toggler collision
void mouseClicked() {
    if (toggler.isHovering()) {
        toggler.status = !toggler.status;
    }

    if (colorToggler.isHovering()){
        colorToggler.status = !colorToggler.status;
        globe.toggleTexture();
    }
}

// Check scrolling
void mouseWheel(MouseEvent event) {
    if(toggler.status) {
        scale += event.getCount() > 0 ? 10 : -10;
        scale = constrain(scale, 0, 500);
    }
}

// Globe and timeline dragging
void mouseDragged() {
    Mouse currentMouse = new Mouse(mouseX, mouseY);

    if(!timeline.isHovering() && !toggler.isHovering() && toggler.status) {
        globe.drag(mouse, currentMouse, scale);
        mouse = currentMouse;
    } else if (timeline.isHovering()) {
        timeline.drag();
    }
}

// Reads data from provided data.csv
void createPinArray(float radius) {
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

// Check for arrow key presses
void keyPressed(KeyEvent event) {
    if(event.getKeyCode() == 37) timeline.decrease();
    if(event.getKeyCode() == 39) timeline.increase();
}

// Parent class for all interactive ui objects
class UiElement {
    public boolean isHovering () {
        return false;
    }
}

// 2d map
class Map {
    private final int margin = 20;

    // draw the map
    public void draw() {
        pushMatrix();
        hint(DISABLE_DEPTH_TEST);

        int h = height - toggler.w - (3 * margin);
        int w = (h * lightEarth.width) / lightEarth.height;
        if(colorToggler.status) {
            image(lightEarth, margin, margin, w, h);
        } else {
            image(darkEarth, margin, margin, w, h);
        }
        fill(255);
        hint(ENABLE_DEPTH_TEST);
        popMatrix();

        // overlay all the pins
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

// Toggles color mode
class ColorToggler extends UiElement {
    public final int w = 200, h = 120;
    public final int margin = 20;
    public boolean status = false;

    public boolean isHovering() {
        return (mouseX >= width - margin - w && 
            mouseX <=  width - margin && 
            mouseY >=  toggler.h + magnitudeScale.h + (3 * margin) && 
            mouseY <=  toggler.h + magnitudeScale.h + (3 * margin) + h);
    }

    public void draw() {
        pushMatrix();
        hint(DISABLE_DEPTH_TEST);

        rectMode(CORNERS);
        noStroke();
        fill(63, 133, 239, isHovering() ? 255 : 100);
        rect(width - margin - w, toggler.h + magnitudeScale.h + (3 * margin), width - margin, toggler.h + magnitudeScale.h + (3 * margin) + h );
        fill(58, 115, 219, isHovering() ? 255 : 100);
        rect(width - margin - w, toggler.h + magnitudeScale.h + (3 * margin), width - margin, toggler.h + magnitudeScale.h + (3 * margin) + 30);
        fill(221,221,221, isHovering() ? 255 : 100);

        textAlign(CENTER);
        text("Color Mode", width - margin - (w / 2),  toggler.h + magnitudeScale.h + (3 * margin) + 22);
        stroke(0);
        rect(width - margin - w + 20, toggler.h + magnitudeScale.h + (3 * margin) + 50, 
            width - margin - 20, toggler.h + magnitudeScale.h + (3 * margin) + 80);
        noStroke();
        if(status) {
            fill(83, 122, 250, isHovering() ? 255 : 100);
        } else {
            fill(255, 255, 255, isHovering() ? 255 : 100);
        }
        triangle(width - margin - w + 20, toggler.h + magnitudeScale.h + (3 * margin) + 50, 
                width - margin - 20, toggler.h + magnitudeScale.h + (3 * margin) + 50, 
                width - margin - w + 20, toggler.h + magnitudeScale.h + (3 * margin) + 80);
        if(status) {
            fill(50, 205, 50, isHovering() ? 255 : 100);
        } else {
            fill(0, 0, 0, isHovering() ? 255 : 100);
        }        
        triangle(width - margin - w + 20, toggler.h + magnitudeScale.h + (3 * margin) + 80, 
                width - margin - 20, toggler.h + magnitudeScale.h + (3 * margin) + 50, 
                width - margin - 20, toggler.h + magnitudeScale.h + (3 * margin) + 80);
        
        
        fill(255, 255, 255, isHovering() ? 255 : 100);
        text("Click to Toggle", width - margin - (w / 2),  (3 * margin) + h + toggler.h + magnitudeScale.h - 12);

        tint(255,255);
        fill(255);
        stroke(0);
        strokeWeight(1);
        textAlign(LEFT);
        hint(ENABLE_DEPTH_TEST);
        popMatrix();
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
    public boolean status = true;
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

    public void increase() {
        year ++;
        year = constrain(year, 1900, 2007);
    }

    public void decrease() {
        year --;
        year = constrain(year, 1900, 2007);
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

// 3d globe class
class Globe {
    public Vector3 position, rotation;
    private PShape globe, highPinShape, mediumPinShape, lowPinShape;
    private float radius;

    public Globe(float radius, Vector3 position, Vector3 rotation) {
        this.position = position;
        this.rotation = rotation;
        this.radius = radius;
        globe = createShape(SPHERE, radius);
        globe.setTexture(colorToggler.status ? lightEarth : darkEarth);
        globe.setStroke(color(0, 0, 0, 0)); 

        highPinShape = createShape(SPHERE, 15);
        highPinShape.setFill(MagnitudeColor.High);
        highPinShape.setStroke(color(0,0,0,0));

        mediumPinShape = createShape(SPHERE, 10);
        mediumPinShape.setFill(MagnitudeColor.Medium);
        mediumPinShape.setStroke(color(0,0,0,0));

        lowPinShape = createShape(SPHERE, 5);
        lowPinShape.setFill(MagnitudeColor.Low);
        lowPinShape.setStroke(color(0,0,0,0));
    }

    // Method to change texture
    public void toggleTexture() {
        globe = createShape(SPHERE, radius);
        globe.setTexture(colorToggler.status ? lightEarth : darkEarth);
        globe.setStroke(color(0, 0, 0, 0));     
    }

    // rotate globe to specified position and rotation and draw
    private void draw(float scale) { 
        pushMatrix();
        translate(position.x, position.y, position.z + scale);
        rotateX(rotation.x);
        rotateY(rotation.y);
        rotateZ(rotation.z);
        shape(globe);
        popMatrix();
        for(Pin pin : pins) {
            if(pin.year ==  timeline.year) {
                pin.draw3D(position, rotation, highPinShape, mediumPinShape, lowPinShape);    
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

// Simple pin class to keep track of data point
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
    
    public void draw3D(Vector3 relativePosition, Vector3 relativeRotation, PShape highPinShape, PShape mediumPinShape, PShape lowPinShape) {
        pushMatrix();
        // Translate and rotate relative to the globe
        translate(relativePosition.x, relativePosition.y, relativePosition.z + scale);
        rotateX(relativeRotation.x);
        rotateY(relativeRotation.y);
        rotateZ(relativeRotation.z);
        translate(position.x, position.y, position.z);

        //If the pin is within the camera's viewport draw the sphere
        if(modelZ(0, 0, 0) > 0) {
            if(this.magnitude >= 9f) {
                shape(highPinShape);
            } else if(this.magnitude >= 5f) {
                shape(mediumPinShape);
            } else {
                shape(lowPinShape);
            }
        }
        popMatrix();
    }

    // Draw pins as ellipses
    public void draw2D() {
        hint(DISABLE_DEPTH_TEST);
        ellipseMode(RADIUS);
        if(this.magnitude >= 9f) {
            fill(MagnitudeColor.High); 
            ellipse(x, y, 20, 20);
        } else if(this.magnitude >= 5f) {
            fill(MagnitudeColor.Medium);
            ellipse(x, y, 15, 15);

        } else {
            fill(MagnitudeColor.Low);
            ellipse(x, y, 10, 10);
        }
        fill(255);
        hint(ENABLE_DEPTH_TEST);
    }

    // Math to convert longitude and latitude to 3d coordinates 
    // https://stackoverflow.com/a/10475267/9302674
    private Vector3 LongLatToVector(float latitude, float longitude, float radius) {
        float lat = radians(-latitude);
        float lon = radians(-longitude - 180);
        float x = radius * cos(lat) * cos(lon);
        float y = radius * cos(lat) * sin(lon);
        float z = radius * sin(lat);
            
        return new Vector3(x, z ,y);
    }
}
// Simple 3 point vector class
class Vector3 { 
    public float x, y, z;

    public Vector3(float x, float y, float z) {
        this.x = x;
        this.y = y; 
        this.z = z;
    }
}
// Simple 2d mouse class
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

public class Magnitude {
    public final color High = color(182,65,26);
    public final color Medium = color(138,43,226);
    public final color Low = color(238,195,216);
}
