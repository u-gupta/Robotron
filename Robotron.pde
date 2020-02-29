import ddf.minim.*;


int wave_counter;
Level l;
boolean flag;
int[][] MAP;
int check_shot;
int score, life_score, lives_added;
Minim minim;

AudioPlayer sound1;
AudioPlayer sound2;
AudioPlayer sound3;
AudioPlayer sound4;
AudioPlayer sound5;
AudioPlayer sound6;
AudioPlayer sound7;
AudioPlayer sound8;

int lives;
boolean start;
boolean welcome;

void setup(){
  
  background(130);
  size(800,620);
  welcome=true;
  minim=new Minim(this);
  sound1=minim.loadFile("rock-background-music-no-copyright.mp3");
  sound2=minim.loadFile("Robot_Death.mp3");
  sound3=minim.loadFile("click.mp3");
  sound4=minim.loadFile("Freeze.mp3");
  sound5=minim.loadFile("Bomb.mp3");
  sound6=minim.loadFile("dying_man.mp3");
  sound7=minim.loadFile("robot_convert.mp3");
  sound8=minim.loadFile("invulnerability.mp3");
  
  sound1.loop();
  start_game();
  //System.out.println(sound1.getGain());
}
void start_game(){
  sound1.setGain(-13);
  lives=3;
  flag=true;
  wave_counter=0;
  check_shot=0;
  score=0;
  lives_added=0;
  start=false;
}
void draw(){
  
  if(welcome==true){
    background(152);
    textSize(43);
    textAlign(CENTER);
    fill(32);
    text("ROBOTRON",width/2,(height/2)-10);
    textSize(12);
    text("Press Spacebar to Continue!",width/2,(height/2)+10);
    
    if(keyPressed==true && key== ' ')
      welcome=false;
  }
  else{
    sound1.setGain(-25);
    if(flag){
      start_wave();
      start=true;
      flag=false;
    }
    textAlign(LEFT);
    l.p1.lives=lives;
    score=l.get_score();
    life_score=score%500;
    if(l.check_kill((int)l.p1.position.x,(int)l.p1.position.y)){
      lives=l.p1.reduce_life();
    }
    if(l.check_wave_condition()==2){
      background(130);
      text("Lives Left: "+l.p1.lives,0,0);
      l.draw_level(MAP);
      l.p1.draw_player();
      fill(0);
      if(life_score>=0 && (int)(score/500) > lives_added){
        lives_added++;
        lives++;
        l.p1.lives++;
      }
      
      text("Lives Left: "+l.p1.lives,0,615);
      text("Wave: "+wave_counter,375,615);
      text("Score: "+score,730,615);
      l.draw_obstacles(l.p1.bullets);
      l.draw_powerups();
      l.draw_humans(l.p1);
      l.draw_robots(l.p1.bullets,l.p1);
      l.draw_smart_robots(l.p1.bullets,l.p1);
      l.draw_boss(l.p1.bullets,l.p1);
    
      if(check_shot==1){
        l.p1.shoot(new PVector(mouseX,mouseY)); 
        check_shot=0;
      }
    }
    if(l.check_wave_condition()==0){
      background(152,0,0);
      fill(32);
      textAlign(CENTER);
      textSize(23);
      text("You Lose!",width/2,(height/2)-45);
      text("Wave:"+wave_counter,width/2,height/2-20);
      text("Score:"+score,width/2,height/2+5);
      textSize(12);
      text("Press Spacebar to Try Again.",width/2, (height/2)+30);
      if(keyPressed==true && key==' '){
        start_game();
      }
    }
  
    if(l.check_wave_condition()==1){
      score+=50;
      start_wave();
    }
  }
}

void start_wave(){
  l=new Level(wave_counter++,score,sound2,sound4,sound5,sound6,sound7,sound8);
  MAP=l.generate_level();
  l.draw_level(MAP);
  
}

void mouseMoved(){
  if(start==true)
    l.p1.orient(atan2(mouseY-l.p1.position.y, mouseX-l.p1.position.x));
}

void mouseDragged(){
  if(start==true)
    l.p1.orient(atan2(mouseY-l.p1.position.y, mouseX-l.p1.position.x));
}

void keyPressed(){
  if(start==true){
    //System.out.println(keyCode);
    if((key== 'w' || keyCode== UP) && (keyCode!=LEFT && key!='a' && key!='d' && keyCode!=RIGHT)){
      l.p1.move(3);}
    if((key== 's' || keyCode== DOWN) && (keyCode!=LEFT && key!='a' && key!='d' && keyCode!=RIGHT)){
      l.p1.move(2); }
    if((key=='a' || keyCode== LEFT) && (keyCode!=UP && key!='w' && key!='s' && keyCode!=DOWN)){
      l.p1.move(1);}
    if((key=='d' || keyCode== RIGHT) && (keyCode!=UP && key!='w' && key!='s' && keyCode!=DOWN)){
      l.p1.move(0);}
    if(((keyCode==UP && keyCode== LEFT) || (key=='w' && key== 'a')) && (keyCode!=DOWN && key!='s' && keyCode!=RIGHT && key!='d')){
      l.p1.move(4);}
    if(((keyCode==UP && keyCode== RIGHT) || (key=='w' && key== 'd')) && (keyCode!=DOWN && key!='s' && keyCode!=LEFT && key!='a')){
      l.p1.move(5);}
    if(((keyCode==DOWN && keyCode== LEFT) || (key=='s' && key== 'a')) && (keyCode!=UP && key!='w' && keyCode!=RIGHT && key!='d')){
      l.p1.move(6);}
    if(((keyCode==DOWN && keyCode== RIGHT) || (key=='s' && key== 'd')) && (keyCode!=UP && key!='w' && keyCode!=LEFT && key!='a')){
      l.p1.move(7);}
  }
}

void mousePressed(){
  if(start==true){
    sound3.rewind();
    sound3.play(340);
    check_shot=1;
  }
}
