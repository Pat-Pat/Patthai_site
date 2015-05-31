// Tracky 
// Pat Pataranutaporn
// Codeday 2014

import processing.video.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.InputEvent;
Robot robot;
boolean mouse = false;
boolean flip = false;

// Variable for capture device
Capture video;

// A variable for the color we are searching for.
color trackColor; 
color trackColor_2; 
int lock = 0;
int a;
int G_c_x = 0;
int G_c_y = 0;
int V_c_x = 0;
int V_c_y = 0;
int V_ave_x ;
int V_ave_y ;
int G_ave_x ;
int G_ave_y ;

void setup() 
        {
   try { 
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }       
          
          
  size(640,480);
  video = new Capture(this,width,height,35);
  trackColor = color(0,255,0);
  trackColor_2 = color(154,50,205);
  smooth();
  video.start();
        }

void draw() 

 {
  // Capture and display the video
  if (video.available()) 
        {
    video.read();
        }
  
  video.loadPixels();
  image(video,0,0);
  filter(BLUR, 1);
   
   //frame.setLocation(displayWidth/2-width/2,displayHeight/2-height/2);
   

  
 
  int count = 0;
  int count_v = 0;
  int g_x = 0;
  int g_y = 0;
  int v_x = 0;
  int v_y = 0;
  
  if(lock > 0){
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) 
     {
    for (int y = 0; y < video.height; y ++ )
        {
      int loc = x + y*video.width;
     
        color currentColor = video.pixels[loc];
        //green
        float r1 = red(currentColor);
        float g1 = green(currentColor);
        float b1 = blue(currentColor);
        float r2 = red(trackColor);
        float g2 = green(trackColor);
        float b2 = blue(trackColor);

        float d = dist(r1,g1,b1,r2,g2,b2); 
    
        if (d < 52) 
          {
            if(dist(x, y, G_c_x, G_c_y)<40 )
             {
               set(x, y, color(0,255,0));
               count = count + 1;
               g_x = g_x+x;
               g_y = g_y+y;
             }
          }
        
       //violet
      if(lock > 1){
        float r3 = red(trackColor_2);
        float g3 = green(trackColor_2);
        float b3 = blue(trackColor_2);
        
        float e = dist(r1,g1,b1,r3,g3,b3); 
    
        if (e < 55) 
          {
            if(dist(x, y, V_c_x, V_c_y)<40 )
             {
               set(x, y, color(trackColor_2));
               count_v = count_v + 1;
               v_x = v_x+x;
               v_y = v_y+y;
             }
          }
                  }
        }
      }
  if(count > 90)
      {
        G_ave_x = g_x/count;
        G_ave_y = g_y/count;
        G_c_x = G_ave_x;
        G_c_y = G_ave_y;
        fill(trackColor);
        strokeWeight(4.0);
        stroke(3);
        ellipse(G_ave_x,G_ave_y,16,16);
        
      }
    if(count_v > 0)
      {
        V_ave_x = v_x/count_v;
        V_ave_y = v_y/count_v;
        V_c_x = V_ave_x;
        V_c_y = V_ave_y;
        fill(trackColor_2);
        strokeWeight(4.0);
        stroke(3);
        ellipse(V_ave_x,V_ave_y,16,16);
        if (mouse) {
          //if (flip) {
        robot.mouseMove (((width/2)-((((V_ave_x+V_ave_x)-(width/2))*2)-(width/2))),((V_ave_y+V_ave_y)-(height/2))*2);
                    if(dist(G_ave_x, G_ave_y, V_ave_x, V_ave_y)<68 ){
                   robot.mousePress(InputEvent.BUTTON1_MASK);
                   
                    println(a);
                    a++;
                     
                    }
                    else{robot.mouseRelease(InputEvent.BUTTON1_MASK);}
        
          
   
        }
      }   
      
 
  }//lock
}

void mousePressed() {
  if (!mouse){
      if(lock == 2){
      lock = 0;  
      }
      
      int loc = mouseX + mouseY*video.width;
      if(lock > 0){
      lock = 2;
      trackColor_2 = video.pixels[loc];
      V_c_x = mouseX;
      V_c_y = mouseY;
      }
      if(lock < 1){
      lock = 1;
      trackColor = video.pixels[loc];
      G_c_x = mouseX;
      G_c_y = mouseY;
      } 
}
}

void keyPressed() {
  switch (key) {
  case 'm':
      if (mouse) { 
        mouse = false;
         } 
        else{ 
        mouse = true;
         } 
      break;
    case 'f':
      if (flip) { 
        flip = false;
         } 
        else{ 
        flip = true;
         } 
    default: 
      break;
  }
}
