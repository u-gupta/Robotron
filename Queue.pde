class Queue{
  
  roomTreeNode[] frontier;
  
  Queue(){
    frontier=new roomTreeNode[0];
  }
  
  roomTreeNode pop(){
    roomTreeNode n=frontier[0];
    roomTreeNode temp[]=frontier;
    frontier=new roomTreeNode[temp.length-1];
    for(int i=0;i<frontier.length;i++)
      frontier[i]=temp[i+1];    
    return n;
  }
  
  void push(roomTreeNode n){
    roomTreeNode temp[]=frontier;
    frontier=new roomTreeNode[temp.length+1];
    for(int i=0;i<temp.length;i++)
      frontier[i]=temp[i];
    frontier[temp.length]=n;
  }
  void trash(int a){
    roomTreeNode temp[]=frontier;
    frontier=new roomTreeNode[temp.length-1];
    for(int i=0;i<a;i++)
      frontier[i]=temp[i];
    for(int i=a;i<frontier.length;i++)
      frontier[i]=temp[i+1];
  }
  Queue extract(){
    Queue temp=new Queue();
    int max_depth=frontier[0].depth;
    for(int i=0;i<frontier.length;i++)
      if(frontier[i].depth>max_depth)
        max_depth=frontier[i].depth;
    for(int i=0;i<frontier.length;i++)
      if(frontier[i].depth==max_depth){
        temp.push(frontier[i]);
        roomTreeNode t1[]=frontier;
        frontier=new roomTreeNode[t1.length-1];
        int a=0;
        while(a<i)
          frontier[a]=t1[a++];
        for(int b=a;b<frontier.length;b++)
          frontier[b]=t1[b+1];
      }
    return temp;
  }
  int getMaxArea(){
    int max_area=frontier[0].getArea();
    for(int i=0;i<frontier.length;i++)
      if(max_area<frontier[i].getArea())
        max_area=frontier[i].getArea();
    return max_area;
  }
}
