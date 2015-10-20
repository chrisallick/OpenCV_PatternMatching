//http://stackoverflow.com/questions/14792103/fuzzy-template-matching

import processing.video.*;

import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Mat;
import org.opencv.core.Core.MinMaxLocResult;
import org.opencv.core.Core;


OpenCV opencv, small, large, fire;

PImage template;

int w = 1280;
int h = 720;
Movie mov;
PVector smallPos, largePos, firePos;
float smallConf, largeConf, fireConf;

void setup() {
//  small = new OpenCV(this, "ten.png"); 
  large = new OpenCV(this, "eleven.png");  

//  smallPos = new PVector();
  largePos = new PVector();

  mov = new Movie(this, "movie.mov");
  opencv = new OpenCV(this, w, h);
  size(w, h);

  mov.play();
}

float findMario(PVector p, OpenCV t) {
  //opencv.setGray(opencv.getR().clone());
  Imgproc.morphologyEx(opencv.getR(), opencv.getR(), Imgproc.MORPH_GRADIENT, new Mat());

  t.setGray(t.getR().clone());
  Imgproc.morphologyEx(t.getGray(), t.getGray(), Imgproc.MORPH_GRADIENT, new Mat());

  Mat result = new Mat();
  Imgproc.matchTemplate(opencv.getR(), t.getGray(), result, Imgproc.TM_CCORR_NORMED);

  MinMaxLocResult  r = Core.minMaxLoc(result);
  p.x = OpenCV.pointToPVector(r.maxLoc).x;
  p.y = OpenCV.pointToPVector(r.maxLoc).y;
  return (float)r.maxVal;
}

void draw() {
  image(mov, 0, 0);
 
   noFill();
    stroke(255, 0, 0);
    strokeWeight(2);

//  if (smallConf > 0.6) {
//    text("small - " + smallConf, smallPos.x, smallPos.y - 30);
//    rect(smallPos.x, smallPos.y, small.width, small.height);
//  }
  if (largeConf > 0.3) {
    text("large - " + largeConf , largePos.x, largePos.y - 30);
    rect(largePos.x, largePos.y, large.width/2, large.height/2);
  }
}

void movieEvent(Movie e) {
  e.read();
  opencv.loadImage(e);
//  smallConf = findMario(smallPos, small);
  largeConf = findMario(largePos, large);
}
