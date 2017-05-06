
//import peasy.*;
//import ComputationalGeometry.*;

//IsoSurface iso;
float c=0;
float angle=0;


ArrayList<Node> nodes = new ArrayList<Node>();

float centerX, centerY;
PVector center;

int thresh= 25;
int r = 10;
float repulsionStrength = 0.4;
float attractionStrength = 0.03;
float attractionThresh = 20;
float repulsionThresh = 40;
int fidelity=10; //bitrate of the circle



void attractNeighbors(){
 for(int i = 0; i<nodes.size(); i++){
   int right = i+1;
   int left = i-1;
   if (right>nodes.size()-1){
     right=0;
   };
   if (left < 0){left = nodes.size()-1;};
   if(nodes.get(i).position.dist(nodes.get(right).position)>attractionThresh){
     PVector force = PVector.sub(nodes.get(i).position, nodes.get(right).position);
          force.normalize();
          nodes.get(i).addForce(force.mult(attractionStrength));
   }; 
   if (nodes.get(i).position.dist(nodes.get(left).position)>attractionThresh){
     // var d = p5.Vector.lerp(nodes[i].pos, nodes[left].pos, aForce);
     // nodes[i].pos = d;
     PVector force = PVector.sub(nodes.get(i).position, nodes.get(left).position);
           force.normalize();
          nodes.get(i).addForce(force.mult(attractionStrength));
   };
 };
};







Node growMidpoint(PVector vec1, PVector vec2){
   PVector d = PVector.lerp(vec1, vec2, 0.5);
   Node bulb = new Node(1, d);
   return bulb;
}

void edgeSplit(){
  for(int i = 0; i<nodes.size(); i++){
    int neighbor = i+1;
    if (neighbor>nodes.size()-1){neighbor=0;};
    if(nodes.get(i).position.dist(nodes.get(neighbor).position)>thresh&&nodes.size()<maxNodes){
      Node bulb = growMidpoint(nodes.get(i).position, nodes.get(neighbor).position);
      nodes.add(neighbor, bulb);
    }
  }
}


void rejectAll(){
   for (int i = 0; i < nodes.size(); i++) {
      for (int j = 0; j < nodes.size(); j++) {
        if (i != j) {
        if(nodes.get(j).position.dist(nodes.get(i).position)<repulsionThresh){
           PVector force = PVector.sub(nodes.get(i).position, nodes.get(j).position);
           force.normalize();
          nodes.get(i).addForce(force.mult(repulsionStrength));
        }
      }
    }
  }
}


void twodDraw(){
  beginShape();
    for(int i = 0; i<nodes.size();i++){
      vertex(nodes.get(i).position.x, nodes.get(i).position.y);
    }
  endShape(CLOSE);
}


void edges(){
  for(Node i : nodes){
    if(i.position.y>DIM){
      i.position.y = DIM;
    } else if(i.position.y<-DIM){
      i.position.y = -DIM;
    } else if(i.position.x>DIM){
      i.position.x = DIM;
    } else if(i.position.x<-DIM){
      i.position.x = -DIM;
    }
  }
}



void kill(float rate){
  if(random(100)<rate&&nodes.size()>2){
    int index = floor(random(nodes.size()));
    Node toDie = nodes.get(index);
    nodes.remove(index);
    toDie = null;
  }
  
}