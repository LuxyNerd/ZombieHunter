Wall[] walls = new Wall[32]; //Anzahl Wände
Dot[] dots = new Dot[275]; //Anzahl Dots
Character[] zombies = new Character[4];  //Anzahl Zombies

Character hunter;

color backgroundColor = color(0, 0, 0);
color wallColor = color(50, 205, 50); //grelles gruen
color dotColor = color(255, 255, 0); //gelb
color pointsColor = color(0, 0, 255);

boolean won = false;
boolean lost = false;

void setup() {
  size(1440,760);
  frameRate(30); 

  hunter = new Character(40, 40, loadImage("hunter_klein.png"), 10, true);
  zombies[0] = new Character(1400, 720, loadImage("zombie_klein_blau.png"), 1, false);
  zombies[1] = new Character(1400, 620, loadImage("zombie_klein_lila.png"), 1, false);
  zombies[2] = new Character(1400, 620, loadImage("zombie_klein_orange.png"), 2, false);
  zombies[3] = new Character(1400, 620, loadImage("zombie_klein_rot.png"), 3, false); 
  
  //Zombie position correction
  zombies[0].x -= zombies[0].image.width;
  zombies[0].y -= zombies[0].image.height+100;
  zombies[1].x -= zombies[1].image.width;
  zombies[1].y -= zombies[1].image.height;
  zombies[2].x = zombies[2].image.width+480; // rechts beim o beginnen
  zombies[2].y = zombies[2].image.height+250;
  zombies[3].x = zombies[3].image.width;
  zombies[3].y = zombies[3].image.height+580;
  
  //Der Rahmen
  walls[0] = new Wall(0,0,1410,30);//obere 
  walls[1] = new Wall(0,730,1410,30);// untere
  walls[2] = new Wall(0,30,30,760);//links
  walls[3] = new Wall(1410,0,30,760);//rechts
  //Z 
  walls[4] = new Wall(110,215,175,50);//obereBalken
  walls[5] = new Wall(110,515,175,50);//untereBalken
  walls[6] = new Wall(235, 245, 50, 50);// ab hier die Schrägex-25,y+50
  walls[7] = new Wall(210, 295, 50, 50);
  walls[8] = new Wall(185, 345, 50, 50);
  walls[9] = new Wall(160, 385, 50, 50);
  walls[10] = new Wall(135, 435, 50, 50);
  walls[11] = new Wall(110, 485, 50, 50);
  //O 
  walls[12] = new Wall(365,515,150,50); //O unten
  walls[13] = new Wall(365,365,150,50); //O oben
  walls[14] = new Wall(370,365,50,150); //links 
  walls[15] = new Wall(460,365,50,150); //rechts
  //M
  walls[16] = new Wall(590,305,50,350); //linker balken
  walls[17] = new Wall(760,305,50,350); //rechter balken
  walls[18] = new Wall(630,365,50,50); //quad links oben
  walls[19] = new Wall(680,415,40,50); //quad mitte
  walls[20] = new Wall(720,365,50,50); //quad rechts oben
  //B 
  walls[21] = new Wall(791,115,50,350); //balken links 
  walls[22] = new Wall(835,115,100,50); //balken oben
  walls[23] = new Wall(905,165,52,100); //balken rechts oben
  walls[24] = new Wall(835,265,100,50); //balken mitten
  walls[25] = new Wall(905,315,52,100); //balken rechts unten
  walls[26] = new Wall(835,415,100,50); //balken unten
  //I
  walls[27] = new Wall(1030,215,50,350); //oberen Balken Z orientiert
  //E
  walls[28] = new Wall(1155,215,50,350); //balken links
  walls[29] = new Wall(1155,215,175,50); //balken oben // Z obere Balken orientiert
  walls[30] = new Wall(1155,515,175,50); //balken unten // Z untere Balken orientiert
  walls[31] = new Wall(1155,355,100,50); //balken mitte 
  
  //Dots Zeichnen in x und y Richtung
  for (int iY = 0; iY < 11; iY++) {
    for (int iX = 0; iX < 25; iX++) {
      dots[iY * 25 + iX] = new Dot(55 * (iX+1)+ 10, 60 * (iY+1) + 20, 5); 
    }
  }
  
  drawEnvironment(true);
}

