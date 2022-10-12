/*
NAME: ISHAAN TAILOR
 STUDENT ID: 218881060
 DATE: OCT 12 2022
 DESC: This one i took the functions I liked from what we have learned. For some reason i really though it was cool how the random points work and then connect with a line
 when they are close together, instead of it being a point i turned them into small ellipse and in combination with the bigger brown ellipse that move in sin and cos functions
 it looks kind of like a kind of tree with the smaller ones being different colour leaves and the waves in the the bigger ones making it look like branches. With the grid i
 tried sometihing new with making the step size change with sin and cos. It makes the background look more like something from the matrix. Other than that I have some squares
 that randomly place on the screen every 100 frames.
 */

RW[] randwalk;
Grid grid;

//store information
int size = 20;
int cols = 4;
int rows = 4;
int stepx, stepy;
PVector pos;
PVector acc;
int speed = 2;

void setup() {
  size(800, 800);
  background(0);

  stepx = (width/cols);
  stepy = (height/rows);

  //assign the size for the array for randwalk
  randwalk = new RW[size];

  //fill every space in randwalk with random position
  for (int i = 0; i < size; i++) {
    randwalk[i] = new RW(random(height), random(width), 10);
  }

  //create the object for the grid
  grid = new Grid(stepx, stepy);

  //define acceleration and position for vectors
  pos = new PVector(width/2, height/2, random(40, 70));
  acc = new PVector(speed, speed, 0);
}

void draw() {

  /*
  for (int i = 0; i < size; i++){
   randwalk[i].randomWalk();
   randwalk[i].prox();
   }
   */

  //loop through each element in randwalk and assign it a function to do
  for (RW i : randwalk) {
    i.randomWalkE();
    //i.randomWalkP();
    i.prox();
    i.avoid();
  }

  //function to create the grid
  grid.createGrid();
  grid.randomSquare();

  //add the acceleration to the position
  pos.add(acc);

  //store the wave values from the frameCount
  float wave = sin(radians(frameCount));
  float wave2 = cos(radians(frameCount));

  //set the colour of the ellipses to brown and have the waves interact with them in a different way
  fill(208, 187, 148);
  stroke(59, 29, 0);
  ellipse(pos.x + wave2*30, pos.y + -wave2*30, pos.z, pos.z);
  ellipse(pos.x + wave*30, pos.y + wave*30, pos.z, pos.z);
  ellipse(pos.x + -wave2*30, pos.y + wave*30, pos.z, pos.z);
  ellipse(pos.x + -wave2*100, pos.y + wave*100, pos.z, pos.z);

  //boundary check
  if ( (pos.x > width) || (pos.x < 0)) {
    //multiply the accelearation.x by -1
    acc.x = acc.x * -1;
  }

  //check to see if pos.y is contained within the screen width
  if ( (pos.y > width) || (pos.y < 0)) {
    //multiply the acceleration.y by -1
    acc.y = acc.y * -1;
  }

  fill(0);
}

//instancing the random walker class
class RW {
  float x;
  float y;

  float rStep;

  color c = color(random(255), random(255), random(255));

  //constructor for the randwalk class
  RW(float x, float y, float rStep) {
    this.x = x;
    this.y = y;
    this.rStep = rStep;
  }

  //create ellipses at random locations 
  void randomWalkE() {
    x = x+random(-rStep, rStep);
    y = y+random(-rStep, rStep);

    stroke(c);

    ellipse(x, y, 5, 5);
  }

  //create points at random locations
  void randomWalkP() {
    x = x+random(-rStep, rStep);
    y = y+random(-rStep, rStep);

    stroke(c);

    point(x, y);
  }

  //when the points are 50 pixels close draw a line to them
  void prox() {
    for (int i = 0; i < size; i++) {
      //find the distance
      float d = dist(this.x, this.y, randwalk[i].x, randwalk[i].y);

      if (d <= 50) {
        stroke(c);
        strokeWeight(random(3));
        line(this.x, this.y, randwalk[i].x, randwalk[i].y);
      }
    }
  }

  //create arc if the points get close
  void avoid() {
    float wave = sin(radians(frameCount));

    for (int i = 0; i < size; i++) {
      float d = dist(this.x, this.y, randwalk[i].x, randwalk[i].y);

      if (d <= 50) {
        fill(c);
        arc(this.x*wave, this.y*wave, 50, 50, PI+QUARTER_PI, PI);
        fill(0);
      }
    }
  }
}

//Class for setting up the grid
class Grid {
  int stepx;
  int stepy;

  //constructor to define the grid
  Grid(int stepx, int stepy) {
    this.stepx = stepx;
    this.stepy = stepy;
  }

  //create the grid based on the step size
  void createGrid() {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        noFill();
        //stroke(c);

        //apply sin function to change the look of the grid
        stepx = int(stepx+(sin(y)*10));
        stepy = int(stepy+(sin(x)*10));

        rect(x * stepx, y*stepy, stepx, stepy);
      }
    }
  }

  //spawn a random square every 100 frames
  void randomSquare() {
    color c = color(random(255), random(255), random(255));

    if (frameCount % 300 == 1) {
      fill(c);
      rect(random(width), random(height), 50, 50);
    }
  }
}
