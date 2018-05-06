// Some real-time FFT! This visualizes music in the frequency domain using a
// polar-coordinate particle system. Particle size and radial distance are modulated
// using a filtered FFT. Color is sampled from an image.

import ddf.minim.analysis.*;
import ddf.minim.*;

OPC opc;
PImage dot;
PImage colors;

Minim minim;
AudioPlayer sound;
FFT fft;
float[] fftFilter;

String filename = "flume.mp3";
float spin = .00001;
float radiansPerBucket = radians(2);
float decay =.7;
float opacity = 40;
float minSize = 0.001;
float sizeScale = .5;

void setup()
{
  size(900,900, P3D);

  minim = new Minim(this); 

  // Small buffer size!
  sound = minim.loadFile(filename, 512);
  sound.loop();
  fft = new FFT(sound.bufferSize(), sound.sampleRate());
  fftFilter = new float[fft.specSize()];

  dot = loadImage("mask.jpg");
  colors = loadImage("colors1.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  float spacing = height / 16.0;
  opc.ledGrid8x8(0, width/2, height/2, spacing, 0, true);

  // Put two more 8x8 grids to the left and to the right of that one.
  opc.ledGrid8x8(64, width/2 - spacing * 8, height/2, spacing, 0, true);
  opc.ledGrid8x8(128, width/2 + spacing * 8, height/2, spacing, 0, true);
  
}

void draw()
{
  background(0);
  
  stroke(255, 255, 255);
  strokeWeight(10);
  fill(0);

  fft.forward(sound.mix);
  
  
  for (int i = 0; i < fftFilter.length; i++) {
    fftFilter[i] = max(fftFilter[i] * decay, log(3 + fft.getBand(i)));
  }
  

  /*
  for (int i = 0; i < fftFilter.length; i+=5){
    
    
    
    color rgb = colors.get(int(map(i, 0, fftFilter.length-1, 0, colors.width-1)), colors.height/2);
    tint(rgb, fftFilter[i] * opacity);
    //blendMode(ADD);
 
    float size = height * (minSize + sizeScale * fftFilter[i]);
    PVector center = new PVector(width * (fftFilter[i] * 0.2), 50);
    center.rotate(millis() * spin + i * radiansPerBucket);
    center.add(new PVector(width * 0.5, height * 0.5));
    
    rect (center.x-size/2, center.y - size/2, size, size);
     
    //image(dot, center.x - size/2, center.y - size/2, size, size);
  }
  */


  for (int i = 0; i < fftFilter.length; i+=3){
    float size = fftFilter[i]*600;
    //stroke(204, 0, 0);
    
   
   //stroke(random(255), random(255), random(255));
    strokeWeight(1);
    rectMode(CENTER);
    if (i < 250){
      stroke(random(255), random(255), random(255));
      
    }
    if (i > 250){
      stroke(255, 255, 255);
    }
    rect(width/2, height/2, size, size);
  }
  
 
   for (int i = 0; i < fftFilter.length; i++){
    strokeWeight(15);
    float size = fftFilter[i]*150;
   stroke(255, 255, 0);
    //stroke(random(255), random(255), random(255));
    ellipse(width/2, height/2, size, size);
  }
  
  
  for (int i = 0; i < fftFilter.length; i+=3){
    strokeWeight(10);
    float size = fftFilter[i]*25;
     //stroke(238, 0, 238);
    stroke(random(255), random(255), random(255));
    ellipse(width/2, height/2, size, size);
  }
  
  /*
  for (int i = 0; i < fftFilter.length; i += 3) { 
    
        if (i < 50){
      stroke (255, 20, 147);
      //DEEPPINK1
    }
    else if (i <= 100 && i > 50){
      stroke(255, 255, 0);
      //MAGENTA
    }
    
    else if (i <= 150 && i > 100){
      stroke (30, 144, 255);
      //DODGERBLUE1
      
    }
    
    else if (i <= 200 && i > 150){
      stroke (0, 245, 255);
      //TURQUOISE1
    }
    
    else if (i <= 250 && i > 200){
      stroke (0, 255, 127);
      //SPRINGGREEN
    }
    
    else if (i <= 300 && i > 250){
      stroke(255, 255, 0);
      //YELLOW1
    }
    else if (i <= 350 && i > 300){
      stroke(255, 165, 0);
    }
    else if (i <= 400 && i > 350){
      stroke(150, 69, 0);
    }
    
    
    
    color rgb = colors.get(int(map(i, 0, fftFilter.length-1, 0, colors.width-1)), colors.height/2);
    tint(rgb, fftFilter[i] * opacity);
    blendMode(ADD);
 
    float size = height * (minSize + sizeScale * fftFilter[i]);
    PVector center = new PVector(width * (fftFilter[i] * 0.2), 50);
    center.rotate(millis() * spin + i * radiansPerBucket);
    center.add(new PVector(width * 0.5, height * 0.5));
    
    //rect (center.x-size/2, center.y - size/2, size, size);
    rect (width/2, height/2, size, size);
 
    //image(dot, center.x - size/2, center.y - size/2, size, size);
  }*/
  
}
