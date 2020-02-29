class AStar{
  
  int originX, originY, destX, destY;
  int[][] l;
  priority_queue frontier;
  steps[] explored;
  steps current;
  search_points points;
  
  AStar(PVector origin, PVector destination, int[][] level, search_points points){
    //System.out.println("1 "+points.pointsx.length);
    originX=(int)origin.x;
    originY=(int)origin.y;
    destX=(int)destination.x;
    destY=(int)destination.y;
    
    l=level;
    
    frontier=new priority_queue();
    explored=new steps[1];
    explored[0]=new steps(new PVector(originX,originY));
    current=new steps(new PVector(originX,originY));
    points.add_origin_destination((int)destination.x,(int)destination.y);
    //System.out.println(points.pointsx.length);
    this.points=new search_points(points);
    points=null;
    update_frontier();
  }
  
  float calculate_priority(steps n){
    return n.cost+(abs(n.x-destX))+(abs(n.y-destY));
  }
  
  boolean isValidAction(steps n){
    
    Robot r=new Robot();
    r.position=new PVector(current.x,current.y);
    r.l=l;
    for(int i=0;i<explored.length;i++)
      if(n.x==explored[i].x && n.y==explored[i].y)
        return false;
        
    for(int i=0;i<frontier.s1.length;i++)
      if(n.x==frontier.s1[i].x && n.y==frontier.s1[i].y)
        return false;
        
    
    if( r.target_in_sight((int)n.x,(int)n.y))
      return true;
    
    return false;
  }
  
  void update_frontier(){
    //System.out.println(points.pointsx.length);
    for(int i=0;i<points.pointsx.length;i++){
      if(isValidAction(new steps(new PVector(points.pointsx[i],points.pointsy[i]))))
        frontier.push(new steps(new PVector(points.pointsx[i],points.pointsy[i]),current),calculate_priority(new steps(new PVector(points.pointsx[i],points.pointsy[i]))));
    
    }
  }
  
  void make_move(){
    steps new_step=frontier.pop();
    steps temp[]=explored;
    explored=new steps[temp.length+1];
    for(int i=0;i<temp.length;i++)
      explored[i]=temp[i];
    explored[explored.length-1]=new_step;
    current=new_step;
    update_frontier();
  }
  
  PVector perform_search(){
    while(current.x !=destX && current.y!= destY && frontier.s1.length!=0){
      make_move();
    }
    
    
    while(current.parent!=null && current.parent.parent!=null){
      //fill(0);
      //ellipse(current.x,current.y,3,3);
      //line(current.x,current.y,current.parent.x,current.parent.y);
      current=current.parent;
    }
    return new PVector(current.x,current.y);
  }
  
}
