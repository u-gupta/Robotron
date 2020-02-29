class Human{
  
  final float orientation_increment=PI/32;
  int type;
  PVector origin,destination;
  PVector temp_origin,temp_destination, temp_position;
  int seek_counter;
  PVector position, path, direction;
  boolean isAlive;
  float current_orientation, final_orientation;
  int l[][];
  int seek_flag;
  roomTreeNode room;
  boolean detected;
  PVector pursuer;
  Human(int type, int originX, int originY, int destX, int destY, int[][] level, roomTreeNode room){
    //System.out.println("NEW HUMAN CREATED!!");
    this.type=type;
    
    origin= new PVector(originX,originY);
    position= new PVector(originX,originY);
    destination=new PVector(destX,destY);
    pursuer=new PVector(1,1);
    set_values(0,0);
    l=level;
    isAlive=true;
    seek_flag=0;
    this.room=room;
    detected=false;
  }
  Human(){}
  
  void set_values(int a,int b){
    
    path=new PVector(destination.x-position.x,destination.y-position.y);
    
    if(path.x!=0 && path.y!=0)
      direction=new PVector(path.x/abs(path.x),path.y/abs(path.y));
    else if(path.x==0 && path.y!=0)
      direction=new PVector(0,path.y/abs(path.y));
    else if(path.x!=0 && path.y==0)
      direction=new PVector(path.x/abs(path.x),0);
    else if(path.x==0 && path.y==0)
      direction=new PVector(0,0);
      
    if(b==1)
      seek_counter=0;
    
    if(a==0)
      current_orientation=atan2(path.y, path.x);
    final_orientation=atan2(path.y, path.x);
    detected=false;
    
  }
  void move(Robot[] r, Human[] h, Obstacle[] o){
    float direction_percent_x= abs(path.x) / ( abs(path.x) + abs(path.y));
    float direction_percent_y= abs(path.y) / ( abs(path.x) + abs(path.y));
    float updation_x;
    
    if(direction_percent_x!=0)
      updation_x= 1/(float)Math.sqrt(1+(Math.pow((direction_percent_y/direction_percent_x),2)));
    else
      updation_x=0;
      
    float updation_y;
    
    if(direction_percent_x!=0)
      updation_y= 1/(float)Math.sqrt(1+(Math.pow((direction_percent_x/direction_percent_y),2)));
    else
      updation_y=0;
      
    updation_x*=direction.x;
    updation_y*=direction.y;
    int resolution=0;
    if(resolute(r,h,o,position.x+updation_x, position.y+updation_y ) 
    && (int)(position.y+updation_y+(7*direction.y))<600 
    && (int)(position.x+updation_x+(7*direction.x)) < 800 
     &&(int)(position.y+updation_y+(7*direction.y))>=0
     && (int)(position.x+updation_x+(7*direction.x))>=0
    && l[(int)(position.y+updation_y+(7*direction.y))][(int)(position.x+updation_x+(7*direction.x))]==1){
      position.y+=updation_y;
      position.x+=updation_x;
    }
    else if((int)(position.y+updation_y+(7*direction.y))<600 
     && (int)(position.x+updation_x+(7*direction.x)) < 800 
     &&(int)(position.y+updation_y+(7*direction.y))>=0
     && (int)(position.x+updation_x+(7*direction.x))>=0
     &&l[(int)(position.y+updation_y+(7*direction.y))][(int)(position.x+updation_x+(7*direction.x))]==0){
       if(l[(int)(position.y)][(int)(position.x+updation_x+(7*direction.x))]==0){
          position.x-=updation_x;
       }
       if(l[(int)(position.y+updation_y+(7*direction.x))][(int)(position.x)]==0){
          position.y-=updation_y;
       }
         
     }
    else{
      resolution=1;
    }
    if(detected==true){
      resolution=1;}
    if(resolution==1 || ((abs((int)position.x-(int)destination.x)<=5 && abs((int)position.y-(int)destination.y)<=5)
    || ((int)(position.y+updation_y+(7*direction.y))>=0 
    && (int)(position.x+updation_x+(7*direction.x))>=0 
    && (int)(position.y+updation_y+(7*direction.y))<600 
    && (int)(position.x+updation_x+(7*direction.x))<800
    && (l[(int)(position.y+updation_y+(7*direction.y))][(int)(position.x+updation_x+(7*direction.x))]==0)) )){
      if(resolution==1 && detected==true){
        origin=new PVector(position.x,position.y);
        destination=new PVector(position.x+(pursuer.x*100),position.y+(pursuer.y*100));
        
        set_values(1,1);
      }
      else{
      if(seek_flag==1){
        origin=position.copy();
        destination=temp_position.copy();
        set_values(1,1);
        seek_flag=2;
      }
    
      if(seek_flag==2){
        origin=new PVector(temp_origin.x, temp_origin.y);
        destination=new PVector(temp_destination.x,temp_destination.y);
        set_values(1,1);
        seek_flag=0;        
      }
      
      if(seek_flag==0){
        origin=new PVector(destination.x,destination.y);
        destination=new PVector((int)random(room.x1,room.x2),(int)random(room.y1,room.y2));
        set_values(1,1);
      }
    }}
    orient();
  }
  
  void orient(){
    if(abs(final_orientation-current_orientation)<=orientation_increment){
      //System.out.println("1");
      current_orientation=final_orientation;}
    
    if (final_orientation < current_orientation) {
      //System.out.println("2");
      if (current_orientation - final_orientation < PI) 
        current_orientation -= orientation_increment ;
      else 
        current_orientation += orientation_increment;
    }
    else {
      //System.out.println("3");
     if (final_orientation - current_orientation < PI) 
       current_orientation += orientation_increment ;
     else 
       current_orientation -= orientation_increment; 
    }
    
    
    if (current_orientation > PI) 
      current_orientation -= 2*PI ;
      
    else if (current_orientation < -PI) 
      current_orientation += 2*PI ; 
  }
  
  void draw_human(Player target, Robot[] r, Human[] h, Obstacle[] o){
    seek_target(target.position);
    for(int i=0;i<(int)random(6,9);i++){
      move(r,h,o);
    }
    int color_code;
    switch(type){
      case 0: color_code=255; break;
      case 1: color_code=100; break;
      case 2: color_code=0; break;
      default: color_code=255; 
    }
    noStroke();
    fill(200,color_code,100);
    ellipse(position.x,position.y,14,14);
    noStroke();
    fill(0);
    if(color_code<50){
      stroke(0);
      fill(255);
    }
    ellipse(position.x+(6* cos(current_orientation)),position.y+(6* sin(current_orientation)),3,3);
  }
  
  boolean check_death(int x,int y, int type){
    
    if(abs(x-position.x)<=14 && abs(y-position.y)<=14 && type!=0)
        isAlive=false;
      
      
      if(type==0 && abs((x+7)-position.x)<=14 && abs((y+7)-position.y)<=14)
        isAlive=false;
        
    return isAlive;
  }
  
    boolean target_in_sight(int x, int y){
     // System.out.println("Searching");
    int tempx=(int)position.x, tempy= (int)position.y;
    
    PVector tpath=new PVector(x-tempx,y-tempy);
    PVector tdirection;
    
    if(tpath.x!=0 && tpath.y!=0)
      tdirection=new PVector(tpath.x/abs(tpath.x),tpath.y/abs(tpath.y));
    else if(tpath.x==0 && tpath.y!=0)
      tdirection=new PVector(0,tpath.y/abs(tpath.y));
    else if(tpath.x!=0 && tpath.y==0)
      tdirection=new PVector(tpath.x/abs(tpath.x),0);
    else 
      tdirection=new PVector(0,0);
      
    float direction_percent_x= abs(tpath.x) / ( abs(tpath.x) + abs(tpath.y));
    float direction_percent_y= abs(tpath.y) / ( abs(tpath.x) + abs(tpath.y));
    float updation_x;
    
      updation_x= 8/(float)Math.sqrt(1+(Math.pow((direction_percent_y/direction_percent_x),2)));
      
    float updation_y;
    
      updation_y= 8/(float)Math.sqrt(1+(Math.pow((direction_percent_x/direction_percent_y),2)));
    
    updation_x*=tdirection.x;
    updation_y*=tdirection.y;
    
    while(tempx+updation_x<800 && tempy+updation_y<600 && tempx+updation_x>=0 && tempy+updation_y>=0
      && l[tempy+(int)(updation_y/8)][tempx+(int)(updation_x/8)]!=0
      && l[tempy+(int)(2*updation_y/8)][tempx+(int)(2*updation_x/8)]!=0
      && l[tempy+(int)(3*updation_y/8)][tempx+(int)(3*updation_x/8)]!=0
      && l[tempy+(int)(4*updation_y/8)][tempx+(int)(4*updation_x/8)]!=0
      && l[tempy+(int)(5*updation_y/8)][tempx+(int)(5*updation_x/8)]!=0
      && l[tempy+(int)(6*updation_y/8)][tempx+(int)(6*updation_x/8)]!=0
      && l[tempy+(int)(7*updation_y/8)][tempx+(int)(7*updation_x/8)]!=0
      && l[tempy+(int)(updation_y)][tempx+(int)(updation_x)]!=0){
        
      if(abs(tempx-x)<=5 && abs(tempy-y)<=5)
        return true;
      tempx+=updation_x;
      tempy+=updation_y; 
    }
    return false;
      
  }
  
  boolean resolute(Robot r1[], Human[] h1, Obstacle[] o, float x, float y){
    //System.out.println("HUMAN Resolute "+ r1.length);
    for(int i=0;i<r1.length;i++){
      
      //System.out.println("HUMAN Resolute n "+ i+ " TYPE: ");
      if(abs(x-r1[i].position.x)<=54 && abs(y-r1[i].position.y)<=54 &&r1[i].type!=0){
        detected=true;
        pursuer=new PVector(r1[i].direction.x,r1[i].direction.y);
        return true;}
        
      else if(abs(x-r1[i].position.x)<=24 && abs(y-r1[i].position.y)<=24 &&r1[i].type==0)
        return false;
      }
        
    for(int i=0;i<h1.length;i++)
      if(abs(x-h1[i].position.x)<=14 && abs(y-h1[i].position.y)<=14)
        return false;
        
    for(int i=0;i<o.length;i++)
      if(abs(x-(o[i].x+7))<=15 && abs(y-(o[i].y+7))<=15)
        return false;
    
    return true;
  }
  
  void seek_target(PVector target){
    if(target_in_sight((int)target.x,(int)target.y)){
      //System.out.println("Target found");
      if(seek_flag==0){
      temp_origin=origin.copy();
      temp_destination=destination.copy();
      temp_position=position.copy();}
      if(seek_counter==0){
        origin=position.copy();
        seek_counter++;
      }
      
      destination=new PVector(target.x,target.y);
      set_values(1,0);
      seek_flag=1;
    }
    
  }
}
