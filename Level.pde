import ddf.minim.*;


class Level{
  
  int DPI;
  int wave;
  Queue tree;
  int level[][];
  roomTreeNode[] rooms;
  Robot r1[];
  Robot r2[];
  Robot r3[];
  Robot r4[];
  Human h[];
  Obstacle o[];
  search_points s1[];
  search_points s;
  search_points s2;
  Player p1;
  PowerUps[] power;
  Boss B;
  int score;
  AudioPlayer robot_death;
  AudioPlayer freeze;
  AudioPlayer bomb;
  AudioPlayer dying_man;
  AudioPlayer robot_convert;
  AudioPlayer invulnerability;
  Level(int wave, int score, AudioPlayer sound2, AudioPlayer sound4, AudioPlayer sound5, AudioPlayer sound6, AudioPlayer sound7, AudioPlayer sound8){
    
    level=new int[600][800];
    for(int i=0;i<level.length;i++)
      for(int j=0;j<level[i].length;j++)
        level[i][j]=0;
        
    this.wave=wave;
    this.score=score;
    
    robot_death=sound2;
    freeze=sound4;
    bomb=sound5;
    dying_man=sound6;
    robot_convert=sound7;
    invulnerability=sound8;
    
    tree=new Queue();
    
    r1=new Robot[(3+wave)<=40? (3+wave): 40];
    
    r2=new Robot[(3+wave)<=40? (3+wave): 40];
    
    r3=new Robot[(1 + (wave/5))<=15? 1 + (wave/5):15];
    
    r4=new Robot[0];
    power=new PowerUps[3];
    s1=new search_points[r4.length];
    s=new search_points();
  }
  
  void create_tree(){
    //System.out.println("Creating Tree");
    int max_pixel=(int)((double)240000/(double)((wave+5)/5));
    if(max_pixel<50000)
      max_pixel=50000;
    char label='a';
    tree.push(new roomTreeNode(0,0,800,600,label++));
    while(tree.getMaxArea()>max_pixel){
      //System.out.println("Tree loop enter "+tree.getMaxArea()+" MAX "+max_pixel);
      if(tree.frontier[0].getArea()>max_pixel){
        int hvflag=(int)random(8);
        roomTreeNode temp=tree.pop();
        switch(hvflag){
          case 0: 
          case 2:
          case 4:
          case 6:{
            int tempy=(int)random(((temp.y1+temp.y2)/2)-1,((temp.y1+temp.y2)/2)+1);
            roomTreeNode n1,n2;
            n1=new roomTreeNode(temp.x1,temp.y1,temp.x2,tempy,temp,label++);
            n2=new roomTreeNode(temp.x1,tempy,temp.x2,temp.y2,temp,label++);
            tree.push(n1);
            tree.push(n2);
          } break;
          case 1: 
          case 3:
          case 5:
          case 7:{
            int tempx=(int)random(((temp.x1+temp.x2)/2)-1,((temp.x1+temp.x2)/2)+1);
            roomTreeNode n1,n2;
            n1=new roomTreeNode(temp.x1,temp.y1,tempx,temp.y2,temp,label++);
            n2=new roomTreeNode(tempx,temp.y1,temp.x2,temp.y2,temp,label++);
            tree.push(n1);
            tree.push(n2);          
          } break;
          
        }
        
      } else {
        tree.push(tree.pop());
      }
      }
      for(int i=0;i<tree.frontier.length;i++){
        for(int j=i;j<tree.frontier.length;j++)
          if(tree.frontier[i].parent==tree.frontier[j]){
//            System.out.println("Trashing"+tree.frontier[j]);
            tree.trash(j);
          }
            
    }
    
//    print_tree(tree);
        
  }
  /*
  void print_tree(Queue t){
     for(int i=0;i<t.frontier.length;i++){
       System.out.print(t.frontier[i].label+" ");
       if(i+1<t.frontier.length && t.frontier[i].parent==t.frontier[i+1].parent)
         System.out.print("- ");
     }
     System.out.println();
     Queue temp=new Queue();
     temp.push(t.frontier[0].parent);
     for(int i=0;i<t.frontier.length;i++){
       boolean flag=false;
       for(int j=0;j<temp.frontier.length;j++)
         if(t.frontier[i].parent==temp.frontier[j])
           flag=true;
       if(flag==false)
         temp.push(t.frontier[i].parent);
     }
     for(int i=0;i<temp.frontier.length;i++){
       roomTreeNode printer=temp.pop();
       System.out.print(printer.label+" ");
       if(i+1<temp.frontier.length && printer.parent==temp.frontier[0].parent)
         System.out.print("- ");
     }
       
  }
  */
  
