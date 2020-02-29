class Player{
  
  PVector position;
  float orientation;
  Bullet[] bullets;
  int[][] level;
  boolean isAlive;
  int lives;
  int invulnerability_timer;
  Player(float posx, float posy, float orientation, int[][] l){
    position=new PVector(posx,posy);
    this.orientation=orientation;
    bullets=new Bullet[0];
    level=l;
    isAlive=true;
    lives=3;
    invulnerability_timer=0;
  }
  void orient(float orientation){
    this.orientation=orientation;
  }
  void move(int a){
    if(isAlive){
      
      switch(a){
        case 0: 
          if(level[(int)position.y+5][(int)position.x+7]==1 && level[(int)position.y-5][(int)position.x+7]==1)
            position.x+=2; 
          break;
        case 1: 
          if(level[(int)position.y+5][(int)position.x-7]==1 && level[(int)position.y-5][(int)position.x-7]==1)
            position.x-=2; 
          break;
        case 2: 
          if(level[(int)position.y+7][(int)position.x+5]==1 && level[(int)position.y+7][(int)position.x-5]==1)
            position.y+=2; 
          break;
        case 3: 
          if(level[(int)position.y-7][(int)position.x+5]==1 && level[(int)position.y-7][(int)position.x-5]==1 )
            position.y-=2; 
        break;
        case 4: 
          if(level[(int)position.y-7][(int)position.x-7]==1){
            position.y-=2; 
            position.x-=2; 
          }
          break;
        case 5: 
          if(level[(int)position.y-7][(int)position.x+7]==1){
            position.y-=2; 
            position.x+=2; 
          }
          break;
        case 6: 
          if(level[(int)position.y+7][(int)position.x-7]==1){
            position.y+=2; 
            position.x-=2; 
          }
          break;
        case 7: 
          if(level[(int)position.y+7][(int)position.x+7]==1){
            position.y+=2; 
            position.x+=2; 
          }
          break;
      
      }
    }
  }
  void draw_player(){
    if(invulnerability_timer>0){
      invulnerability_timer--;
    fill(184,134,11);}
    else{
    fill(255);
    }
    ellipse(position.x,position.y,10,10);
    fill(0);
    ellipse(position.x+(4* cos(orientation)),position.y+(4* sin(orientation)),2,2);
    drawBullets();
  }
  void shoot(PVector dest){
    removeBullets();
    Bullet[] tempBullets=bullets;
    bullets=new Bullet[tempBullets.length+1];
    for(int i=0;i<tempBullets.length;i++)
      bullets[i]=tempBullets[i];
    bullets[bullets.length-1]=new Bullet((int)position.x,(int)position.y,(int)dest.x,(int)dest.y,level);
    
  }
  void removeBullets(){
    for(int i=0;i<bullets.length;i++){
      if(bullets[i].isAlive==false){
        Bullet[] temp=bullets;
        bullets=new Bullet[temp.length-1];
        for(int j=0;j<i;j++)
          bullets[j]=temp[j];
        for(int j=i;j<bullets.length;j++)
          bullets[j]=temp[j+1];
        i--;
      }
    }
  }
  void drawBullets(){
    removeBullets();
    for(int i=0;i<bullets.length;i++)
      bullets[i].drawBullet();
  }
  int reduce_life(){
    if(invulnerability_timer<=0){
      lives--;
      if(lives==0)
        isAlive=false;
    }
    return lives;
  }
}
