PImage bg;
PImage nseal;
PImage sseal;
PImage omseal;
PImage gfish;
PImage bottle;
PImage extratime;

import oscP5.*;
OscP5 oscP5;
PVector posePosition;
boolean found;
float mouthHeight;
float mouthWidth;
float nostrilHeight;

import processing.sound.*;
SoundFile file;
SoundFile ping;
SoundFile gameoversound;
SoundFile ticking;
//put your audio file name here
String audioName = "sample.mp3";
String pingsound = "ping.mp3";
String gosound = "game_over.mp3";
String ticktack = "ticktack.mp3";

String path;
String path2;
String path3;
String path4;
int width = 827;


float playerXCor = width/2+54;
int playerYCor = 590;
int playerWidth = 54;
int playerHeight = 100;
int difficulty = 5;
int limit = 10;
float score = 0;
Plastic[] plastics;
Goldfish[] goldfish;
Clock[] clock;
boolean plasticisCollided = false;
boolean gfishisCollided = false;
String gameState;
int begin; 
int duration;
int time;
String t;

void initplastics(int xMin, int xMax, int yMin, int yMax, int num){
  plastics = new Plastic[num];

 
  for(int i = 0; i < plastics.length; i++){
     int x = (int)random(xMin, xMax);
     int y = (int)random(yMin, yMax);
     plastics[i] = new Plastic(x, y, 40, 30);
  }
 
}
void initGoldfish(int xMin, int xMax, int yMin, int yMax, int num){
    goldfish = new Goldfish[num];
  for(int i = 0; i < goldfish.length; i++){
       int x = (int)random(xMin, xMax);
       int y = (int)random(yMin, yMax);
       goldfish[i] = new Goldfish(x, y, 40, 30);
    }
}

void initClock(int xMin, int xMax, int yMin, int yMax, int num){
    clock = new Clock[num];
  for(int i = 0; i < clock.length; i++){
       int x = (int)random(xMin, xMax);
       int y = (int)random(yMin, yMax);
       clock[i] = new Clock(x, y, 40, 30);
    }
}




void setup(){
  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "posePosition", "/pose/position");
  textMode(SHAPE);
  size(827,658,P3D);
  bg = loadImage("bg.jpeg");
  nseal = loadImage("normalsealsmall.png");
  sseal = loadImage("sadsealsmall.png");
  omseal = loadImage("openmouthsealsmall.png");
  gfish = loadImage("goldfishsmall.png");
  bottle = loadImage("bottlesmall.png");
  extratime = loadImage("clock.png");

  
  
  path = sketchPath(audioName);
  path2 = sketchPath(pingsound);
  path3 = sketchPath(gosound);
  path4 = sketchPath(ticktack);

  file = new SoundFile(this, path);
  ping = new SoundFile(this, path2);
  gameoversound = new SoundFile(this, path3);
  ticking = new SoundFile(this, path4);

  if (file.isPlaying()==false){
  file.play();}
  
  gameState = "STARTGAME";
  time = duration = 20;
  
}


void draw(){
  image(bg,0,0);
  drawPlayer();
  if (gameState =="STARTGAME"){
    startGame();}
  if (gameState =="CHOOSELEVEL"){
     chooseLevel();}
  if (gameState =="PLAYGAME"){
    playGame();}
  if (gameState =="GAMEOVER"){
    gameOverDisplay();
  }
}

void startGame(){
  posePosition.x = map(posePosition.x,70,530,54,773);
  playerXCor = posePosition.x;
  fill(237,206,185,80);
  rect(0,0,880,880);
  textAlign(CENTER);
  textSize(60);
  fill(0,0,255);
  text("Click Anywhere to Play!", width/2,300);
  textSize(25);
  text("Intructions: Move your face and open mouth to catch fish!", width/2,350);
  text("Catch the Watch, to add +5 seconds to your time.", width/2,380);
  text("Avoid plastic bottles!", width/2,410);
  text("If the time is up, the game will be over!", width/2,440);

  if (mousePressed == true) {
  gameState = "CHOOSELEVEL";
  }
}

void chooseLevel(){
  beginShape();
  fill(0,255,0,85);
  vertex(0,0,275,0);
  vertex(275,0,275,height);
  vertex(275,height,0,height);
  vertex(0,height,0,0);
  endShape();
  fill(0,0,0);
  textSize(30);
  text("Level 1",275/2,height/2);
  textSize(15);
  text("Press '1' to start the game",275/2,80+height/2);
  beginShape();
  fill(255,215,0,85);
  vertex(275,0,551,0);
  vertex(551,0,551,height);
  vertex(551,height,275,height);
  vertex(275,height,275,0);
  endShape();
  fill(0,0,0);
  textSize(30);
  text("Level 2",275+275/2,height/2);
  textSize(15);
  text("Press '2' to start the game",275+275/2,80+height/2);
  beginShape();
  fill(255,0,0,85);
  vertex(551,0,width,0);
  vertex(width,0,width,height);
  vertex(width,height,551,height);
  vertex(551,height,551,0);
  endShape();
  fill(0,0,0);
  textSize(30);
  text("Level 3",551+275/2,height/2);
  textSize(15);
  text("Press '3' to start the game",551+275/2,80+height/2);
  if (keyPressed) { 
  if (key == '1'){
    begin = millis(); 
    difficulty = 5;
    gameState="PLAYGAME";}
  if (key == '2'){
    begin = millis(); 
    difficulty = 10;
    gameState="PLAYGAME";}
  if (key == '3'){
    begin = millis(); 
    difficulty = 15;
    gameState="PLAYGAME";}}
    
  initplastics(-100, width + 20, -500, -80, difficulty);
  initGoldfish(-50, width + 50, -250, -80, int(difficulty/2));
  initClock(-50, width + 50, -250, -80, 1);
}