  void generate_rooms(){
//    System.out.println("Generating Rooms");
    int len=tree.frontier.length;
    
    rooms=new roomTreeNode[len];
    o=new Obstacle[(len*(2*((wave+5)/5)))<=70? (len*(2*((wave+5)/5))) : 70];
    h=new Human[len*2];
//  System.out.println("Number of Rooms: "+len);
    for(int i=0;i<len;i++){
      roomTreeNode room=tree.pop();
      boolean check=false;
      for(int j=0;j<tree.frontier.length;j++)
        if(tree.frontier[j]==room.parent)
          check=true;
      if(check==false)
        tree.push(room.parent);
      
      int x1,x2,y1,y2;
      x1=(int)random(room.x1,(room.x1+room.x2)/4);
      x2=(int)random((0.5*(room.x1+room.x2))+8,room.x2);
      if(x2>=800)
        x2=799;
      y1=(int)random(room.y1,(room.y1+room.y2)/4);
      y2=(int)random((0.5*(room.y1+room.y2))+8,room.y2);
      if(y2>=600)
        y2=599;
//      System.out.print("\nRoom Label: "+room.label+ " Room Parent: "+room.parent.label);
      for(int a=y1;a<y2 && a<600 ;a++)
        for(int b=x1;b<x2 && b<800;b++){
            level[a][b]=1;
        }
      
      rooms[i]=new roomTreeNode(x1,y1,x2,y2,room.label);
      s.add_room_points(room,rooms[i]);
      
      if(room.parent!=null && room.parent==tree.frontier[0].parent)
        generate_path(room,tree.frontier[0]);
      else
        generate_path(room,room.parent);
    }
//    System.out.println("\n"+tree.frontier.length);
  }
  
  void generate_path(roomTreeNode n1,roomTreeNode n2){
    
    int center_n_x=(n1.x1+n1.x2)/2;
    int center_n_y=(n1.y1+n1.y2)/2;
    int center_parent_x=(n2.x1+n2.x2)/2;
    int center_parent_y=(n2.y1+n2.y2)/2;
    int originX=Math.min(center_n_x,center_parent_x);
    int originY=Math.min(center_n_y,center_parent_y);
    int destX=Math.max(center_n_x,center_parent_x);
    int destY=Math.max(center_n_y,center_parent_y);
    int i;
    if(originX==destX) { 
      s.add_path_point(destX,destY-7);
      s.add_path_point(destX,originY);
        
    }
    
    else if(originY==destY)  {
      s.add_path_point(destX-7,destY); 
      s.add_path_point(originX,destY);
    }   
    
    else  {
      s.add_path_point(destX-7,destY-7);
      s.add_path_point(originX,originY);
    }
    
    for(i=originX;i<=destX && i<800;i++)
      for(int j=0;j<=32 && originY-(16-j)>=0;j++)
          level[originY-(16-j)][i]=1;
          
    for(i=originY;i<=destY && i<600;i++)
      for(int j=0;j<=32 && originX-(16-j)>=0;j++)
         level[i][originX-(16-j)]=1;
         
  }
  
  
  void add_player(){
  
    char label=l.rooms[0].label;
    int room_index=0;
    for(int i=0;i<l.rooms.length;i++){
      if(l.rooms[i].label<label){
        label=l.rooms[i].label;
        room_index=i;
      }
    }
    int posx=(l.rooms[room_index].x1+l.rooms[room_index].x2)/2;
    int posy=(l.rooms[room_index].y1+l.rooms[room_index].y2)/2;
    float orientation=atan2(mouseY-posy, mouseX-posx);
    p1=new Player(posx,posy,orientation,l.level);
  }
  
  void generate_obstacles(){
    //System.out.println("Generating obstacles" + o.length);
    int a=0;
    for(int i=0;i<o.length;i++){
      Obstacle[] temp=new Obstacle[i];
      for(int j=0;j<i;j++)
        temp[j]=o[j];
      o[i]=new Obstacle(rooms[a++],level,temp,p1);
      if(a>=rooms.length)
        a=0;
    }
  }
  
