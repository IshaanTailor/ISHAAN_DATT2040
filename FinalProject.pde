//I FOLLOWED A TUTORIAL FOR THIS PROJECT BUT I TRIED TO CHANGE AND ADD WHAT I CAN

int gameScreen = 0;

// store the forces
float gravity = 0.3;
float airfriction = 0.00001;
float friction = 0.1;

// scoring
int score = 0;

// store values for the health bar
int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;

// values for the ball speed, position, size, etc
float ballX; 
float ballY;
float ballSpeedVert = 0;
float ballSpeedHorizon = 0;
float ballSize = 20;
color ballColor = color(255, 0, 0);

// store colour and size for the platform
color racketColor = color(255, 0, 0);
float racketWidth = 100;
float racketHeight = 10;

// store size and speed for the walls
int wallSpeed = 5;
int wallInterval = 1000;
float lastAddTime = 0;
int minGapHeight = 200;
int maxGapHeight = 300;
int wallWidth = 80;
color wallColors = color(255);

// This arraylist stores data of the gaps between the walls. Actuals walls are drawn accordingly.
ArrayList<int[]> walls = new ArrayList<int[]>();

// Store the background of the game
PImage bg;

//set up the screen size and the ball coordinates
void setup() {
  size(500, 500);
  
  // set the position of the ball
  ballX=width/4;
  ballY=height/5;
  smooth();
  
  // load and sttore the background image
  bg = loadImage("https://i5.walmartimages.com/asr/7d457f21-4f09-4daa-8d23-abef47ff8a4f.26ba9889f3f17dbf607c649452655487.jpeg?odnHeight=2000&odnWidth=2000&odnBg=ffffff");
}

// Draws the contents of the screen. Acts as a controller for what scene is being played and in used. When a scene ends a new one starts
void draw() {
  // Display the contents of the current screen
  if (gameScreen == 0) { 
    initScreen();
  } else if (gameScreen == 1) { 
    gameScreen();
  } else if (gameScreen == 2) { 
    gameOverScreen();
  }
}

// Setting the menu and start screen up
void initScreen() {
  background(236, 240, 241);
  textAlign(CENTER);
  fill(52, 73, 94);
  textSize(70);
  text("Flappy Pong", width/2, height/2);
  textSize(15); 
  text("Click to start", width/2, height-30);
}

// Draw the game screen and all the physics
void gameScreen() {
  
  // Draw the background image
  background(bg);
  
  // Draw the platform 
  drawRacket();
  
  // Interaction with ball and platform
  watchRacketBounce();
  
  // Draw the ball
  drawBall();
  
  // Apply the gravity
  applyGravity();
  
  // Apply horixontal speed to the ball
  applyHorizontalSpeed();
  
  // Check the boundaries on the ball to keep it in the screen
  keepInScreen();
  
  // Draw the health bar to the screen
  drawHealthBar();
  
  // Print the score on the screen
  printScore();
  
  // Add walls at certain intervals
  wallAdder();
  
  // Manages how many walls are up at the same time
  wallHandler();
}

// Game Over Screen. Changes to game over when player is out of health
void gameOverScreen() {
  background(44, 62, 80);
  textAlign(CENTER);
  fill(236, 240, 241);
  textSize(12);
  text("Your Score", width/2, height/2 - 120);
  textSize(130);
  text(score, width/2, height/2);
  textSize(15);
  text("Click to Restart", width/2, height-30);
}

// Takes the mouse press and starts the game or resets it
public void mousePressed() {
  // if we are on the initial screen when clicked, start the game 
  if (gameScreen==0) { 
    startGame();
  }
  if (gameScreen==2) {
    restart();
  }
}


// This method sets the necessery variables to start the game  
void startGame() {
  gameScreen=1;
}
void gameOver() {
  gameScreen=2;
}

// Restart the game game with to the intial position and score
void restart() {
  score = 0;
  health = maxHealth;
  ballX=width/4;
  ballY=height/5;
  lastAddTime = 0;
  
  // Clear all the walls
  walls.clear();
  
  // Set the game screen to the gameplay
  gameScreen = 1;
}

// Method to draw the ball on the screen
void drawBall() {
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}

// Draw the platform on the screen
void drawRacket() {
  fill(racketColor);
  rectMode(CENTER);
  
  // Move the platform where the mouse moves
  rect(mouseX, mouseY, racketWidth, racketHeight, 5);
}


// Add the walls at certain time with enough space for gap and space inbetween
void wallAdder() {
  if (millis()-lastAddTime > wallInterval) {
    
    // Create the walls from a minumum height to max height
    int randHeight = round(random(minGapHeight, maxGapHeight));
    int randY = round(random(0, height-randHeight));
    // {gapWallX, gapWallY, gapWallWidth, gapWallHeight, scored}
    
    // Store wall at random height and gap size
    int[] randWall = {width, randY, wallWidth, randHeight, 0}; 
    
    //Add the wall just spawned into the ArrayList
    walls.add(randWall);
    lastAddTime = millis();
  }
}

// Hub for all the walls in the ArrayList check if they are doing what they're supposed to do
void wallHandler() {
  for (int i = 0; i < walls.size(); i++) {
    wallRemover(i);
    wallMover(i);
    wallDrawer(i);
    watchWallCollision(i);
  }
}

