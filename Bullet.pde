class Bullet{
  
  PVector position,direction,orientation;
  int[][] l;
  boolean isAlive;
  Bullet(int originX, int originY, int destX, int destY, int[][] level){
        
    position=new PVector(originX,originY);
        
    direction=new PVector(destX-originX,destY-originY);
        
    orientation=new PVector(direction.x/abs(direction.x),direction.y/abs(direction.y));
        
    isAlive=true;
        
    l=level;
    
  }
  void move(){
    float direction_percent_x= abs(direction.x) / ( abs(direction.x) + abs(direction.y));
    float direction_percent_y= abs(direction.y) / ( abs(direction.x) + abs(direction.y));
    
    float updation_x= 1/(float)Math.sqrt(1+(Math.pow((direction_percent_y/direction_percent_x),2)));
    float updation_y= 1/(float)Math.sqrt(1+(Math.pow((direction_percent_x/direction_percent_y),2)));
    
    updation_x*=orientation.x;
    updation_y*=orientation.y;
    
    if(l[(int)(position.y+updation_y)][(int)(position.x+updation_x)]==1){
      position.y+=updation_y;
      position.x+=updation_x;
    }
    if(position.y+updation_y>=600 || position.y+updation_y<0 || position.x+updation_x<0 || position.x+updation_x>=800 ||l[(int)(position.y+updation_y)][(int)(position.x+updation_x)]==0)
      isAlive=false;
  }
  
  void drawBullet(){
    for(int i=0;i<10;i++)
      move();
    noStroke();
    fill(85,65,6);
    rect(position.x-1,position.y-1,2,2);
  }
  
}
