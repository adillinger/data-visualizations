// Maxwell Chehab
// Data Visualization 
// Assignment #2

Table table;
Bar[] bars = {};
float minTemp, maxTemp;

void setup() {
  size(800, 800);
  
  createBars();
}


/* 
  Create bars retrieves the `Mean TemperatureF` data from the attached `hw2.csv`
  and populats the `Bar[] bars` array of bars.
*/
void createBars(){
  //Load table;
  Table wins = loadTable("wins.csv");
  Table losses = loadTable("losses.csv");
  
  //Generate bar width
  int barWidth = width / table.getRowCount();
  int[] temps = {};
  
  //Assign max and min temp to the first entry.
  int firstTemp = table.getRow(0).getInt("Mean TemperatureF");
  maxTemp = firstTemp;
  minTemp = firstTemp;
  
  /*
    Calculate the min and max temperature (this is neccessary to have an
    accurate chart with correct relative heights.
  */
  for (TableRow row : table.rows()) {
    int temp = row.getInt("Mean TemperatureF");
    temps = append(temps, temp);
    
    if(temp > maxTemp) maxTemp = temp;
    if(temp < minTemp) minTemp = temp;
  }
  
  //Populate the bar array.
  for(int i = 0; i < temps.length; i++){
    float h = getHeight(temps[i]);
    bars = (Bar[]) append(bars, new Bar(i * barWidth, int(height - h), barWidth, h, temps[i]));
  }
}

//Helper function to draw the default text;
void drawDefaultText(){
  fill(#000000);
  textSize(20);
  text("Hover over the chart to identify accurate tempuratures.", 10, 25);
  noFill();
  rect(0,0,560, 33);
}

//Helper function to draw the temperature text.
void drawTempText(int temp){
  fill(#000000);
  textSize(20);
  text("Average tempurature: " + temp + "°F", 10, 25);
  noFill();
  rect(0,0,280, 33);
}

//Helper function to draw the 32F line and bottom line for prettiness :)
void drawLines(){
  line(0, height - getHeight(32), width, height - getHeight(32));
  line(0, height-1, width, height-1);
  fill(#000000);
  textSize(15);
  text("32°F", 10,  height - getHeight(32) - 10);
}


void draw(){
  
  //`Reset` the image.
  background(#FFFFFF);
  
  /*
    Don't want to show the default text if user is hovering so `hovering`
    keeps track of that.
  */
  boolean hovering = false;
  for(Bar bar : bars){
    bar.draw(); //Draw all the bars
    if(bar.hovering()){ //Check if user is hovering over the current bar
      drawTempText(bar.temp); //Display temperature
      hovering = true;
    }
  }
  
  //Only show the defaultText if temperature is not displayed.
  if(!hovering) drawDefaultText();
  
  //Draw the lines.
  drawLines();
}

//getHeight calculates the height of each bar.
float getHeight(int temp){  
  return map(temp, minTemp, maxTemp, 30, height-40);
}

/* 
  Instead of drawing the bar as a rectangle, the program draws a line of varing color
  for each pixel that the bar exists. The color of the line depends on the `y` position
  of the bar. This creates that gradient effect.
*/
void drawBar(int x, int y, float w, float h, color c1, color c2) {
  noFill();
  
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
  
  stroke(#000000);
  rect(x, y, w, h); //Surround the gradient in a nice black rectangle.
}

//Bar class
class Bar {
  int x, y, temp;
  float w, h;
  
  //Simple constructor :)
  Bar(int x, int y, float w, float h, int temp){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.temp = temp;
  }
  
  
  //Some messy collision dectection.
  boolean hovering(){
    return (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
  }
  
  //A draw method.
  void draw(){
    drawBar(x, y, w, h, color(255,0,0), color(0,0,255));
  }
}