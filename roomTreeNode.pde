class roomTreeNode{
  int x1,x2,y1,y2;
  int depth;
  char label;
  roomTreeNode parent;
  roomTreeNode(int x1,int y1,int x2,int y2, roomTreeNode n, char label){
    this.x1=x1;
    this.x2=x2;
    this.y1=y1;
    this.y2=y2;
    parent=n;
    depth=parent.depth+1;
    this.label=label;
  }
  roomTreeNode(int x1,int y1,int x2,int y2, char label){
    this.x1=x1;
    this.x2=x2;
    this.y1=y1;
    this.y2=y2;
    depth=0;
    this.label=label;
  }
  int getArea(){
    return (abs(x1-x2))*(abs(y1-y2));
  }
  
}
