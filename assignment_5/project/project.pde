// uwnd stores the 'u' component of the wind.
// The 'u' component is the east-west component of the wind.
// Positive values indicate eastward wind, and negative
// values indicate westward wind.  This is measured
// in meters per second.
Table uwnd;

// vwnd stores the 'v' component of the wind, which measures the
// north-south component of the wind.  Positive values indicate
// northward wind, and negative values indicate southward wind.
Table vwnd;

// An image to use for the background.  The image I provide is a
// modified version of this wikipedia image:
//https://commons.wikimedia.org/wiki/File:Equirectangular_projection_SW.jpg
// If you want to use your own image, you should take an equirectangular
// map and pick out the subset that corresponds to the range from
// 135W to 65W, and from 55N to 25N
PImage img;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  // If this doesn't work on your computer, you can remove the 'P3D'
  // parameter.  On many computers, having P3D should make it run faster
  size(700, 400, P3D);
  img = loadImage("background.png");
  uwnd = loadTable("uwnd.csv");
  vwnd = loadTable("vwnd.csv");
  
  setupParticles(uwnd, vwnd);
}

void draw() {
  background(255);
  image(img, 0, 0, width, height);
  for(Particle p : particles) {
    p.run();
  }
  drawMouseLine();
}

void setupParticles(Table xVelocities, Table yVelocities) {
  for(int y = 0; y < xVelocities.getRowCount(); y++ ) {
    if(y % 4 == 0) {
      for(int x = 0; x < xVelocities.getColumnCount(); x++ ) {
        if(x % 4 == 0) {

          float xVel = readRaw(xVelocities, x, y);
          float yVel = readRaw(yVelocities, x, y);
          float xPos = map(x, 0, xVelocities.getColumnCount(), 0, width);
          float yPos = map(y, 0, xVelocities.getRowCount(), 0, height);
    
          particles.add(new Particle(new PVector(xPos, yPos), new PVector(xVel, yVel)));
        }
      }
    }
  }
}

void drawMouseLine() {
  // Convert from pixel coordinates into coordinates
  // corresponding to the data.
  float a = mouseX * uwnd.getColumnCount() / width;
  float b = mouseY * uwnd.getRowCount() / height;
  
  // Since a positive 'v' value indicates north, we need to
  // negate it so that it works in the same coordinates as Processing
  // does.
  float dx = readInterp(uwnd, a, b) * 10;
  float dy = -readInterp(vwnd, a, b) * 10;
  line(mouseX, mouseY, mouseX + dx, mouseY + dy);
}

// Reads a bilinearly-interpolated value at the given a and b
// coordinates.  Both a and b should be in data coordinates.
float readInterp(Table tab, float a, float b) {
  int x = int(a);
  int y = int(b);
  // TODO: do bilinear interpolation
  return readRaw(tab, x, y);
}

// Reads a raw value 
float readRaw(Table tab, int x, int y) {
  if (x < 0) {
    // x = 0;
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
  return tab.getFloat(y,x);
} 

class Particle {
  private PVector initialPosition;
  private PVector initialVelocity;
  private float initialLifespan;

  private PVector position;
  private PVector velocity;
  private float lifespan;

  // private float speed;


  private PVector acceleration;

  public Particle(PVector position, PVector velocity) {
    this.acceleration = new PVector(0.05, 0.05);
    this.initialVelocity = velocity.copy();
    this.initialPosition = position.copy();
    this.initialLifespan = 5;
    rebirth();
  }

  public void run() {
    if(!isDead()) {
      if(frameCount % 1 == 0) {
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
    velocity = initialVelocity.copy();
    lifespan = initialLifespan;
  }

  // Method to update position
  private void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  private void display() {
    noStroke(); 
    fill(255, 0, 0);
    ellipse(position.x, position.y, 3, 3);
    stroke(0);
  }


  // Is the particle still useful?
  public boolean isDead() {
    return lifespan < 0.0;
    // return false;
  }
}