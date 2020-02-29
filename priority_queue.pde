class priority_queue{
  steps[] s1;
  float[] priority;
  
  priority_queue(){
    s1=new steps[0];
    priority=new float[0];
  }
  
  void push(steps n,float p){
    steps temp[]=s1;
    float tempP[] = priority;
    s1=new steps[temp.length+1];
    priority=new float[s1.length];
    int i=0;
    
    while(p>priority[i] && i<temp.length){
      s1[i]=temp[i];
      priority[i]=tempP[i];
      i++;
    }
    
    s1[i]=n;
    priority[i]=p;
    
    while(i<temp.length){
      s1[i+1]=temp[i];
      priority[i+1]=tempP[i];
      i++;
    }
      
  }
  
  steps pop(){
    steps n=s1[0];
    steps temp[]=s1;
    float tempP[] = priority;
    s1=new steps[temp.length-1];
    priority=new float[s1.length];
    
    for(int i=0;i<s1.length;i++){
      s1[i]=temp[i+1];
      priority[i]=tempP[i+1];
    }
    
    return n;
    
  }
}