void draw() {
  
  won = true;
  
  for (int i = 0; i < dots.length; i++) {
    if (won) {
      won = dots[i].eaten;
    }
  }

  if (!won && !lost) {
    background(backgroundColor);
    drawEnvironment(false);
    hunter.paint();

    for(int i = 0; i < zombies.length; i++) {
      zombies[i].paint();
      moveZombie(zombies[i]);
    }
    
    
    
  } else  {
    background(backgroundColor);
    textSize(64);
    if (won) {
      fill(76, 153, 0);
      text("You've got away from the Zombies.", width/20, height/3);
      text(" You're genius!",width/3,height/2);
    } else {
      fill(204, 0, 0);
      text("The Zombies have eaten you. You've failed!", width/20, height/3);
    }
    
    fill(255, 0, 0);
  }  
}

//TODO: add possibility to shoot
void keyPressed() {
  if (keyCode == LEFT) {
    if (canMove(hunter.x-hunter.stepSize, hunter.y, hunter)){
     hunter.x -= hunter.stepSize;  
    }
     
  }
  if (keyCode == RIGHT) {
    if(canMove(hunter.x+hunter.stepSize, hunter.y, hunter)){
     hunter.x += hunter.stepSize; 
    }
    
  }
  if (keyCode == UP) {
    if(canMove(hunter.x, hunter.y-hunter.stepSize, hunter)){
     hunter.y -= hunter.stepSize; 
    }
    
  }
  if (keyCode == DOWN) {
    if(canMove(hunter.x, hunter.y+hunter.stepSize, hunter)){
     hunter.y += hunter.stepSize; 
    }
   
  }
}

void drawEnvironment(boolean setup) {
  drawWalls();
  
  if (setup) {
    for(int i = 0; i < dots.length; i++) {
      
      Dot dot = dots[i];
      
      int dotMidX = dot.x + dot.radius;
      int dotMidY = dot.y + dot.radius;
      
      for(int j = 0; j < walls.length; j++) {
        Wall wall = walls[j];
        // Wand künstlich vergrößern (=große Hitbox) um ein Dots zu verhindern, die direkt an der Wall hängen und somit unerreichbar sind
        int wallX = wall.x - hunter.stepSize;
        int wallY = wall.y - hunter.stepSize;
        int wallWidth = wall.x + wall.width + hunter.stepSize;
        int wallHeight = wall.y + wall.height + hunter.stepSize;
        
        if (dotMidX >= wallX && dotMidX <= wallWidth && dotMidY >= wallY && dotMidY <= wallHeight) {
          //Dot gefressen von der Wand
          dot.eaten = true;
        }
      }
    }
  } 

  drawDots();
  drawPoints();
}

void drawWalls(){
  
  for( int i = 0; i < walls.length; i++) {
    noStroke();
    rect(walls[i].getX(), walls[i].getY(), walls[i].getWidth(), walls[i].getHeight());
  }
  
  
}

void drawDots() {
  fill(dotColor);
  for (int i = 0; i < dots.length; i++) {
    if(!dots[i].eaten) {
      noStroke();
      ellipse(dots[i].x, dots[i].y, dots[i].radius*2, dots[i].radius*2);
    }
  }
  fill(wallColor);
}

void drawPoints() {
  int leftDots = 0;
  
  for(int i = 0; i < dots.length; i++) {
    Dot dot = dots[i];
    if(!dot.eaten) {
      leftDots++;
    }
  }
  int leftDotsprint=leftDots;
  fill(pointsColor);
  textSize(20);
  text("Dots left: " + leftDotsprint, 5, 25);
  fill(wallColor);
  
}


