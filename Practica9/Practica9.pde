import processing.video.*;
import processing.sound.*;
import cvimage.*;
import org.opencv.core.*;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;
PShader sh;

boolean musicPlaying; 
int option = 0;
int dimension;
int filterStart;
int yText;
SoundFile spainSound;
Capture cam;


//Cosas CV
CVImage img;
CascadeClassifier face,leye,reye;


void setup(){
   size(640,480,P3D);
   cam = new Capture(this,width,height);
   cam.start();
   dimension = cam.width * cam.height;
   spainSound = new SoundFile(this,"espana.mp3");
   musicPlaying = false;
   
   
   //CV
   
   System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
   img = new CVImage(cam.width, cam.height);

   face = new CascadeClassifier(dataPath("haarcascade_frontalface_default.xml"));
  
   
   yText = 20;
   sh = loadShader("myShader.glsl");
}

void draw(){
  if(!cam.available()) return;
  background(0);
  
  cam.read();
  switch(option){
    case 0: 
      image(cam,0,0);
      break;
    case 1: 
      spainMode();
      break;
    case 2: 
      pixelMode();
      break;
    case 3:
      xavierMode();
      break;
  }
  textSize(15);
  textAlign(CENTER);
  text("Espacio : cámara normal",(width/6),yText);
  text("P : pixelar cámara",(width/6)*3,yText);
  text("E : modo Spain", (width/6)*4 + 100,yText);
}

void toRed(int start, int end){
  for(int i = start; i < end; i++){
     float blue = blue(cam.pixels[i]); //max(blue(cam.pixels[i]),1);
     
     float green = green(cam.pixels[i]);// max(green(cam.pixels[i])-10,1);
     
     float red = min(200,red(cam.pixels[i])+filterStart);
     cam.pixels[i] = color(red,green,blue);
  }
}

void toYellow(int start, int end){
  for(int i = start; i < end; i++){
     float blue = blue(cam.pixels[i]);
     float green = min(200,green(cam.pixels[i])+filterStart) ;
     float red = min(200,red(cam.pixels[i])+filterStart);
     cam.pixels[i] = color(red,green,blue);
  }
}

void spainMode(){
  playMusic();
  cam.loadPixels();
  toRed(1,(dimension/7)*2);
  toYellow((dimension/7)*2,(dimension/7)*5);
  toRed((dimension/7)*5,dimension);
  cam.updatePixels();
  if(filterStart < 256) filterStart++;
  image(cam,0,0);
}
void keyPressed(){
  
  if(key == 'E' || key == 'e'){
    resetShader();
    stopMusic();
    option = 1;
    filterStart = 0;
  }
  if(key == ' ') {
    resetShader();
    stopMusic();
    option = 0;
    filterStart = 0;  
  }
  if(key == 'p' || key == 'P') {
    resetShader();
    stopMusic();
    option = 2;
    filterStart = 0;  
  }
  if(key == 'x' || key == 'X'){
    stopMusic();
    option = 3;
    filterStart=0;
  }
}

void playMusic(){
  if(musicPlaying) return;
  switch(option){
    case 1: 
      spainSound.play();
      musicPlaying = true;
      break;
  }
}

void stopMusic(){
  if(!musicPlaying) return;
  switch(option){
    case 1: 
      spainSound.stop();
      musicPlaying = false;
      break;
  }
}



void pixelMode(){
  img.copy(cam,0,0,cam.width,cam.height,0,0,img.width,img.height);
  img.copyTo();
  Mat gris = img.getGrey();
  image(img,0,0);
  FaceDetector(gris);
  gris.release();
  
}

void FaceDetector(Mat gris){
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(gris,faces,1.15,3,Objdetect.CASCADE_SCALE_IMAGE, new Size(60,60),new Size(200,200));
  Rect [] facesArr = faces.toArray();
  
  //noFill();
  //stroke(255,0,0);
  strokeWeight(1);
  cam.loadPixels();
  for (Rect r : facesArr) {    
    //rect(r.x, r.y, r.width, r.height);
    
    pixelate(r.x, r.y, r.width, r.height);
   
    //for(int i = r.y+1; i < r.height)

   }
   cam.updatePixels();
   image(cam,0,0);
   faces.release();
  
}

void pixelate(int startX, int startY,int pxWidth, int pxHeight){
    
  
  for (int y = startY ; y < startY + pxHeight + 20; y+=30) {
    for(int x = startX; x < startX + pxWidth + 20; x+=30){
      if((x+ y*img.width > dimension - 1) || (x + y*img.width < 1)) return;
      int colore = color(red(cam.pixels[x + y*img.width]),
                          green(cam.pixels[x + y*img.width]),
                          blue(cam.pixels[x + y*img.width])
                          );
      cam.pixels[x + y*img.width]= colore;
      for(int j = y-15; j < y + 15; j++ ){
        for(int i = x -15; i < x + 15; i++){
           //if(i + j * img.width < img.width*img.height -1 && i + j*img.width > 0)
           if((i + j*img.width > dimension) || (i + j*img.width < 1)) return;
           cam.pixels[i + j*img.width]= colore;
        }
      }
     
    }
  } 
}


void xavierMode(){
  img.copy(cam,0,0,cam.width,cam.height,0,0,img.width,img.height);
  img.copyTo();
  sh.set("u_resolution", float(width), float(height));
  sh.set("u_time", millis() / 1000.0);
  sh.set("u_speed",0.1);
  image(img,0,0);
  Mat gris = img.getGrey();
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(gris,faces,1.15,3,Objdetect.CASCADE_SCALE_IMAGE, new Size(60,60),new Size(200,200));
  Rect [] facesArr = faces.toArray();
  gris.release();
  faces.release();
  if(facesArr.length > 0){
    float xPos = float(facesArr[0].x + facesArr[0].width/2);
    float yPos = float(facesArr[0].y);
    sh.set("u_position",xPos,yPos);
    filter(sh);
  }else resetShader();
}
