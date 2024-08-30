//オペレーターかっ!
//キーボード操作版
//ライブラリ
import processing.serial.*;
import cc.arduino.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Arduino arduino;

//スイッチ類
int tact[]={4,10,11,12,13};
int touch=2;
int cds=0;
int volume=1;
int red=5,green=6;

//画像ファイル用
PImage gripsafety;
PImage trigger;

PImage hummer;
PImage hummer_on;

PImage body;
PImage slider;

PImage safety;
PImage safety_on;

PImage slidestop;
PImage slidestop_on;

//効果音
Minim minim;
AudioSample shot_se;
AudioSample safety_se;
AudioSample slider_se;
AudioSample triggerrock_se;

//各種パラメーター
boolean trigger_st=false;
boolean trigger_st2=false;
boolean hummer_st=false;
boolean magazin_st=false;
boolean magazinstop_st=false;
boolean safety_st=false;
boolean slidestop_st=false;
boolean gripsafety_st=false;

int light_val=100;
int ammo=0;
int chamber=0;

int slider_pos=0;
int slider_front=0;
int slider_back=0;
int gripsafety_pos=0;
int trigger_pos=0;

int hummer_count=0;
int magazinstop_count=0;
int slidestop_count=0;
int safety_count=0;
int trigger_count=0;

String str;

void setup(){
  size(640,426);
  frameRate(30);
  
  //Arduino設定
  println(Arduino.list());
  arduino=new Arduino(this,Arduino.list()[0],57600);
  for(int i=0;i<5;i++){
    arduino.pinMode(tact[i],Arduino.INPUT);
  }
  arduino.pinMode(touch,Arduino.INPUT);
  arduino.pinMode(red,Arduino.OUTPUT);
  arduino.pinMode(green,Arduino.OUTPUT);
  
  //画像読込み
  gripsafety=loadImage("gripsafety.png");
  trigger=loadImage("trigger.png");
  hummer=loadImage("hummer.png");
  hummer_on=loadImage("hummer-on.png");
  body=loadImage("body.png");
  slider=loadImage("slider.png");
  safety=loadImage("safety.png");
  safety_on=loadImage("safety-on.png");
  slidestop=loadImage("slidestop.png");
  slidestop_on=loadImage("slidestop-on.png");
  
  //効果音読込み
  minim=new Minim(this);
  shot_se=minim.loadSample("shot-se.mp3");
  safety_se=minim.loadSample("safety-se.mp3");
  slider_se=minim.loadSample("slider-se.mp3");
  triggerrock_se=minim.loadSample("triggerrock-se.mp3");
}