  void draw_obstacles(Bullet[] b1){
    
    for(int i=0;i<o.length;i++){
      for(int j=0;j<b1.length;j++)
    
        if(o[i].check_death((int)b1[j].position.x,(int)b1[j].position.y)==false){
          b1[j].isAlive=false;
          break;
        }
    }
    remove_obstacles();
    
    for(int i=0;i<o.length;i++)
      o[i].draw_obstacle();
  }
  
  void remove_obstacles(){
    
    for(int i=0;i<o.length;i++){
        //System.out.println("Deleting Obstacle 1 " + i);
      if(o[i].isAlive==false){
        //System.out.println("Deleting Obstacle 2 " + i + "Length: "+o.length);
        Obstacle[] temp=o;
        o=new Obstacle[temp.length-1];
        for(int j=0;j<i;j++)
          o[j]=temp[j];
        for(int j=i;j<o.length;j++)
          o[j]=temp[j+1];
        i--;
      }
    }
  }
  void generate_powerups(){
    power[0]=new PowerUps(rooms[(int)random(rooms.length)], o, p1, 'F', new PowerUps[0],freeze,bomb,invulnerability);
    PowerUps temp[]={power[0]};
    power[1]=new PowerUps(rooms[(int)random(rooms.length)],o, p1, 'B', temp,freeze,bomb,invulnerability);
    temp=new PowerUps[2];
    temp[0]=power[0];
    temp[1]=power[1];
    power[2]=new PowerUps(rooms[(int)random(rooms.length)],o, p1, 'I', temp,freeze,bomb,invulnerability);  
  }
  void draw_powerups(){
    for(int i=0;i<power.length;i++){
      power[i].draw_powerup();
      power[i].check_activation(p1,o,r1,r2,r3,r4,B);
    }
    remove_powerups();
  }
  
  void remove_powerups(){
    
    for(int i=0;i<power.length;i++){
        //System.out.println("Deleting Obstacle 1 " + i);
      if(power[i].isAlive==false){
        //System.out.println("Deleting Obstacle 2 " + i + "Length: "+o.length);
        PowerUps[] temp=power;
        power=new PowerUps[temp.length-1];
        for(int j=0;j<i;j++)
          power[j]=temp[j];
        for(int j=i;j<power.length;j++)
          power[j]=temp[j+1];
        i--;
      }
    }
    
  }
  int[][] generate_level(){
//    System.out.println("Generating Level");
    create_tree();
    generate_rooms();
    if(tree.frontier[0].parent==null)
      tree.push(tree.pop());
    while(tree.frontier[0].parent!=null){
      roomTreeNode room=tree.pop();
      boolean check=false;
      for(int j=0;j<tree.frontier.length;j++)
        if(tree.frontier[j]==room.parent)
          check=true;
      if(check==false)
        tree.push(room.parent);
  
//      System.out.println("Generating path from level, Room Parent Label: "+ room.label+ " Next Room Label: "+tree.frontier[0].label);
      if(room.parent==tree.frontier[0].parent || room.parent==tree.frontier[0])
        generate_path(room,tree.frontier[0]);
      else
        generate_path(room,room.parent);
      
      if(tree.frontier[0].parent==null)
        tree.push(tree.pop());
    }
    add_player();
    
    generate_obstacles();
    
    generate_powerups();
    
    generate_robots();
    
    generate_humans();
    
    //System.out.println("Creating Boss? "+(wave+1)%5);
    if((wave+1)%5==0)
      generate_boss();
      
    return level;
  }
  
  void generate_boss(){
    char label=rooms[0].label;
    int index=0;
    for(int i=0;i<rooms.length;i++)
      if(label>rooms[i].label){
        label=rooms[i].label;
        index=i;
      }
    index = (0==index?1:0);
    int size=(rooms[index].x2-rooms[index].x1) * (rooms[index].y2-rooms[index].y1);
    for(int i=0;i<rooms.length;i++){
      if(((rooms[i].x2-rooms[i].x1) * (rooms[i].y2-rooms[i].y1))>size && rooms[i].label!=label){
        index=i;
        size=(rooms[i].x2-rooms[i].x1) * (rooms[i].y2-rooms[i].y1);
      }
    }
    int originx=(rooms[index].x1+rooms[index].x2)/2;
    int originy=(rooms[index].y1+rooms[index].y2)/2;
    
    B=new Boss(originx,originy,(int)p1.position.x,(int)p1.position.y,level,rooms[index],wave+1);
  }
  
