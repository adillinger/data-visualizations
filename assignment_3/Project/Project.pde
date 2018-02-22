// Maxwell Chehab
// Data Visualization 
// Assignment #3

Team[] teams;
int selectedIndex = 0;
Canvas canvas = new Canvas(50);

void setup() {
    size(900, 800);
    createTeamsFromTables(); 
     
}

// Draw clears the canvas, updates all the teams, selects the selected team,
// borders the screen, and draws neccessary labels.
void draw() {
    canvas.clear();
    for (Team team: teams) {
        team.update();
    }
    teams[selectedIndex].select();
    canvas.border();
    canvas.label();
}

// Just some fancy-pants modular arthimetic to avoid ArrayIndexOutOfBoundsException's
void keyPressed() {
    if (keyCode == UP) {
        selectedIndex = (selectedIndex + 1) % (teams.length - 1);
    } else if (keyCode == DOWN) {
        selectedIndex = (selectedIndex - 1) % (teams.length - 1);
    }
    if (selectedIndex < 0) selectedIndex += (teams.length - 1);
}

// I would prefer this to be a static method attached to class Team but 
// processing doesn't like static methods :(
void createTeamsFromTables() {
    Table wins = loadTable("wins.csv");
    Table losses = loadTable("losses.csv");
    int tableLength = wins.getRowCount();
    teams = new Team[tableLength];
    for (int i = 0; i < tableLength; i++) {
        teams[i] = new Team(wins.getRow(i), losses.getRow(i));
    }
}

// Decided to take the OOP route thus a class representing the team data.
class Team {
    private String name;
    private float[] ratios;

    // Constructor populates and calculates the ratios for each team.
    Team(TableRow wins, TableRow losses) {
        int columns = wins.getColumnCount();

        this.ratios = new float[columns];
        this.name = wins.getString(0);
        for (int i = 1; i < columns; i++) {
            float win = wins.getFloat(i);
            float loss = losses.getInt(i);
            float sum = win + loss;

            this.ratios[i] = (sum > 0) ?  (win / sum) : 0;
        }
    }

    // Normal update does not display current team value or highlight line.
    public void update() {
        this.draw(false);
    }
    
    // A select update will highlight the line and display the team name.
    // Ideally, Team would be a static class with a static property tracking
    // the current selected team but processing does not like static methods.
    public void select() {
      this.draw(true);
      this.label();
    }

    // Displays the team name.
    public void label() {
      fill(255, 0, 0);
      textAlign(RIGHT);
      textSize(28);
      text("Team: " + this.name, canvas.width() - 20, canvas.height() - 20);
    }

    // The draw function checks if the team is selected, if so, the line
    // will highlight.
    private void draw(boolean select) {
        if(select){
            stroke(0);
            strokeWeight(10);
            drawLines();
            stroke(255, 0, 0);
            strokeWeight(5);
        }
        
        drawLines();
        stroke(0);
        strokeWeight(1);
    }
    
    // Drawlines uses the map function to convert the win percentage to
    // relevant coordinates and draws a line.
    private void drawLines(){
       for (int i = 0; i < this.ratios.length - 1; i++) {
            float currentRatio = this.ratios[i];
            float nextRatio = this.ratios[i + 1];
            float startX = map(i, 0, this.ratios.length - 1, canvas.margin, canvas.width()); // i'th index
            float startY = map(currentRatio, 0, 1, canvas.margin, canvas.height()); // percentage map of height
            float endX = map(i + 1, 0, this.ratios.length - 1, canvas.margin, canvas.width());; //i'th plus one
            float endY = map(nextRatio, 0, 1, canvas.margin, canvas.height());; //nextPercentage map of height
            line(startX, startY, endX, endY);
        }
    }

    // A helper function print that displays Team object
    public void print() {
        System.out.print(this.name + ": [");
        for (float p: this.ratios) {
            System.out.print(" " + p);
        }
        System.out.println(" ]");
    }
}

// Canvas is a class that keeps track calculating the width and height while
// accounting for margin.
class Canvas {
    public int margin;

    Canvas(int margin) {
        this.margin = margin;
    }

    // Calculates the width
    public int width() {
        return width - margin;
    }

    // Calculates the height
    public int height() {
        return height - margin;
    }

    // Clears screen.
    public void clear() {
        background(255); 
    }
    
    // Draws graph labels 
    public void label() {
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(28);
        text("U.S. Baseball Teams Winning Percentage", width / 2, canvas.margin + 27);
        
        textSize(16);
        text("Time", width / 2, canvas.height() + 10);
        
        int x = canvas.margin - 15; 
        int y = height / 2;
        pushMatrix();
        translate(x,y);
        rotate(3 * HALF_PI);
        translate(-x,-y);
        textSize(16);
        text("Winning Percentage", x,y);
        popMatrix();

    }
    
    // Draws a white border around graph. This is neccessary to stop overlaping with the
    // highlighted line.
    public void border() {
        noFill();
        strokeWeight(5);
        rect(this.margin, this.margin, this.width() - this.margin, this.height() - this.margin);
        strokeWeight(1);
        fill(255);
        stroke(255);
        rect(0, 0, width, this.margin - 2.5);
        rect(0, 0, this.margin-2.5, height);
        rect(canvas.width() + 2.6, 0, this.margin - 2.6, height);
        rect(0, canvas.height() + 2.6, width, canvas.margin);
    }
}