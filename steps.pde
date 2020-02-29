class steps{
  int x;
  int y;
  steps parent;
  int cost;
  steps(PVector step,steps parent){
    x=(int)step.x;
    y=(int)step.y;
    
    this.parent=parent;
    cost=parent.cost+1;
  }
  steps(PVector step){
    x=(int)step.x;
    y=(int)step.y;
    parent=null;
    cost=0;
  }
}
