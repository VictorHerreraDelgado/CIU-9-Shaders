import processing.video.*;

PShader sh;
Capture cam;

boolean doSomething;
void setup() {
  
  size(640, 480, P2D);
  noStroke();
  fill(204);
  sh = loadShader("myShader.glsl");
  cam = new Capture(this, width, height);
  cam.start();
  doSomething = false;
}

void draw() {
  sh.set("u_resolution", float(width), float(height));
  sh.set("u_mouse", float(mouseX), float(mouseY));
  sh.set("u_time", millis() / 1000.0);
  if (cam.available() == true) {
    cam.read();
  }
  image(cam,0,0);
  if (doSomething)
    filter(sh);
  else
    resetShader();
  //rect(0,0,width,height);
  
}

void keyReleased(){
  if(keyCode == ENTER) doSomething = !doSomething;
}