void playGame(){
  playerXCor = posePosition.x;
  if (time > 0)  time = duration - (millis() - begin)/1000;
  
    if(!plasticisCollided && time>0){
    moveObjects();
    if(score > limit && score < limit + 2){
      initplastics(-100, width + 20, -260, -80, difficulty); 
      difficulty += 5; 
      limit += 20;
    }
  } else{
   gameState = "GAMEOVER";
 }
}


void moveObjects(){
      for(int i = 0; i < plastics.length; i++){
        if(plastics[i].yCor > height){
           plastics[i].yCor = -10;
        }
        plastics[i].display();
        plastics[i].drop(random(1, 15));
      
        boolean conditionXLeft = plastics[i].xCor + plastics[i].w >= playerXCor;
        boolean conditionXRight = plastics[i].xCor + plastics[i].w <= playerXCor + playerWidth + 4;
        boolean conditionUp =  plastics[i].yCor >= playerYCor-20;
        boolean conditionDown = plastics[i].yCor + plastics[i].h <= playerYCor + playerHeight;
      
        if(conditionXLeft && conditionXRight && conditionUp && conditionDown && mouthHeight>1.5){
             plasticisCollided = true;

        }
  
      }
     for(int i = 0; i < goldfish.length; i++){
        if(goldfish[i].yCor > height){
           goldfish[i].yCor = -10;
        }
        goldfish[i].display();
        goldfish[i].drop(random(1, 15));
      
        boolean conditionXLeft = goldfish[i].xCor + goldfish[i].w >= playerXCor;
        boolean conditionXRight = goldfish[i].xCor + goldfish[i].w <= playerXCor + playerWidth + 4;
        boolean conditionUp =  goldfish[i].yCor >= playerYCor-20;
        boolean conditionDown = goldfish[i].yCor + goldfish[i].h <= playerYCor + playerHeight;
      
        if(conditionXLeft && conditionXRight && conditionUp && conditionDown && mouthHeight>1.5){
             gfishisCollided = true;
             ping.play();
             int x = (int)random(20, width-20);
             int y = (int)random(0, -50);
             goldfish[i] = new Goldfish(x, y, 40, 30);;
             score += 2;
        }
     }
        
      for(int i = 0; i < clock.length; i++){
        if(clock[i].yCor > height){
           clock[i].yCor = -10;
        }
        clock[i].display();
        clock[i].drop(random(1, 15));
      
        boolean conditionXLeft = clock[i].xCor + clock[i].w >= playerXCor;
        boolean conditionXRight = clock[i].xCor + clock[i].w <= playerXCor + playerWidth + 4;
        boolean conditionUp =  clock[i].yCor >= playerYCor-20;
        boolean conditionDown = clock[i].yCor + clock[i].h <= playerYCor + playerHeight;
      
        if(conditionXLeft && conditionXRight && conditionUp && conditionDown && mouthHeight>1.5){
             int x = (int)random(30, width-30);
             int y = (int)random(0, -50);
             ticking.play();
             clock[i] = new Clock(x, y, 40, 30);;
             duration = duration + 5;
             
        }
  
      }
    fill(0, 102, 153);
    text("Time Left: " + (int)time, 100, 50);
    text("Score: "+(int)score, 100, 100);
    textSize(25);
}



void drawPlayer(){
  beginShape();
   noStroke();
   if (mouthHeight<1.5){
   texture(nseal);
   } else {
   texture(omseal);}
   vertex(playerXCor-playerWidth/2,playerYCor-playerHeight/2,0,0);
   vertex(playerXCor-playerWidth/2,playerYCor+playerHeight/2,0,100);
   vertex(playerXCor+playerWidth/2,playerYCor+playerHeight/2,54,100);
   vertex(playerXCor+playerWidth/2,playerYCor-playerHeight/2,54,0);
  endShape(CLOSE);
}

void drawGameOverPlayer(){
  beginShape();
   noStroke();
   texture(sseal);
   vertex(playerXCor-playerWidth/2,playerYCor-playerHeight/2,0,0);
   vertex(playerXCor-playerWidth/2,playerYCor+playerHeight/2,0,100);
   vertex(playerXCor+playerWidth/2,playerYCor+playerHeight/2,54,100);
   vertex(playerXCor+playerWidth/2,playerYCor-playerHeight/2,54,0);
  endShape(CLOSE);
}

void gameOverDisplay(){
   fill(0,0,255);
   textSize(80);
   text("GAME OVER",width/2, height/2);
   textSize(50);
   text("Score: "+(int)score,width/2, height/2+50);
   fill(237,206,185,80);
   rect(0,0,880,880);
   drawGameOverPlayer();
   if (gameoversound.isPlaying() == false){
   gameoversound.play();}
   
}


public void mouthWidthReceived(float w) {
  println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  println("mouth height: " + h);
  mouthHeight = h;
}    


public void posePosition(float x, float y) {
  println("pose position\tX: " + x + " Y: " + y );
  posePosition = new PVector(x, y);
}


public void poseOrientation(float x, float y, float z) {
  println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
}
 
