class search_points{
  
  int pointsx[], pointsy[];
  
  search_points(){
    pointsx=new int[0];
    pointsy=new int[0];
  }
  
  search_points(search_points s){
    pointsx=new int[s.pointsx.length];
    pointsy=new int[s.pointsy.length];
    
    for(int i=0;i<s.pointsx.length;i++){
      pointsx[i]=s.pointsx[i];
      pointsy[i]=s.pointsy[i];
      
    }
  }
  
  void add_room_points(roomTreeNode section, roomTreeNode room){
    int[]tempx=new int[6];
    int[]tempy=new int[6];
    int xt=(section.x1+section.x2)/2;
    int yt=(section.y1+section.y2)/2;
    
//    tempx[0]=room.x1+8;
//    tempy[0]=room.y1+8;
    
//    tempx[1]=room.x2-8;
//    tempy[1]=room.y2-8;
    
//    tempx[2]=room.x1+8;
//    tempy[2]=room.y2-8;
    
//  tempx[3]=room.x2-8;
//    tempy[3]=room.y1+8;
    
    tempx[0]=xt;
    tempy[0]=yt;
    
    tempx[1]=room.x1+8;
    tempy[1]=yt;
    
    tempx[2]=room.x2-8;
    tempy[2]=yt;
    
    tempx[3]=xt;
    tempy[3]=room.y2-8;
    
    tempx[4]=xt;
    tempy[4]=room.y1+8;
    
    tempx[5]=(room.x1+room.x2)/2;
    tempy[5]=(room.y1+room.y2)/2;
    
    int px[]=pointsx;
    pointsx=new int[px.length+6];
    int py[]=pointsy;
    pointsy=new int[py.length+6];
    
    for(int i=0;i<px.length;i++){
      pointsx[i]=px[i];
      pointsy[i]=py[i];
    }
    
    for(int i=px.length;i<pointsx.length;i++){
      pointsx[i]=tempx[i-px.length];
      pointsy[i]=tempy[i-py.length];
    }
    
  }
  
  void add_path_point(int x,int y){
    
    int px[]=pointsx;
    pointsx=new int[px.length+1];
    int py[]=pointsy;
    pointsy=new int[py.length+1];
    
    for(int i=0;i<px.length;i++){
      pointsx[i]=px[i];
      pointsy[i]=py[i];
    }
    
    pointsx[px.length]=x;
    pointsy[py.length]=y;
  }
  void add_origin_destination(int destx, int desty){
    
    int px[]=pointsx;
    pointsx=new int[px.length+1];
    int py[]=pointsy;
    pointsy=new int[py.length+1];
    
    for(int i=0;i<px.length;i++){
      pointsx[i]=px[i];
      pointsy[i]=py[i];
    }
    
    pointsx[px.length]=destx;
    pointsy[py.length]=desty;
  }
  
  
}
