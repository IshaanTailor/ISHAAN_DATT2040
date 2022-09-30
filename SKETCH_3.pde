/*
NAME: ISHAAN TAILOR
STUDENT#: 218881060
DATE: 09/30/22
DESC: For this sketch I wasn't sure how to approach it and wasn't really sure how I could use the sin and cos functions to create a design that looks good.
      But for this I kindof tried to make an orbit one that goes around the center circle and then changes rotation and colour after about 500 frames. It looks okay,
      but i think i can do much better. I just wasn't sure how I could
*/

//hold values needed for later
int num = 8;

//hold the array for the shapes
PVector[] shapes;
//String[] colourRange = {"#0000FF", "#4c00b0", "#964B00", "#ADD8E6" };


void setup() {
  size(800, 800);
  
  //set up shapes into array
  shapes = new PVector[num];
   for (int i = 0; i < num; i++) {
    shapes[i] = new PVector(random(width) ,random(height), random(20,90));
    }
   
  //setup the colour and background
  stroke(255);
  noFill();
  background(0);
}

void draw() {
  
  //calc the waves based on the frame count using sin and cos
  float wave = sin(radians(frameCount));
  float wave2 = cos(radians(frameCount));
  wave *= 200;
  wave2 *= 200;
  
  //create the center circle
  fill(255,140,0);
  ellipse(width/2, height/2, 100 + wave, 100 + wave);
  
  //create the 2 orbits that will be in opposite rotations and colours
  stroke(255);
  for (int i = 0; i < num/2; i++){
    fill(135,206,235);
    ellipse(shapes[i].x+wave2, shapes[i].y + wave, shapes[i].z, shapes[i].z);
  }
  for (int i = 4; i < num; i++){
    fill(255,0,0);
    ellipse(shapes[i].x+wave, shapes[i].y + wave2, shapes[i].z, shapes[i].z);
  }
  
  //after 500 frames change the rotation and the colours of the orbits (change into more linear movements)
  if (frameCount > 500){
     for (int i = 0; i < num/2; i++){
      fill(255, 255, 0);
      ellipse(shapes[i].x+wave2, shapes[i].y + wave2, shapes[i].z, shapes[i].z);
    }

    for (int i = 4; i < num; i++){
      fill(0,255,0);
      ellipse(shapes[i].x+wave, shapes[i].y + wave, shapes[i].z, shapes[i].z);
    }
  }
  
}