  void draw_boss(Bullet[] b1, Player p){
    if(B!=null){
      //System.out.println("Drawing Boss");
      
      for(int j=0;j<b1.length;j++)
    
        if(B.check_death((int)b1[j].position.x,(int)b1[j].position.y,true)==false){
          b1[j].isAlive=false;
          break;
        }
        
      if(remove_boss())
        return;
      
      s2=new search_points(s);
        
      B.draw_robot(p,s2);
        
    }
    
  }
  boolean remove_boss(){
    if(B.isAlive==false){
      score+=50;
      B=null;
      return true;  
    }
    return false;
  }
  void generate_humans(){
    
      int j=0;
    for(int i=0;i<h.length;i++){
      //System.out.println("1:"+i);
      if(j==rooms.length)
        j=0;
      int k=0;
      Human[] temp= new Human[i];
      int originX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
      int destX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
      int originY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      int destY=(int)random(rooms[j].y1+16,rooms[j].y2-16);
      
      for(k=0;k<i;k++)
        temp[k]=h[k];
        
      Robot[] tempR=new Robot[r1.length+r2.length+r3.length];
      for(int a=0;a<tempR.length;a++){
        if(a<r1.length)
          tempR[a]=r1[a];
        else if(a<r1.length+r2.length)
          tempR[a]=r2[a-r1.length];
        else if(a<r1.length+r2.length+r3.length)
          tempR[a]=r2[a-(r1.length+r2.length)];
      }
        //System.out.println("Checking: "+tempR[3].type);
      while(new Human().resolute(tempR,temp,o,originX,originY)==false){
        originX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
        originY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      }
          
        
      h[i]=new Human((int)random(0,3), originX, originY, destX, destY, level, rooms[j++]);
    }
  }
  
  void draw_humans(Player p){
      
    Robot[] tempR=new Robot[r1.length+r2.length+r3.length];
    for(int a=0;a<tempR.length;a++){
      if(a<r1.length)
        tempR[a]=r1[a];
      else if(a<r1.length+r2.length)
        tempR[a]=r2[a-r1.length];
      else if(a<r1.length+r2.length+r3.length)
        tempR[a]=r3[a-(r1.length+r2.length)];
    }
      
    for(int i=0;i<h.length;i++){
      for(int j=0;j<tempR.length;j++){
        
        if(h[i].isAlive==true && h[i].check_death((int)tempR[j].position.x,(int)tempR[j].position.y, tempR[j].type)==false)
          if(tempR[j].type == 3){
            robot_convert.rewind();
            robot_convert.play(6000);
            
            Robot tempR4[]=r4;
            r4=new Robot[tempR4.length+1];
            for(int a=0;a<tempR4.length;a++)
              r4[a]=tempR4[a];
              
            r4[tempR4.length]=new Robot(4,(int)h[i].position.x,(int)h[i].position.y,(int)p.position.x,(int)p.position.y,level,h[i].room);
            break;
          
          } else {
            dying_man.rewind();
            dying_man.play();
          }
            
    
      }
      
      if(h[i].isAlive)
        for(int j=0;j<o.length;j++)
          h[i].check_death((int)o[j].x,(int)o[j].y, 0) ;
        
        if(h[i].isAlive)
          if(h[i].check_death((int)p.position.x,(int)p.position.y, 4)==false){
            score+=((h[i].type+1)*10);
          }
          
        //System.out.println("Number of humans left:"+h.length);
        remove_humans();
        
        //System.out.println("Number of humans left:"+h.length);
    }
    
    
    for(int i=0;i<h.length;i++){
        
      
     Human[] pass=new Human[h.length-1];
     //System.out.println("Checking: "+pass.length+ "-" +h.length);
     for(int j=0;j<i;j++){
       //System.out.println("Checking: "+j+ "-" +i);
       
       pass[j]=h[j];}
     for(int j=i;j<pass.length;j++)
       pass[j]=h[j+1];
     
     if(h.length-i>0)
       h[i].draw_human(p,tempR,pass,o);
    }
  }
  
