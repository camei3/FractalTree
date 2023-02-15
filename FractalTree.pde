public class Rocket {
  private float xPos, yPos;
  private float xVel, yVel;
  private int generation, lifespan;
  private color lightColor;
  public Rocket(float x, float y) {
    xPos = x;
    yPos = y;
    generation = 1;
    lightColor = color(255);
    setLifespan(100);
  }
  
  public Rocket(Rocket parent) {
    xPos = parent.getX();
    yPos = parent.getY();
    xVel = parent.getYVel();
    yVel = parent.getXVel();
    generation = parent.getGen()+1;
    lightColor = color(255-10*generation);   
    lifespan = parent.getLifespan();
  }
  public float getX() {
    return xPos;
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
    strokeWeight(2/(generation+1));
    stroke(lightColor);
    point(xPos, yPos);
  }
  public void move() {
    xPos += xVel;
    yPos += yVel;
    yVel += 0.1; //could be moved before xPos in move()
    lifespan--;
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
  size(800, 600);
  background(0, 0, 60);
}
public void draw() {
  fill(0, 0, 60, 20);
  rect(0, 0, width, height);
  if (Math.random() > 0.99) {
    Rocket newRocket = new Rocket((float)(Math.random()*width), height);
    newRocket.setYVel(-10 + ((float)(Math.random()-0.5)*2));
    newRocket.setLifespan(150+(int)((Math.random()-0.5)*50));
    rockets.add(newRocket);
  }
  for (Rocket i : rockets) {
    System.out.println(i.getY());
  }
  System.out.println();
  moveAll(rockets.size()-1);
}

public void moveAll(int pos) {
  if (pos >= 0) {
    Rocket inQuestion = rockets.get(pos);
    if (inQuestion.getLifespan() > 0 && inQuestion.getY() < height + 10) {
      if (Math.random()*inQuestion.getGen() < .1) {
        Rocket newRocket = new Rocket(inQuestion);
        System.out.println("Split!");
        newRocket.setXVel(newRocket.getXVel()+(float)(Math.random()-0.5)*10);
        rockets.add(newRocket);
      }
      inQuestion.move();
      inQuestion.show();
    } else {
      rockets.remove(pos);
    }
    moveAll(pos-1);
  }
}
