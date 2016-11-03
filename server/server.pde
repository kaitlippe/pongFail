//https://processing.org/reference/libraries/net/index.html

import processing.net.*;

Server s;
Client c;

int data[];
String input;

Ball ball;  
Paddle p1;
Paddle p2;

int p1Score = 0;
int p2Score = 0;

int r = int(random(255));
int g = int(random(255));
int b = int(random(255));


void setup() {
  size(500, 500);
  frameRate(8);

  p1 = new Paddle(1);
  ball = new Ball();

  s = new Server (this, 8000);
  println(Server.ip()); //gives you your ip address

  rectMode(CENTER);
  text(p1Score, width/2-150, 100);
  text(p2Score, width/2+100, 100);
}



void draw() {
  background(200);
  c = s.available(); //checks if client is speaking to server

  p1.update();
  p1.display();
  ball.update();
  ball.display();


  if (c != null) {
    //String incomingMessage = c.readString();
    input = c.readString();
    input = input.substring(0, input.indexOf("\n"));

    data = int(split(input, " "));
    println(data);
    fill(255);
    rect(data[0], data[1], 20, 100);
  }
}

class Paddle {
  int player;
  int pWidth = 20;
  int pHeight = 100;
  int x = 10;
  int y;

  Paddle(int pNum) {
    player = pNum;  //setting the which player value from the constructor value
    y = height/2;
  }

  void update() {
    if (ball.posX > x - pWidth/2 && ball.posX < x + pWidth/2) {
      if (ball.posY > y - pHeight/2 && ball.posY < y + pHeight/2) {
        ball.contact();
        pHeight -= 5;
        if (pHeight <= 25) {
          pHeight -= 0;
        }
      }
    }

    if (p2Score == 10 || p1Score == 10) {
      pHeight = 100;
      p2Score = 0;
      p1Score = 0;
      r = int(random(255));
      g = int(random(255));
      b = int(random(255));
    }
  }

  void display() {
    rect(x, mouseY, pWidth, pHeight);
    s.write(x + " " + mouseY + "\n");
  }
}

class Ball {
  float posX;
  float posY;
  float velX;
  float velY;
  float size;

  Ball() {
    posX = width/2;
    posY = height/2;
    if (int(random(2)) == 0) {
      velX = 9;
    } else {
      velX = -9;
    }
    velY = random(-5, 5);
    size = 30;
  }

  void update() {
    if (posX < 0) { //if the ball goes off the left side of the screen
      p2Score++;  //increase player 2 score
      posX = width/2;
      posY = height/2;
      velX = -9;
      velY = random(-5, 5);
    } else if (posX > width) {
      p1Score++;  //increase player 1 score
      posX = width/2;
      posY = height/2;
      velX = 9;
      velY = random(-5, 5);
    }


    if (posY > height - size/2) { //bounce off the bottom
      posY = height - size/2;
      velY = -velY;
    } else if (posY < 0 + size/2) { //bounce off the top
      posY = 0 + size/2;
      velY = -velY;
    }

    posX += velX;
    posY += velY;
  }

  void display() {
    fill(255, 255, 255);
    rect(posX, posY, size, size);
    fill(255);
  }

  void contact() {  //call this function when the ball contacts the paddle
    posX = posX - velX;  //step the ball back one frame
    velX = -velX;
    velY = random(-5, 5);
    velX += velX * 0.01;  //increase the speed of the ball by 1% every time it hits a paddle
    velY += velY * 0.01;
  }
}