// Draw the wall at a certain gap and height from the array
void wallDrawer(int index) {
  int[] wall = walls.get(index);
  
  // get gap wall settings 
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  
  // Draw the actual walls on the screen
  rectMode(CORNER);
  noStroke();
  strokeCap(ROUND);
  fill(wallColors);
  rect(gapWallX, 0, gapWallWidth, gapWallY, 0, 0, 15, 15);
  rect(gapWallX, gapWallY+gapWallHeight, gapWallWidth, height-(gapWallY+gapWallHeight), 15, 15, 0, 0);
}

// Move the walls across the screen at a certain pace
void wallMover(int index) {
  int[] wall = walls.get(index);
  wall[0] -= wallSpeed;
}

// Remove the wall once it has gone past the screen
void wallRemover(int index) {
  int[] wall = walls.get(index);
  if (wall[0]+wall[2] <= 0) {
    walls.remove(index);
  }
}

// Check collisions with ball and wall
void watchWallCollision(int index) {
  int[] wall = walls.get(index);
  // get gap wall settings 
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  int wallScored = wall[4];
  int wallTopX = gapWallX;
  int wallTopY = 0;
  int wallTopWidth = gapWallWidth;
  int wallTopHeight = gapWallY;
  int wallBottomX = gapWallX;
  int wallBottomY = gapWallY+gapWallHeight;
  int wallBottomWidth = gapWallWidth;
  int wallBottomHeight = height-(gapWallY+gapWallHeight);

  // Check to see if ball is in the top wall and if it is remove the health
  if (
    (ballX+(ballSize/2)>wallTopX) &&
    (ballX-(ballSize/2)<wallTopX+wallTopWidth) &&
    (ballY+(ballSize/2)>wallTopY) &&
    (ballY-(ballSize/2)<wallTopY+wallTopHeight)
    ) {
    decreaseHealth();
  }
  
  // Check to see if ball is in the bottom wall and if it is remove the health
  if (
    (ballX+(ballSize/2)>wallBottomX) &&
    (ballX-(ballSize/2)<wallBottomX+wallBottomWidth) &&
    (ballY+(ballSize/2)>wallBottomY) &&
    (ballY-(ballSize/2)<wallBottomY+wallBottomHeight)
    ) {
    decreaseHealth();
  }

  // If the ball goes through the gap add to the score
  if (ballX > gapWallX+(gapWallWidth/2) && wallScored==0) {
    wallScored=1;
    wall[4]=1;
    score();
  }
}

// Drawing the health bar to the screen
void drawHealthBar() {
  noStroke();
  fill(189, 195, 199);
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth*(health/maxHealth), 5);
}

// Decrease the health and if health reaches 0 then go to gameover screen
void decreaseHealth() {
  health -= healthDecrease;
  if (health <= 0) {
    gameOver();
  }
}

// Add to the score
void score() {
  score++;
}

// Print the score on the center of the screen
void printScore() {
  textAlign(CENTER);
  fill(255);
  textSize(30); 
  text(score, height/2, 50);
}

// Check to see if the ball makes connection with the top of the racket
void watchRacketBounce() {
  float overhead = mouseY - pmouseY;
  if ((ballX+(ballSize/2) > mouseX-(racketWidth/2)) && (ballX-(ballSize/2) < mouseX+(racketWidth/2))) {
    if (dist(ballX, ballY, ballX, mouseY)<=(ballSize/2)+abs(overhead)) {
      makeBounceBottom(mouseY);
      ballSpeedHorizon = (ballX - mouseX)/10;
      // racket moving up
      if (overhead<0) {
        ballY+=(overhead/2);
        ballSpeedVert+=(overhead/2);
      }
    }
  }
}

// Apply gravity to the ball my changing the speed and the friction of the air
void applyGravity() {
  ballSpeedVert += gravity;
  ballY += ballSpeedVert;
  ballSpeedVert -= (ballSpeedVert * airfriction);
}

// Change the speed of the ball when moving horizontally across the screen
void applyHorizontalSpeed() {
  ballX += ballSpeedHorizon;
  ballSpeedHorizon -= (ballSpeedHorizon * airfriction);
}

// Change the speed and direction of the ball
// ball falls and hits the floor (or other surface) 
void makeBounceBottom(float surface) {
  ballY = surface-(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}

// Change the speed and direction of the ball
// ball rises and hits the ceiling (or other surface)
void makeBounceTop(float surface) {
  ballY = surface+(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}

// Change the speed and direction of the ball
// ball hits object from left side
void makeBounceLeft(float surface) {
  ballX = surface+(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}

// Change the speed and direction of the ball
// ball hits object from right side
void makeBounceRight(float surface) {
  ballX = surface-(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}

// Hub to check if the ball is inbounds and if not apply the changes
// Boundary Check
void keepInScreen() {
  // ball hits floor
  if (ballY+(ballSize/2) > height) { 
    makeBounceBottom(height);
  }
  // ball hits ceiling
  if (ballY-(ballSize/2) < 0) {
    makeBounceTop(0);
  }
  // ball hits left of the screen
  if (ballX-(ballSize/2) < 0) {
    makeBounceLeft(0);
  }
  // ball hits right of the screen
  if (ballX+(ballSize/2) > width) {
    makeBounceRight(width);
  }
}