void draw(){
  background(color(0,0,255));
  
  
  //グリップセーフティ
  if(arduino.analogRead(cds)>=light_val){
    gripsafety_st=true;
  }
  else{
    gripsafety_st=false;
  }
  
  //ハンマー
  if(arduino.digitalRead(tact[4])==1&&hummer_st==false){
    hummer_st=true;
    safety_se.trigger();
  }
  else if(arduino.digitalRead(tact[4])==1&&hummer_st==true&&hummer_count==0){
    triggerrock_se.trigger();
    hummer_count++;
  }
  else if(arduino.digitalRead(tact[4])==1&&hummer_st==true&&hummer_count>=1){}
  else{hummer_count=0;}
  
  //リロード
  if(arduino.digitalRead(tact[1])==1&&magazinstop_st==false&&arduino.digitalRead(touch)==1&&magazinstop_count==0){
    ammo=7;
    magazinstop_st=true;
    safety_se.trigger();
    magazinstop_count++;
  }
  else if(arduino.digitalRead(tact[1])==1&&magazinstop_st==true&&arduino.digitalRead(touch)==1&&magazinstop_count>=1){}
  else{magazinstop_st=false;magazinstop_count=0;}
  
  //スライドストップ
  if(arduino.digitalRead(tact[3])==1&&slider_pos>=95&&slidestop_count==0&&slidestop_st==false){
    slidestop_st=true;
    safety_se.trigger();
    slidestop_count++;
    slider_pos=100;
  }
  else if(arduino.digitalRead(tact[3])==1&&slider_pos>=95&&slidestop_count==0&&slidestop_st==true){
    slidestop_st=false;
    safety_se.trigger();
    slidestop_count++;
  }
  else if(arduino.digitalRead(tact[3])==1&&slider_pos>=95&&slidestop_count>=1){}
  else{slidestop_count=0;}
  
  //サムセーフティ
  if(arduino.digitalRead(tact[2])==1&&slider_pos<=5&&safety_count==0&&safety_st==false&&hummer_st==true){
    safety_st=true;
    safety_se.trigger();
    safety_count++;
    slider_pos=0;
  }
  else if(arduino.digitalRead(tact[2])==1&&safety_count==0&&safety_st==true){
    safety_st=false;
    safety_se.trigger();
    safety_count++;
  }
  else if(arduino.digitalRead(tact[2])==1&&safety_count>=1){}
  else{safety_count=0;}
  
  
  if(slidestop_st==false&&safety_st==false){
    slider_pos=(int)map(arduino.analogRead(volume),0,1023,0,100);
  }
  
  
  //スライダー
  if(slider_pos>=95&&slider_front==0&&slider_back==0){
    slider_back=1;
    hummer_st=true;
    slider_se.trigger();
  }
  if(slider_pos<=5&&slider_back==1&&slider_front==0){
    slider_front=1;
    safety_se.trigger();
  }
  if(slider_front==1&&slider_back==1&&ammo>=1&&chamber==0){
    chamber=1;
    ammo--;
    slider_front=0;
    slider_back=0;
  }
  if(slider_front==1&&slider_back==1&&ammo>=1&&chamber==1){
    chamber=1;
    ammo--;
    slider_front=0;
    slider_back=0;
  }
  if(slider_front==1&&slider_back==1&&ammo==0&&chamber==1){
    chamber=0;
    slider_front=0;
    slider_back=0;
  }
  if(slider_front==1&&slider_back==1&&ammo==0&&chamber==0){
    slider_front=0;
    slider_back=0;
  }
  
  
  //LEDライト
  if(chamber==1&&slider_pos<=10&&safety_st==false&&hummer_st==true&&gripsafety_st==false&&slidestop_st==false&&trigger_count==0){
    arduino.analogWrite(green,100);arduino.analogWrite(red,0);trigger_st=false;
  }
  else{arduino.analogWrite(green,0);arduino.analogWrite(red,100);trigger_st=true;}
  
  //トリガー
  if(arduino.digitalRead(tact[0])==1&&ammo>=1&&chamber==1&&trigger_st==false&&trigger_count==0&&trigger_st2==false){
    trigger_st2=true;
    shot_se.trigger();
    ammo--;
    trigger_count++;
  }
  else if(arduino.digitalRead(tact[0])==1&&ammo>=0&&chamber==1&&trigger_st==false&&trigger_count==0&&trigger_st2==false){
    trigger_st2=true;
    shot_se.trigger();
    chamber=0;
    slidestop_st=true;
    trigger_count++;
  }
  else if(arduino.digitalRead(tact[0])==1&&trigger_st==true&&trigger_count==0){triggerrock_se.trigger();trigger_count++;}
  else if(arduino.digitalRead(tact[0])==1&&trigger_count>=1){}
  else if(arduino.digitalRead(tact[0])==0&&trigger_count>=1){trigger_count=0;}
  else{trigger_st2=false;}
  
  
  //銃描画
  gripsafety_pos=(int)map(arduino.analogRead(cds),0,1023,-5,0);
  image(gripsafety,gripsafety_pos,0);
  image(trigger,trigger_pos,0);
  if(hummer_st==false){
    image(hummer,0,0);
  }else{
    image(hummer_on,0,0);
  }
  if(slidestop_st==true){
    slider_pos=100;
  }
  image(slider,slider_pos,0);
  image(body,0,0);
  if(safety_st==false){
    image(safety,0,0);
  }else{
    image(safety_on,0,0);
  }
  if(slidestop_st==false){
    image(slidestop,0,0);
  }else{
    image(slidestop_on,0,0);
  }
  
  fill(0);
  textSize(40);
  str="ammo:"+ammo+" chamber:"+chamber;
  text(str,50,50);
}
