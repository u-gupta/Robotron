class Boss extends Robot{
  int current_HP,max_HP;
  int boss_counter;
  Boss(int originX, int originY, int destX, int destY, int[][] level, roomTreeNode room, int wave){
    super(5, originX, originY, destX, destY, level, room);
    System.out.println("Creating Boss");
    boss_counter=wave/5;
    make_boss();
  }
  
  
  void make_boss(){
    max_HP=25*boss_counter;
    current_HP=max_HP;
    velocity=2;
    
  }
  void hit_boss(){
    current_HP--;
    if(velocity<4)
      velocity+=((int)(max_HP/current_HP)==1?0:max_HP/current_HP);
    if(velocity>=4)
      velocity=4;
    System.out.println(current_HP+" "+velocity);
  }
  boolean check_death(int x,int y, boolean check){
    if(abs(x-position.x)<=7 && abs(y-position.y)<=7){
      hit_boss();
      if(current_HP<=0)
        isAlive=false;
      check=false;
    }
    return check;
  }
}
