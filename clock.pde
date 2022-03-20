
class Clock{

  public int xCor;
  public int yCor;
  public int w;
  public int h;

  Clock(int xVal, int yVal, int wVal, int hVal){
    xCor = xVal;
    yCor = yVal;
    w = wVal;
    h = hVal;
    
  } 
  
  public void drop(float speed){
    yCor += speed;
    if (yCor > 658){
    xCor = (int)random(0, width);
    }
  }
  
  public void display(){
    beginShape();
     noStroke();
     texture(extratime);
     vertex(xCor,yCor,0,0);
     vertex(xCor,yCor+h,0,h);
     vertex(xCor+w,yCor+h,w,h);
     vertex(xCor+w,yCor,w,0);
    endShape(CLOSE);
  }
}
