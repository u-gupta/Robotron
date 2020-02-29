class Obstacle{
  
  roomTreeNode room;
  int l[][];
  boolean isAlive;
  int x, y;
  Player p;
  Obstacle(roomTreeNode room, int l[][], Obstacle[] o, Player p){
    //System.out.println("Creating obsatcle number"+ o.length);
    this.room=room;
    this.l=l;
    isAlive=true;
    x=(int)random(room.x1,room.x2-14);
    y=(int)random(room.y1,room.y2-14);
    this.p=p;
    while(resolute(o)==false){
      x=(int)random(room.x1,room.x2-14);
      y=(int)random(room.y1,room.y2-14);
    }
      
  }
  
  boolean resolute(Obstacle[] o1){
    for(int i=0;i<o1.length;i++)
      if(abs(x-o1[i].x)<=14 && abs(y-o1[i].y)<=14)
        return false;
        
    for(int i=0;i<15;i++){
    
      if( y+i<600 && x<800 && y+i>=0 && y>=0 && x>=0 && x+i>=0 && x+i<800 && y<600 &&
         l[y+i][x]==0   || l[y][x+i]==0
       )
       
        return false;
    }
       
    if(abs((x+7)-p.position.x)<=14 && abs((y+7)-p.position.y)<=14)
      return false;
    
    return true;
  }
  
  void draw_obstacle(){
    //System.out.println("Drawing Obsatcle");
      stroke(255,0,0);
      fill(255,170,0);
      rect(x,y,14,14);
  }
  
  boolean check_death(int x,int y){
    if(abs(x-(this.x+7))<=7 && abs(y-(this.y+7))<=7)
      isAlive=false;
    return isAlive;
  }
  
}
