//This is 3DP model to translate gdsiistl.py from gds to stl and setup the 4 plates: top_paste, bottom_paste, top_component, bottom_component 

module PCBPlate (pcbFile,pcbBOARD, pcbLayer, pcbSTL,pcbSupport, scFactor, mirFactor)
{
  boardFile=str(pcbFile, "_",pcbBOARD,".stl");
  stlFile=str(pcbFile,"_",pcbLayer,pcbSTL,".stl");
  supportFile=str(pcbFile,"_",pcbSupport,".stl");
    echo (boardFile, stlFile, supportFile);
  mirFactor= pcbLayer=="Bottom" ? 180 : 0 ;
mirror([mirFactor,0,0])
{    
difference(){
    

  scale([1.0,1.0,scFactor])  
  import (file = boardFile);
  translate([0,0,-0.05])
  scale([1.0,1.0,scFactor])  
  union(){
 
      
  import (file = stlFile);
  color(c=[1,0.05,0.15]) ; 
  
    
  }
 }
 
 scale([1,1,scFactor-0.1])
 translate([0,0,-1.7])
 import (file=supportFile);
}
}

//top Paste
translate([0,0,0])
rotate([0,180,0])
color([0.8,0.4,0.0])
PCBPlate("pcb_rpsusbexp_v0p4c_allntxtggS.gds","Board","Top","_I","Mnt",2.0,0);
translate ([50,0,0])
rotate([0,180,0])
color([0.8,0.1,0.0])
PCBPlate("pcb_rpsusbexp_v0p4c_allntxtggS.gds","Board","Top","_S","Mnt",1.05,0);

//bottom
translate([-43.0,50,0])
rotate([0,180,0])
color([0.3,0.7,0.2])
PCBPlate("pcb_rpsusbexp_v0p4c_allntxtggS.gds","Board","Bottom","_I","Mnt",2.0,0);
translate ([7,50,0])
rotate([0,180,0])
color([0.1,0.6,0.7])
PCBPlate("pcb_rpsusbexp_v0p4c_allntxtggS.gds","Board","Bottom","_S","Mnt",1.05,0);
