//scale([0.1,0.1,0.1])
//surface(file = "pcb_rpsusbexp_v0p4_07ss.png", center = true, convexity = 5);

//linear_extrude(height = 2, center = true, convexity = 10)
//   import (file = "pcb_rpsusbexp_v0p4_07ss.dxf", layer = "Top_Paste");
//linear_extrude(height = 2, center = true, convexity = 10)
/*
//scale([2,2,1])
union(){
    
  import (file = "pcb_rpsusbexp_v0p4_07ss.GDS_Top.stl");
  color(c=[1,0.05,0.25])  
  translate([0,0,0.05])
    import (file = "pcb_rpsusbexp_v0p4_07ss.GDS_Top_S.stl", layer = "Top Paste");
    
    
}
*/

//hull(){
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
    
//boardFile=str(pcbFile, "_",pcbBOARD,".stl");
  scale([1.0,1.0,scFactor])  
  import (file = boardFile);
 
  scale([1.0,1.0,scFactor])  
  union(){
 //   stlFile=str(pcbFile,"_",pcbSTL,".stl");
      
  import (file = stlFile);
  color(c=[1,0.05,0.15]) ; 
  //translate([0,0,-0.40])
  //  import (file = "pcb_rpsusbexp_v0p4_07sss.GDS_Top_S.stl", layer = "Top Paste");
    
    
  }
 }
 //support
 //supportFile=str(pcbFile,"_",pcbSupport,".stl");
 scale([1,1,scFactor])
 translate([0,0,-1.7])
 import (file=supportFile);
}
}
//}
//top Paste
rotate([0,180,0])
PCBPlate("pcb_rpsusbexp_v0p4c_allntxtggS.gds","Board","Top","_S","Mnt",1.05,0);