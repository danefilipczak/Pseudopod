
class Node {
  float mass;
  PVector position;
  PVector force = new PVector(0, 0, 0);
  
  Node (float m, PVector vec) {
   mass = m;
   position = vec;
  }
    

  void display(){
    fill(100);
    //translate(this.position.x, this.position.y, 0);
    //box(10);
    strokeWeight(10);
    stroke(0);
    point(position.x, position.y, 0);
  };
  
  void addForce(PVector forceVector) {
      force.add(forceVector);
  }
  
  
  void applyForce(){ 
      position.add(force);
      force.set(0, 0, 0);
  }
};