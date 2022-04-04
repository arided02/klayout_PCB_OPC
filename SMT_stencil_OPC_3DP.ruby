

# This macro is wrote for PCB SMT Stencil OPC manufacturing on 3DP FDM process
# Use a tile size of 1mm
#tiles(1.5)

# Use 2 CPU cores
threads(3)
mycv = RBA::CellView::active

# This is a sample:
nozzleWidth=0.4 #nozzle width 0.4mm
stencilHeight=0.18  #0.18mm thcokness for SMT
pasteFactor= 0.93  ##93% volumn 55%-225%
reflowVolloss=0.5 ##50%volumn remaining after reflow of solder paste
stencilVolloss=0.2 ##10~20% vol lost during stencil solder brushed
nozzleSpaceFix=nozzleWidth/2*1.15
nozzleLengthFix=-nozzleWidth/2*0.85
minSizeWidth=nozzleWidth/pasteFactor/reflowVolloss/(1-stencilVolloss)
minSizeWidthx2=minSizeWidth * 2
puts "spaceFix", nozzleSpaceFix,"LenfthFix",nozzleLengthFix,minSizeWidth,"\n"

topPaste = input("Top_Paste")
bottomPaste = input("Bottom_Paste")
boardLine = input ("Board_Outline")

##smooth small boardlines fragment
#topt1=topPaste.sized(0.001).sized(-0.001).output("temp1 (1000/0)")
#bottomt1=bottomPaste.sized(0.001).sized(-0.001).output("temp2 (1001/0)")
boardlinet1=boardLine.sized(-0.06,0).sized(0.12,0).sized(-0.06,0) #.output("temp3 (1002/0)")

#smooth boardlines and filled with boardSq

#boardLine = input ("Board_Outline")
#boardlinet1=input("temp3")
boardlinet2=boardLine.interacting(boardlinet1)
#boardlinet2.output("temp3 (1002/0)")

#do y axis sizeing out
#boardlinet2=input(1002)
boardlinet3=boardlinet2.sized(0,-0.07).sized(0,0.14).sized(0,-0.07) #.output("temp4 (1003/0)")

#boardLine = input ("Board_Outline")
#boardlinet3=input("temp4")
boardlinet4=boardLine.interacting(boardlinet3)
#boardlinet4.output("temp4 (1003/0)")
#boardlinet4=input("temp4")
hulls(boardlinet4).size(0.061).size(-0.071).output("boardSq (1006/0)")


