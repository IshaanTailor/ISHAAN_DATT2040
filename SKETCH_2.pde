/*
NAME: Ishaan Tailor
DATE: SEPT 23 2022
DUE DATE: SEPT 23 2022
DESC: FOr this sketch I was just experimenting and combinging different things we learned in class and trying to make something that looks good.
      I use arrays that apply size and acceleration and then those two arrays will the create circles and squares on the screen that move around and bounce off walls.
      Everytime they bounce off the wall all of them change to the same random colour. Each shape also leaves a trail that stays forever. So after a while the scene looks
      much different from when it started. The shapes also react to the mouse and will rotate the acceleration by 90 degrees and also when they get close to eachother
      they will rotate the acceleration again by 90 degrees. This makes for some random and intresting designs on the screen. Also clicking the mouse will rotate all the shapes by
      45 degrees. There is also going to be a random number of shapes everytime making each run different.
*/

//create PVector Arrays
PVector[] sp;
PVector[] acc;

//how many  shapes there will be
int num = int(random(5,20));
int speed = 1;

void setup() {
  size(600, 600);
  
  //create new vectors based on number of shapes
  sp = new PVector[num];
  acc = new PVector[num];
 
 //Populate the arrays
  for (int i = 0; i < num; i++) {
    sp[i] = new PVector(random(width), random(height), random(5, 70));
    acc[i] = new PVector(random(-speed, speed), random(-speed, speed), 0);
  }
  
  //set background and stroke. also make sure there is no fill in the shape
  stroke(255);
  noFill();
  background(0);
}

void draw() {
  //background(255);
  fill(0,20);
  
  //Store mouse movements
  PVector mouse = new PVector(mouseX, mouseY);
  
  //cycle through the amount of shapes there are
  for (int j = 0; j < num; j++) {
    
    //add acceleration to all the shapes
    sp[j].add(acc[j]);

    //boundary check - and also apply different colour
    if ((sp[j].x > width) || (sp[j].x < 0)) {
      acc[j].x = acc[j].x * -1;
      stroke(random(255), random(255), random(255));
    }
    if ((sp[j].y > height) || (sp[j].y < 0)) {
      acc[j].y = acc[j].y * -1;
      stroke(random(255), random(255), random(255));
    }
    
    //make 50% of shapes squares and 50% circles
    if (j % 2 == 0)
    {
      square(sp[j].x, sp[j].y, sp[j].z);
    }
    else
    {
      ellipse(sp[j].x, sp[j].y, sp[j].z, sp[j].z);
    }
    
    //store distance from mouse to shape in variable
    float q = PVector.dist(sp[j],mouse);
    
    //if the distance is less than 200 pixels rotate it 180 degrees
    if (q <= 200){
      //acc[j].y = acc[j].y * -1;
      //acc[j].x = acc[j].x * -1;
      acc[j].rotate(PI);
    }
    
    //cycle through the number of shapes there are
    for (int i = 0; i < num; i++){
     
      //check the distance of every shape to eachother
      float d = PVector.dist(sp[i],sp[j]);
      
      //if the circles overlap then get the angle and rotate the acceleration by 90 degrees
      if (d <= (sp[i].z+sp[j].z /2)){
        float a = PVector.angleBetween(sp[i],sp[j]);
        acc[i].rotate(a*HALF_PI);
      }
    }
  }
}

//check to see if mouse was clicked
void mouseClicked(){
  //rotate every shape by 45 degrees
  for (int j = 0; j < num; j++) {
    acc[j].rotate(QUARTER_PI);
  }
}