  void remove_humans(){
    
    for(int i=0;i<h.length;i++){
      if(h[i].isAlive==false){
        Human[] temp=h;
        h=new Human[temp.length-1];
        for(int j=0;j<i;j++)
          h[j]=temp[j];
        for(int j=i;j<h.length;j++)
          h[j]=temp[j+1];
        i--;
      }
    }
    
  }
  void draw_smart_robots(Bullet[] b1, Player p){
    for(int i=0;i<r4.length;i++){
      for(int j=0;j<b1.length;j++)
    
        if(r4[i].check_death((int)b1[j].position.x,(int)b1[j].position.y)==false){
          b1[j].isAlive=false;
          break;
        }
    }
    remove_robots();
    s1=new search_points[r4.length];
    for(int i=0;i<s1.length;i++)
      s1[i]=new search_points(s);
      
    for(int i=0;i<r4.length;i++){
      r4[i].draw_robot(p,s1[i]);
    }
  }
  void generate_robots(){
    char label=rooms[0].label;
    int index=0;
    for(int i=0;i<rooms.length;i++)
      if(label>rooms[i].label){
        label=rooms[i].label;
        index=i;
      }
    
    for(int i=0;i<r1.length;i++){
      //System.out.println("1:"+i);
      int j=(int)random(rooms.length);
      if(j==index)
        while(j==index)
          j=(int)random(rooms.length);
      int k=0;
      Robot[] temp= new Robot[i];
      int originX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
      int destX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
      int originY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      int destY=(int)random(rooms[j].y1+16,rooms[j].y2-16);
      
      for(k=0;k<i;k++)
        temp[k]=r1[k];
      
      while(new Robot().resolute(temp,originX,originY,o)==false){
        originX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
        originY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      }
          
        
      r1[i]=new Robot(1, originX, originY, destX, destY, level, rooms[j]);
    }
    for(int i=0;i<r2.length;i++){
      //System.out.println("2:"+i);
      
      int j=(int)random(rooms.length);
      if(j==index)
        while(j==index)
          j=(int)random(rooms.length);
      int originX= (int)random(rooms[j].x1+16, rooms[j].x2-16);
      int destX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
      int originY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      int destY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      
      int k=0;
      Robot[] temp= new Robot[r1.length+i];
      for(k=0;k<r1.length;k++)
        temp[k]=r1[k];
      
      //System.out.println("K:"+k+ " "+ r2.length+ " "+ temp.length);
      for(;k<r1.length+i;k++)
        temp[k]=r2[k-r1.length];
      while(new Robot().resolute(temp,originX,originY,o)==false){
        originX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
        originY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      }
      
      r2[i]=new Robot(2, originX, originY, destX, destY, level,rooms[j]);
    }
    
    for(int i=0;i<r3.length;i++){
      //System.out.println("3:"+i);
      
      int j=(int)random(rooms.length);
      if(j==index)
        while(j==index)
          j=(int)random(rooms.length);
      int originX= (int)random(rooms[j].x1+16, rooms[j].x2-16);
      int destX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
      int originY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      int destY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      
      int k=0;
      Robot[] temp= new Robot[r1.length+r2.length+i];
      for(k=0;k<r1.length;k++)
        temp[k]=r1[k];
        
      for(;k<r1.length+r2.length;k++)
        temp[k]=r2[k-r1.length];
        
      for(;k<r1.length+r2.length+i;k++)
        temp[k]=r3[k-(r1.length+r2.length)];
        
      
      while(new Robot().resolute(temp,originX,originY,o)==false){
        originX= (int)random(rooms[j].x1+16,rooms[j].x2-16);
        originY= (int)random(rooms[j].y1+16,rooms[j].y2-16);
      }
      
      r3[i]=new Robot(3, originX, originY, destX, destY, level,rooms[j]);
    }
  }
  
  void draw_robots(Bullet b1[],Player p){
    
    for(int i=0;i<r2.length;i++){
      for(int j=0;j<b1.length;j++)
    
        if(r2[i].check_death((int)b1[j].position.x,(int)b1[j].position.y)==false){
          b1[j].isAlive=false;
          break;
        }
    }
    for(int i=0;i<r1.length;i++){
      for(int j=0;j<b1.length;j++)
      
        if(r1[i].check_death((int)b1[j].position.x,(int)b1[j].position.y)==false){
          b1[j].isAlive=false;
          break;
        }
  
    }
    for(int i=0;i<r3.length;i++){
      for(int j=0;j<b1.length;j++)
      
        if(r3[i].check_death((int)b1[j].position.x,(int)b1[j].position.y)==false){
          b1[j].isAlive=false;
          break;
        }
  
    }
    
    remove_robots();
    
    for(int i=0;i<r1.length+r2.length+r3.length;i++){
      Robot[] temp;
        temp=new Robot[r1.length+r2.length+r3.length];
        
      for(int j=0;j<r1.length;j++)
        temp[j]=r1[j];
      for(int j=0;j<r2.length;j++)
        temp[j+r1.length]=r2[j];
      for(int j=0;j<r3.length;j++)
        temp[j+r1.length+r2.length]=r3[j];
        
      
     Robot[] pass=new Robot[temp.length-1];
     for(int j=0;j<i;j++)
       pass[j]=temp[j];
     for(int j=i;j<pass.length;j++)
       pass[j]=temp[j+1];
     
     if(r1.length-i>0)
       r1[i].draw_robot(p,pass,h,o);
     else if(r1.length+r2.length-i>0)
       r2[i-r1.length].draw_robot(p,pass,h,o);
     else if(r1.length+r2.length+r3.length-i>0)
       r3[i-(r1.length+r2.length)].draw_robot(p,pass,h,o);
    }
  }
  