## Paste global size up for 3DP
def myPasteOPC1 (nozzleWidth,nozzleSpaceFix,nozzleLengthFix,minSizeWidth,minSizeWidthx2,myLayer,outPutGDS)
    #topt1=input("temp1")
    #topt2=topt1.size(nozzleSpaceFix).size(-nozzleSpaceFix).size(nozzleSpaceFix).output(1000)
    #topt1=input("temp1")
    #topt1.space(0.4).output("temp2 (1001/0)")
    
    ##nil all variable
    mycv = RBA::CellView::active
    topPasteSum = nil
    topPaste = nil
    topPasteW1 = nil
    topPasteW2 = nil
    topPasteW3 = nil
    topPasteW1t1= nil
    topPasteW1t1_1 = nil
    topPasteW1t2 = nil
    topPasteW1t3 = nil
    topPasteW1t4 = nil
    topPasteW1t5 = nil
    topPasteW1t6 = nil
    topPasteW1t6_1 = nil
    topPasteW1t7 = nil
    topPasteW1t7_1 = nil
    topPasteW1_opc = nil
    topPasteW1M1 = nil
    topPasteW1M2 = nil
    topPasteW1M2t1 = nil
    topPasteW1M2t2 = nil
    topPasteW1M2t3 = nil
    topPasteW1M2t4 = nil
    topPasteW1M2_out = nil
    topPasteW1_opc = nil
   # mycv.layout.delete_layer("tp2")  #but failllled...
   # mycv.layout.delete_layer("tp3")
   # mycv.layout.delete_layer("tp4")
   # mycv.layout.delete_layer("tp2_short")
   # mycv.layout.delete_layer("tp2_final")
   # mycv.layout.delete_layer("tp2_narrow")
    ### check the bbox >minSizWidth and x2 of them in 3 gds layers
    topPaste = input(myLayer)
    topPasteW1 =topPaste.with_bbox_min(0,minSizeWidth).sized(nozzleSpaceFix) #.output("tp2")
    topPasteW2 =topPaste.with_bbox_min(minSizeWidth,minSizeWidthx2).sized(nozzleSpaceFix/2) #.output("tp3")
    topPasteW3 =topPaste.with_bbox_min(minSizeWidthx2,minSizeWidth*3) #.output("tp4")

    ##OPC on volumn ratio on W1 (tp2)
    #tp2 space <0.4 picked
    #topPasteW1=input("tp2")
    topPasteW1t1=((topPasteW1.space(nozzleWidth))).output("tp2_narrow") ###@space need to output layer to be a polygon....
    topPasteW1t1=input("tp2_narrow") ##rule check will be no residue patterns on previous layers.
    topPasteW1t1_1=(topPasteW1t1.sized(nozzleLengthFix/2).sized(-nozzleLengthFix/2)) #.output("tp2_narrow1")
    #topPasteW1t1_1=input("tp2_narrow1")
    #check y axis center lines to judge another x axis by nozzlewidth rule
    topPasteW1t2=((topPasteW1t1_1.extent_refs(:bottom_center)).or(topPasteW1t1.extent_refs(:top_center))) #.output("tp3_narrow")
    #topPasteW1t2=input("tp3_narrow")
    ##x,y directions
    topPasteW1t3=topPasteW1t2.sized(0,nozzleWidth/2-0.001).sized(0,-nozzleWidth/2) ##.sized(nozzleWidth/2-0.001,0).sized(-nozzleWidth/2,0) #.sized(nozzleWidth/2,0)
    topPasteW1t4=topPasteW1t2.interacting(topPasteW1t3)
    #topPasteW1t4.output("tp3_narrowX")
    topPasteW1t5=topPasteW1t2.not_interacting(topPasteW1t3)
    #topPasteW1t5.output("tp3_narrowY")
    topPasteW1t6=topPasteW1t1_1.interacting(topPasteW1t4)
    #topPasteW1t6.output("tp2_narrowX")
    topPasteW1t7=topPasteW1t1_1.interacting(topPasteW1t5)
    #topPasteW1t7.output("tp2_narrowY")
    ##center line again
    topPasteW1t6_1=((topPasteW1t6.extent_refs(:left_center)).or(topPasteW1t6.extent_refs(:right_center))).sized(10000,0).sized(-10000,0).sized(0,nozzleWidth/2-0.001) #.output("tp2_narrowX_LR")
    topPasteW1t7_1=((topPasteW1t7.extent_refs(:bottom_center)).or(topPasteW1t7.extent_refs(:top_center))).sized(0,10000).sized(0,-10000).sized(nozzleWidth/2-0.001,0)#.output("tp2_narrowY_TB")
    #topPasteW1t6_1=input("tp2_narrowX_LR")
    #topPasteW1t7_1=input("tp2_narrowY_TB")
    topPasteW1_opc=topPasteW1.not(topPasteW1t6_1.or(topPasteW1t7_1)) #.output("tp2_OPC")

    #check tp2 merged polygons <0.4mm
    #topPasteW1=input("tp2")
    topPaste = input(myLayer)
    topPasteW1M1=topPaste.space(nozzleSpaceFix*2).output("tp2_short")
    topPasteW1M1=input("tp2_short")
    topPasteW1M2=topPasteW1.interacting(topPasteW1M1) #.output("tp2s_t1")
    ##check top/bottom center lines y axis
    #topPasteW1M2=input("tp2s_t1")
    topPasteW1M2t1=((topPasteW1M2.extent_refs(:bottom_center)).or(topPasteW1M2.extent_refs(:top_center)))
    #topPasteW1M2t1.output("tp2s_t2")
    topPasteW1M2t2=topPasteW1M2t1.sized(0,minSizeWidth-0.001).sized(0,-minSizeWidth) #.output("tp2s_t3")
    #topPasteW1M2=input("tp2s_t1")
    #topPasteW1M2t2=input("tp2s_t3")
    topPasteW1M2t3=topPasteW1M2.interacting(topPasteW1M2t2) #.output("tp2s_t4") ## y shorter than x axis
    topPasteW1M2t4=topPasteW1M2.not_interacting(topPasteW1M2t2) #.output("tp2s_t5") ## x shorter than y axis
    topPasteW1M2_out=(topPasteW1M2t3.sized(0,-nozzleSpaceFix*1.5)).or (topPasteW1M2t4.sized(-nozzleSpaceFix*1.5,0))  ##enlarge the disclosre region of merged pads.
    topPasteW1_opc= ((topPasteW1M2_out.or(topPasteW1_opc.not_interacting(topPasteW1M2_out)))).sized(0.05).sized(-0.1).sized(0.05) #.output("tp2_final")
    #sum all of tpX
    #topPasteW1_opc=input("tp2_final")
    #topPasteW2=input("tp3")
    #topPasteW3=input("tp4")
    myLayerOPC=""""+ myLayer+"OPC (#{ outPutGDS }/0)"""
    puts myLayerOPC
    topPasteSum=(topPasteW1_opc+topPasteW2+topPasteW3).output(myLayerOPC)
    puts "output done"
   
    