boolean canMove(int newX, int newY, Character object) {
  //Check wall collision
  for (int i = 0; i < walls.length; i++) {
    Wall wall = walls[i];
    
    if (((newX >= wall.x && newX <= wall.x +  wall.width ||  //linkes oberes ende ODER rechtes oberes ende
        newX + object.image.width >= wall.x && newX <= wall.x +  wall.width) && // !UND!
        (newY >= wall.y && newY <= wall.y + wall.height || //linkes unteres Ende ODER
        newY + object.image.height >= wall.y && newY + object.image.height <= wall.y + wall.height)) //rechtes unteres ende 
        || // und den ganzen Spaß umdrehen und "oder"-verknüpfen, damit  die Kollisionsabfrage auch in die andere Richtung funktioniert
        ((wall.x >= newX && wall.x <= newX + object.image.width ||
        wall.x + wall.width >= newX && wall.x <= newX + object.image.width) &&
        (wall.y >= newY && wall.y <= newY + object.image.height ||
        wall.y + wall.height >= newY && wall.y + wall.height <= newY + object.image.height)) ) { 
          return false;
        }
  }
  
  Character[] charsToCheck = new Character[zombies.length + 1]; //Hunter muss auch geprüft werden, deshalb +1
  
  //Zuerst alle zombies reinpacken
  for (int i = 0; i < zombies.length; i++) {
    charsToCheck[i] = zombies[i];
  }
  
  //und dann an die letzte Stelle den Hunter packen
  charsToCheck[zombies.length] = hunter;
  
  for (int i = 0; i < charsToCheck.length; i++) {
    
    Character charToCheck = charsToCheck[i];
    
    if(charToCheck == object) {
      //Kollision mit sich selber ist unnötig zu prüfen und wäre immer true
      break;
    }
    
    if((object.x >= charToCheck.x && object.x <= charToCheck.x+charToCheck.image.width &&
        object.y >= charToCheck.y && object.y <= charToCheck.y+charToCheck.image.height) ||
        (object.x + object.image.width >= charToCheck.x && object.x + object.image.width <= charToCheck.x+charToCheck.image.width &&
        object.y >= charToCheck.y && object.y <= charToCheck.y+charToCheck.image.height) ||
       (object.x >= charToCheck.x && object.x <= charToCheck.x+charToCheck.image.width &&
        object.y + object.image.height >= charToCheck.y && object.y + object.image.height <= charToCheck.y+charToCheck.image.height) ||
        (object.x + object.image.width >= charToCheck.x && object.x + object.image.width <= charToCheck.x+charToCheck.image.width &&
         object.y + object.image.height >= charToCheck.y && object.y + object.image.height <= charToCheck.y+charToCheck.image.height)) {
        if (object.isHero || charToCheck.isHero) {
          lost = true;
        }
        return false;
     }
  }
  
  
  //Remove dots which are collected by hunter
  for (int i = 0; i < dots.length; i++) {
    Dot dot = dots[i];
    
    if ((dot.x + dot.radius >= hunter.x && 
    dot.x + dot.radius <= hunter.x + hunter.image.width &&
    dot.y + dot.radius >= hunter.y &&
    dot.y + dot.radius <= hunter.y + hunter.image.height)) {
      dot.eaten = true;
    }
    
  }
  
  return true;
}

void moveZombie(Character zombie) {
   float direction = random(0,1);
   
   int nextX = zombie.x;
   int nextY = zombie.y;
   
   
   if(direction >= 0 && direction < 0.5) {    //Horizontal
     if(hunter.x < nextX) {
       nextX -= zombie.stepSize;
     } else {
       nextX += zombie.stepSize;
     }
   } else {                                   //Vertikal
     if(hunter.y < nextY) {
       nextY -= zombie.stepSize;
     } else {
       nextY += zombie.stepSize;
     }
   }
   
   if(canMove(nextX, nextY, zombie)) {
     zombie.x = nextX;
     zombie.y = nextY;
   }
}