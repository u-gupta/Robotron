class PowerUps{
  char type;
  int x,y;
  boolean isAlive;
  AudioPlayer freeze;
  AudioPlayer bomb;
  AudioPlayer invulnerability;
  PowerUps(roomTreeNode room, Obstacle[] o,Player p, char type, PowerUps[] power, AudioPlayer freeze, AudioPlayer bomb,AudioPlayer invulnerability){
    
    x=(int)random(room.x1,room.x2-14);
    y=(int)random(room.y1,room.y2-14);
    while(resolute(power,o,p,x,y)==false){
      x=(int)random(room.x1,room.x2-14);
      y=(int)random(room.y1,room.y2-14);
    }
    this.type=type;
    isAlive=true;
    this.freeze=freeze;
    this.bomb=bomb;
    this.invulnerability=invulnerability;
  }
  
  boolean resolute(PowerUps[] power, Obstacle[] o, Player p, float x, float y){
    //System.out.println("HUMAN Resolute "+ r1.length);
        
    for(int i=0;i<o.length;i++)
      if(abs((x+7)-(o[i].x+7))<=15 && abs((y+7)-(o[i].y+7))<=15)
        return false;
        
    for(int i=0;i<power.length;i++)
      if(abs((x+7)-(power[i].x+7))<=15 && abs((y+7)-(power[i].y+7))<=15)
        return false;
    
    if(abs((x+7)-p.position.x)<=14 && abs((y+7)-p.position.y)<=14)
      return false;
    
    return true;
  }
  
  void activate_powerup(Robot[] r1, Robot[] r2, Robot[] r3, Robot[] r4, Obstacle[] o, Boss B){
    bomb.rewind();
    bomb.play(1100);
    final int EXPLOSION_SIZE=100;  
    for(int i=0;i<r1.length;i++)
        if(abs(r1[i].position.x-x)<=EXPLOSION_SIZE && abs(r1[i].position.y-y)<=EXPLOSION_SIZE )
          r1[i].isAlive=false;
          
      for(int i=0;i<r2.length;i++)
        if(abs(r2[i].position.x-x)<=EXPLOSION_SIZE && abs(r2[i].position.y-y)<=EXPLOSION_SIZE )
          r2[i].isAlive=false;
          
      for(int i=0;i<r3.length;i++)
        if(abs(r3[i].position.x-x)<=EXPLOSION_SIZE && abs(r3[i].position.y-y)<=EXPLOSION_SIZE )
          r3[i].isAlive=false;
          
      for(int i=0;i<r4.length;i++)
        if(abs(r4[i].position.x-x)<=EXPLOSION_SIZE && abs(r4[i].position.y-y)<=EXPLOSION_SIZE )
          r4[i].isAlive=false; 
          
      for(int i=0;i<o.length;i++)
        if(abs(o[i].x-x)<=50 && abs(o[i].y-y)<=50 )
          o[i].isAlive=false;
      
      
      if(B!=null && abs(B.position.x-x)<=EXPLOSION_SIZE && abs(B.position.y-y)<=EXPLOSION_SIZE )
        B.current_HP-=10;  
  }
  
  void activate_powerup(Player p){
    invulnerability.rewind();
    invulnerability.play();
    
    p.invulnerability_timer=240;
  }
  
  void activate_powerup(Robot[] r1, Robot[] r2, Robot[] r3, Robot[] r4){
    freeze.rewind();
    freeze.play(6000);
    for(int i=0;i<r1.length;i++)
      r1[i].freeze_timer=300;
      
    for(int i=0;i<r2.length;i++)
      r2[i].freeze_timer=300;
      
    for(int i=0;i<r3.length;i++)
      r3[i].freeze_timer=300;
      
    for(int i=0;i<r4.length;i++)
      r4[i].freeze_timer=300;
  }
  
  void check_activation(Player p, Obstacle[] o, Robot[] r1, Robot[] r2, Robot[] r3, Robot[] r4, Boss B){
    if(abs(p.position.x-(x+7))<=14 &&abs(p.position.y-(y+7))<=14 ){
      switch(type){
        case 'F': activate_powerup(r1, r2, r3, r4); break;
        case 'B': activate_powerup(r1, r2, r3, r4, o, B); break;
        case 'I': activate_powerup(p); break;
        
      }
      isAlive=false;
    } 
  }
  
  void draw_powerup(){
    switch(type){
      case 'F':{
        stroke(113,166,210);
        fill(240,248,255);
        rect(x,y,14,14);
        noStroke();
        fill(0);
        text(type,x+4,y+11);
      } break;
      case 'B':{
        noStroke();
        fill(0);
        rect(x,y,14,14);
        noStroke();
        fill(255);
        text(type,x+3,y+11);
      } break;
      case 'I':{
        stroke(0);
        fill(184,134,11);
        rect(x,y,14,14);
        noStroke();
        fill(0);
        text(type,x+6,y+11);
      } break;
    }
  }
}
