//how to add rotation to the circle
//how to make the color not change everytime
import peasy.*;

PeasyCam cam;

int x = 0;

void setup() {
  cam = new PeasyCam(this,1000);
  
  size(1000, 1000, P3D);
  background(0);
  noFill();
}
void draw() {
  //background(0);//remove if i want to make a circular pattern

  
  //rotateX(radians(frameCount*0.5));
  //rotateY(radians(frameCount*0.5));
  rotateZ(radians(frameCount*25));
  
  translate(x,x,0);
  drawCircle(height/2,width/2,250);
  x+=1;
}
void drawCircle(int x, int y, float radius) {
  sphere(radius);
  if (radius > 2) {
    stroke(random(0,255),random(0,255),random(0,255));
    radius *= 0.75f;

    drawCircle(x, y, radius);
  }
}
