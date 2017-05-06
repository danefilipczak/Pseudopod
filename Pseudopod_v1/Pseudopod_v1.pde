//by dane filipczak 
//requires toxiclibs and controlP5, gratitude to the authors of these libraries
////there are three basic rules: 
//1. every node is attracted to its neighbors within a certain threshold. 
//2. every node is repulsed from every other node within a certain threshold. 
//3. if the distance between two nodes gets to great, a new node is inserted halfway between them. 



int GRID=40; //adjust this to affect the mesh resolution. Lower numbers will acheive a higher frame rate with a lower quality mesh. 


import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.*;
import toxi.volume.*;

import java.util.Iterator;
import controlP5.*;

int NUM_PARTICLES = 1;
float REST_LENGTH=375;
int DIM=300;
float a = 0;

int resolution = 100;


float VS=2*DIM/GRID;
Vec3D SCALE=new Vec3D(DIM,DIM,DIM).scale(2);
float isoThreshold=11;

int numP;


boolean death = true;
float deathRate = 25;


float scale = 1;
float maxNodes = 50;

VolumetricSpaceArray volume;
IsoSurface surface;

TriangleMesh mesh=new TriangleMesh("pseudopod");

boolean showPhysics=false;
boolean isWireFrame=true;
boolean isClosed=true;
boolean useBoundary=false;
boolean displayNodes = true;

float pos0;
float pos1;

Vec3D colAmp=new Vec3D(200, 300, 400);


void setup() {
  size(1280,720,P3D);
  smooth();
  
    for(int i=0;i<fidelity;i++){
      PVector vec = new PVector(r, 0);
      float angle = radians(360/fidelity*i+random(-10, 10));
      vec.rotate(angle);
      Node node = new Node(1, vec);
      nodes.add(node);
      //colorMode(HSB);

    }
    
    
 
  initGUI();
      pos0 = attraction.getPosition()[1]+attraction.getHeight()+20;
            pos1 = repulsion.getPosition()[1]+repulsion.getHeight()+20;


  volume=new VolumetricSpaceArray(SCALE,GRID,GRID,GRID);
  surface=new ArrayIsoSurface(volume);
  textFont(createFont("Monospaced",9));
}

void draw() {

  numP=nodes.size();
  float[] attr = attraction.getArrayValue();
  attractionStrength = attr[0];
  attractionThresh = attr[1];
  attractionStrength = map(attractionStrength, 0, resolution, 0.0, -10.0);
  attractionThresh = map(attractionThresh, 0, resolution, 0, 100);
  
  
  float[] rep = repulsion.getArrayValue();
  repulsionStrength = rep[0];
  repulsionThresh = rep[1];
  repulsionStrength = map(repulsionStrength, 0, resolution, 0.0, 1.0);
  repulsionThresh = map(repulsionThresh, 0, resolution, 0, 100);

  computeVolume();
  background(180);
  //background(200, 200, 70);
  pushMatrix();
  translate(width/2,height*0.5,0);
  scale(scale);
  //rotateX(mouseY*0.01);
  rotateY(a);
  a+=0.001;
  noFill();
  stroke(255,192);
  strokeWeight(1);
  //box(physics.getWorldBounds().getExtent().x*2);
  box(DIM*2);
  if (showPhysics) {
    strokeWeight(4);
    stroke(0);
  } 
  else {
    ambientLight(216, 216, 216);
    directionalLight(255, 255, 255, 0, 1, 0);
    directionalLight(96, 96, 96, 1, 1, -1);
    if (isWireFrame) {
      stroke(255);
      noFill();
    } 
    else {
      noStroke();
      fill(224,0,51);
    }
    beginShape(TRIANGLES);
    if (!isWireFrame) {
      drawFilledMesh();
    } 
    else {
      drawWireMesh();
    }
    endShape();
  }
  
  
  
  rejectAll();
  attractNeighbors();
  edges();
  edgeSplit();
  for(Node i : nodes){
    i.applyForce();
  }
  
  
  if(death){
    kill(deathRate);
  }
  if(displayNodes){
    for(int i=0;i<nodes.size();i++){
      nodes.get(i).display();
    }
  }
  
  popMatrix();
  noLights();
  fill(0);
  text("faces: "+mesh.getNumFaces(),20,600);
  text("vertices: "+mesh.getNumVertices(),20,615);
  text("nodes: "+nodes.size(),20,630);
  //text("springs: "+physics.springs.size(),20,645);
  text("fps: "+frameRate,20,690);
  
  text("ATTRACTION",20,pos0);
  text("strength: "+attractionStrength,20,pos0+15);
  text("thresh: "+attractionThresh,20,pos0+30);
  
   text("REPULSION",20,pos1);
  text("strength: "+repulsionStrength,20,pos1+15);
  text("thresh: "+repulsionThresh,20,pos1+30);

  //text("threshold: "+attractionThresh,30,pos0+12);

}

void keyPressed() {
  //if (key=='r') initPhysics();
  if (key=='w') isWireFrame=!isWireFrame;

  if (key=='-' || key=='_') {
    isoThreshold-=0.001;
  }
  if (key=='=' || key=='+') {
    isoThreshold+=0.001;
  }
  if (key=='s') {
    saveMesh();
  }
  if (keyCode==UP){
    scale+=0.1;
  }
  if (keyCode==DOWN){
    scale-=0.1;
  }
   if (keyCode==LEFT){
   a+=0.1;
  }
   if (keyCode==RIGHT){
    a-=0.1;
  }
}

void saveMesh(){
  mesh.saveAsOBJ(sketchPath(mesh.name+frameCount+".obj"));
  mesh.saveAsSTL(sketchPath(mesh.name+frameCount+".stl"));
}