end

def myChipHolder(nozzleWidth,nozzleSpaceFix,nozzleLengthFix,minSizeWidth,minSizeWidthx2,pasteLayer,silkLayer,assemblyLayer,courtyard,boardLayer, outputGDS)
   padPaste=input(pasteLayer)
   silk=input(silkLayer)
   assembly=input(assemblyLayer)
   court=input(courtyard)
   puresilk=silk.not_interacting(assembly)
   board=input(boardLayer)
   padPasteS1=((padPaste.sized(0.2).sized(-0.4).sized(0.2)).or(puresilk.sized(0.2).sized(-0.4).sized(0.2))).sized(nozzleWidth).sized(-nozzleWidth*2).sized(1.5*nozzleWidth)
   #padPasteS1.output("h1")
   ##hull the silk
   padPasteT1=((((hulls(puresilk).sized(nozzleWidth*1.5)).and(board)).interacting(padPasteS1)).or(padPaste)).sized(+nozzleWidth*0.25)
   #padPasteT1.output("h2")
   padPasteT2=hulls(padPasteT1)
   padCourt=hulls(court).and(board)
   padPasteT3=(padPasteT2.and(padCourt)).or(padPasteT2.not_interacting(padCourt)).or((padPasteT2.not(padCourt)).interacting(silk))
   padHolderT1=(padPasteS1.or(padPasteT3.or(padCourt))).sized(0.15).sized(-0.3).sized(0.15)
   ## check to silk <0.085 to enlarge to 0.2
   padSilkT1=padHolderT1.enclosing(silk,0.2).output("holderSilkp2")
   padSilkT1=input("holderSilkp2")
   padSilk=padSilkT1.size(0.12)
   padHolder=(padHolderT1.or(padSilk)).sized(0.15).sized(-0.3).sized(0.15)   
   silkLayerOPC=""""+ silkLayer+"OPC (#{ outputGDS }/0)"""
   puts silkLayerOPC
   padHolder.output(silkLayerOPC)
end

def pcbHole(nozzleWidth,minSizeWidth,drillLayer, outputGDS)
   drill=input(drillLayer)
   drillT1=drill.sized(-minSizeWidth*1.5).sized(2*minSizeWidth*1.5).sized(-minSizeWidth*1.5-nozzleWidth/2)
   drillLayerOut=""""+ drillLayer+"Mnt(#{ outputGDS }/0)"""
   puts drillLayerOut
   drillT1.output(drillLayerOut)

end

## draw the toppaste and bottompaste OPC
#topPasteOPC
myPasteOPC1(nozzleWidth,nozzleSpaceFix,nozzleLengthFix,minSizeWidth,minSizeWidthx2,"Top_Paste", 1007)
#bottomPasteOPC
myPasteOPC1(nozzleWidth,nozzleSpaceFix,nozzleLengthFix,minSizeWidth,minSizeWidthx2,"Bottom_Paste", 1008)

## draw add the IC/R/C SMT holder
myChipHolder(nozzleWidth,nozzleSpaceFix,nozzleLengthFix,minSizeWidth,minSizeWidthx2, "Top_Paste", "Top_Silk","Top_Assembly","Top_Courtyard","boardSq", 1010)
## bottom holder
myChipHolder(nozzleWidth,nozzleSpaceFix,nozzleLengthFix,minSizeWidth,minSizeWidthx2, "Bottom_Paste", "Bottom_Silk","Bottom_Assembly","Nottom_Courtyard","boardSq", 1011)

##draw the PCB Holder via large mount drill holes.
pcbHole(nozzleWidth,minSizeWidth,"Drill_Top", 1009)
