ControlP5 ui;
Slider2D attraction;
Slider2D repulsion;

void initGUI() {
  ui = new ControlP5(this);
  ui.addSlider("isoThreshold",1,100,isoThreshold,20,20,100,14).setLabel("iso threshold");
  ui.addSlider("thresh",1,100,thresh,20,60,100,14).setLabel("split threshold").setValue(16);
  ui.addSlider("maxNodes",1,200,thresh,20,40,100,14).setLabel("max nodes").setValue(50);
    ui.addSlider("deathRate",0,100,deathRate,20,115,100,14).setLabel("death rate");

    
  attraction = ui.addSlider2D("attraction")
       .setPosition(20,250)
       .setSize(75,75)
       .setMinMax(0, 0, resolution,resolution)
       .setValue(11,14)
       .setLabelVisible(false)
       .setLabel("")
       
       ;
       
    repulsion = ui.addSlider2D("repulsion")
     .setPosition(20,420)
     .setSize(75,75)
     .setMinMax(0, 0, resolution,resolution)
     .setValue(25,50)
     .setLabelVisible(false)
     .setLabel("")
     //.hide();
     ;




  ui.addToggle("isWireFrame",isWireFrame,20,140,14,14).setLabel("wireframe");
   ui.addToggle("death",death,20,80,14,14).setLabel("death?");
  ui.addToggle("displayNodes",displayNodes,20,170,14,14).setLabel("display nodes");
  ui.addBang("saveMesh",20,height-85,28,28).setLabel("save");
}