  void remove_robots(){
    for(int i=0;i<r1.length;i++){
      if(r1[i].isAlive==false){
        robot_death.rewind();
        robot_death.play();
        score+=3;
        Robot[] temp=r1;
        r1=new Robot[temp.length-1];
        for(int j=0;j<i;j++)
          r1[j]=temp[j];
        for(int j=i;j<r1.length;j++)
          r1[j]=temp[j+1];
        i--;
      }
    }
    
    for(int i=0;i<r2.length;i++){
      if(r2[i].isAlive==false){
        robot_death.rewind();
        robot_death.play();
        score+=1;
        Robot[] temp=r2;
        r2=new Robot[temp.length-1];
        for(int j=0;j<i;j++)
          r2[j]=temp[j];
        for(int j=i;j<r2.length;j++)
          r2[j]=temp[j+1];
        i--;
      }
    }
    
    for(int i=0;i<r3.length;i++){
      if(r3[i].isAlive==false){
        robot_death.rewind();
        robot_death.play();
        score+=1;
        Robot[] temp=r3;
        r3=new Robot[temp.length-1];
        for(int j=0;j<i;j++)
          r3[j]=temp[j];
        for(int j=i;j<r3.length;j++)
          r3[j]=temp[j+1];
        i--;
      }
    }
    for(int i=0;i<r4.length;i++){
      if(r4[i].isAlive==false){
        robot_death.rewind();
        robot_death.play();
        score+=10;
        Robot[] temp=r4;
        r4=new Robot[temp.length-1];
        for(int j=0;j<i;j++)
          r4[j]=temp[j];
        for(int j=i;j<r4.length;j++)
          r4[j]=temp[j+1];
        i--;
      }
    }
    
  
  }
  boolean check_kill(int x, int y){
    
    for(int i=0;i<r1.length;i++)
      if(abs(r1[i].position.x-x)<=12 && abs(r1[i].position.y-y)<=12 ){
        r1[i].isAlive=false;
        return true;
      }
        
    for(int i=0;i<r2.length;i++)
      if(abs(r2[i].position.x-x)<=12 && abs(r2[i].position.y-y)<=12 ){
        r2[i].isAlive=false;
        return true;
      }
        
    for(int i=0;i<r3.length;i++)
      if(abs(r3[i].position.x-x)<=12 && abs(r3[i].position.y-y)<=12 ){
        r3[i].isAlive=false;
        return true;
      }
    
    for(int i=0;i<r4.length;i++)
      if(abs(r4[i].position.x-x)<=12 && abs(r4[i].position.y-y)<=12 ){
        r4[i].isAlive=false;
        return true;
      }
    
    for(int i=0;i<o.length;i++)
      if(abs((o[i].x+7)-x)<=13 && abs((o[i].y+7)-y)<=13 ){
        o[i].isAlive=false;
        return true;
      }
    
    if(B!=null && abs(B.position.x-x)<=12 && abs(B.position.y-y)<=12 ){
      B.current_HP-=5;
      if(B.current_HP<=0){
        B.isAlive=false;
        remove_robots();}
      return true;
    }
    return false;
  }
  
  void draw_level(int[][] l){
//    System.out.println("generated"+level[400][300]);
    for(int i=0;i<l.length;i++)
      for(int j=0;j<l[i].length;j++){
        if(level[i][j]==0){
          noStroke();
          fill(30);
          rect(j,i,1,1);
        }
        
      }
      //System.out.println(count);
  }
  
  
  int check_wave_condition(){
    if(r1.length==0 && r2.length==0 && r3.length==0 && r4.length==0 && B==null)
      return 1;
      
    if(p1.isAlive==false)
      return 0;
      
    return 2;
  }
  int get_score(){
    return score;
  }
}
