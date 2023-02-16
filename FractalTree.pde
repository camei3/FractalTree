public class Rocket {
  private float xPos, yPos;
  private float xVel, yVel;
  private int generation, lifespan;
  private color lightColor;
  public Rocket(float x, float y) {
    xPos = x;
    yPos = y;
    xVel = 0;
    yVel = 0;
    generation = 1;
    lightColor = color((int)(Math.random())*256);
    setLifespan(100);
  }

  public Rocket(Rocket parent) {
    xPos = parent.getX();
    yPos = parent.getY();
    xVel = parent.getYVel();
    yVel = parent.getXVel();
    generation = parent.getGen()+1;
    colorMode(HSB,255);    
    lightColor = color(hue(parent.getColor())-2*generation,255-10*generation,255);   
    colorMode(RGB,255);    
    lifespan = parent.getLifespan();
  }
  public float getX() {
    return xPos;
  }
  public color getColor() {
    return lightColor;
  }
  public void setColor(color newColor) {
    lightColor = newColor;
  }
  public float getY() {
    return yPos;
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
  public void show() {
    strokeWeight(10/(generation+1));
    stroke(lightColor);
    point(xPos, yPos);
  }
  public void move() {
    xPos += xVel;
    yPos += yVel;
    yVel += 0.1; //could be moved before xPos in move()
    lifespan--;
    if (yVel > 0) {
      lifespan /= 1.1;
    }
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

ArrayList <Rocket> rockets = new ArrayList <Rocket>();

public void setup() {
  size(1200, 800);
  background(0, 0, 60);
}
public void draw() {
  noStroke();
  fill(0, 0, 60, 20);
  rect(0, 0, width, height);

  if (Math.random() > 0.99) {
    Rocket newRocket = new Rocket((float)(Math.random()*width), height);
    newRocket.setYVel(-10 + ((float)(Math.random()-0.5)*2));
    newRocket.setLifespan(200+(int)((Math.random()-0.5)*50));
    colorMode(HSB,255);
    newRocket.setColor(color((int)(Math.random()*255),255,255));
    colorMode(RGB,255);    
    rockets.add(newRocket);
  }
  //for (Rocket i : rockets) {
  //  System.out.println(i.getY());
  //}
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
    Rocket newRocket = new Rocket(orig);
    float orientation = (float)Math.random()*2*PI;
    float power = (float)Math.random()*1;
    newRocket.setXVel(orig.getXVel()+power*cos(orientation));
    newRocket.setYVel(orig.getYVel()+power*sin(orientation)*2); 
    newRocket.setLifespan(newRocket.getLifespan()+(int)newRocket.getY()/25);
    rockets.add(newRocket);
    splitRocket(orig, probability/1.5);
  }
}
