public class Rocket {
  protected float xPos, yPos, oldX, oldY, newX, newY;
  protected float xVel, yVel;
  protected int generation, lifespan;
  protected color lightColor;
  public Rocket(float x, float y) {
    xPos = oldX = newX = x;
    yPos = oldY = newY = y;
    xVel = 0;
    yVel = 0;
    generation = 1;
    setColor(color((int)(Math.random()*255),255,255));
    setLifespan(100);
  }

  public Rocket(Rocket parent) { //add old & new
    xPos = parent.getX();
    yPos = parent.getY();
    newY = parent.getNewY();
    newX = parent.getNewX();
    oldX = parent.getOldX();
    oldY = parent.getOldY();
    xVel = parent.getYVel();
    yVel = parent.getXVel();
    generation = parent.getGen()+1;
    lightColor = color(
      (255+(hue(parent.getColor())+(int)((Math.random()-0.5)*generation*generation)))%255,
      255-10*generation,
      255
      );     
    lifespan = parent.getLifespan();
  }

  public void move() {
    oldX = newX;
    oldY = newY;
    newY = yPos + (float)(Math.random()-0.5)*2;
    newX = xPos + (float)(Math.random()-0.5)*2;
    xPos += xVel;
    yPos += yVel;
    yVel += 0.1; //could be moved before xPos in move()
    lifespan--;
    if (yVel > 0) {
      lifespan /= 1.1;
    }
  }
  public void show() {
    strokeWeight(10/(generation+1));
    stroke(lightColor);
    line(oldX,oldY,newX,newY);
  }  
  public float getX() {
    return xPos;
  }
  public float getY() {
    return yPos;
  }
  public float getOldX() {
    return oldX;
  }
  public float getOldY() {
    return oldY;
  }  
  public float getNewX() {
    return newX;
  }
  public float getNewY() {
    return newY;
  }    
  public float getXVel() {
    return xVel;
  }
  public float getYVel() {
    return yVel;
  }  
  public int getGen() {
    return generation;
  }  
  public color getColor() {
    return lightColor;
  }
  public void setColor(color newColor) {
    lightColor = newColor;
  }  
  public void setYVel(float yV) {
    yVel = yV;
  }
  public void setXVel(float xV) {
    xVel = xV;
  }  
  public void setLifespan(int ls) {
    lifespan = ls;
  }
  public int  getLifespan() {
    return lifespan;
  }
  
}

public class RocketStar extends Rocket {
  public RocketStar(float x, float y) {
    super(x,y);
    yVel = -60;
  }
  public RocketStar(Rocket rocket) {
    super(rocket);
  }
  public void move() {
    oldX = newX;
    oldY = newY;
    newY = yPos + (float)(Math.random()-0.5)*2;
    newX = xPos + (float)(Math.random()-0.5)*2;
    xPos += xVel;
    yPos += yVel;
    yVel /= 1.1; //could be moved before xPos in move()
    xVel /= 1.1;
    lifespan--;
  }
}


ArrayList <Rocket> rockets = new ArrayList <Rocket>();

public void setup() {
  colorMode(HSB,360,100,100);
  size(1200, 800);
  background(240, 100, 15);
}
boolean pressed = false;
public void mousePressed() {
  pressed = true;
}
public void mouseReleased() {
  pressed = false;
}

public void draw() {
  noStroke();
  fill(240,100,15,20);
  rect(0, 0, width, height);
  if (pressed) {
    rockets.add(new RocketStar(mouseX,height));
  }
  if (Math.random() > 0.99) {
    Rocket newRocket = new Rocket((float)(Math.random()*width), height);
    newRocket.setYVel(-10 + ((float)(Math.random()-0.5)*2));
    newRocket.setLifespan(200+(int)((Math.random()-0.5)*50)); 
    rockets.add(newRocket);
  }
  moveAll(rockets.size()-1);
}

public void moveAll(int pos) {
  if (pos >= 0) {
    Rocket inQuestion = rockets.get(pos);
    if (inQuestion.getLifespan() > 0 && inQuestion.getY() < height + 10) {
      if (Math.random()*inQuestion.getGen()*2 < .1) {
        splitRocket(inQuestion, 2);
        rockets.remove(pos);
      } else {
        inQuestion.move();
        inQuestion.show();
      }
    } else {
      rockets.remove(pos);
    }
    moveAll(pos-1);
  }
}

public void splitRocket(Rocket orig, double probability) {
  if (Math.random() <= probability) {
    Rocket newRocket;
    float power;
    float orientation = (float)Math.random()*2*PI;    
    if (orig instanceof RocketStar) {
      newRocket = new RocketStar(orig);
      power = ((float)Math.random()+4)/orig.getGen();
      orig.setLifespan(orig.getLifespan()/2);
      newRocket.setXVel(power*cos(orientation)*2);
      newRocket.setYVel(power*sin(orientation)*2);  
      rockets.add(newRocket);
      splitRocket(orig, probability/1.05);   
      //maybe very low grav?
    } else {
      newRocket = new Rocket(orig);
      newRocket.setLifespan(newRocket.getLifespan()+(int)newRocket.getY()/25);  
      power = (float)Math.random()*1;
      newRocket.setXVel(orig.getXVel()+power*cos(orientation));
      newRocket.setYVel(orig.getYVel()+power*sin(orientation)*2);       
      rockets.add(newRocket);
      splitRocket(orig, probability/1.5);     
    }





  }
}
