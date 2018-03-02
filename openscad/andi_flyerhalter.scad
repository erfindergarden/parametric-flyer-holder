// AUTHOR: Kaname Muroya
// CONTACT: info@avatify.com
// this is an opensource project, under the licencing terms of GNU, MIT

A_hoch = [[], [], [], [], [210, 297], [148, 210],  [105, 140],  [74, 105], [74, 105]];
                                                        // 148
A_quer = [[], [], [], [],[297,210], [210, 148], [148, 105], [105, 74], [85, 55]];
numZahn = 7;    //anzahl der verzahnung = größe der verzahung,
$fn = 50;
//-----------------------------------
// Config für Andi

flyerFlaeche = A_hoch[5];
flyerExtrusion = 20; // how much flyers it has to contain in mm
flyerAngle = 10; // degrees
platteDicke = 3; // dicke der Platte in mm
kerf = -0.11; //mm, for pressfit
frontHeight = 0.4; // percent in decimal -> 0.5

cutOffset = 0.6; // moving for cutting
shouldStand = 1;    // with the circular stand

frontFrame = 15; // to be able to see at the flyers
//-----------------------------------



module toothwork(kanteLaenge,begin){
    toothLength = kanteLaenge/numZahn; // odd numbers
    //echo(toothLength);
    numTooth = kanteLaenge/toothLength;
    translate([(-toothLength) *begin,0]){
       for (i=[begin:numTooth/2]) {
               translate([ toothLength*i*2 - kerf/2*begin,0]) square([toothLength + kerf*begin, platteDicke - kerf/2]);
       }
    }
}

module front(area, isBack){
   size = [area[0] + platteDicke*3, area[1]];
  
   difference(){
      square(size);
      if(isBack){
         translate([0, area[1] * frontHeight]) square(size); 
         translate([frontFrame*1.5 + platteDicke/6, area[1] /8]){
             minkowski(){
                circle(d=area[1]/10);
                square([area[0] - frontFrame*2 - platteDicke*2, area[1]*frontHeight - frontFrame*2]); 
            }
        }
        /*
       translate([0,-frontFrame]) difference(){
            translate([area[0]/10, area[1] * frontHeight ]) square([area[0]/1.13, area[1]/2.9]); 
            
            translate([area[0] * frontHeight/2 - area[1]/10, area[1] * frontHeight]) circle(d=area[1]/10);
            translate([area[0]*0.7 +  area[1]/5, area[1] * frontHeight]) circle(d=area[1]/10);
        }
        */
      } else if(shouldStand == 0){
            translate([size[0]/2 - 20, size[1] - 20]) circle(d=5);
            translate([size[0]/2 + 20, size[1] - 20]) circle(d=5);
      }
      
      translate([0,-0])                         toothwork(size[0],1); // bottom
      translate([platteDicke ,0])   rotate(90)  toothwork(size[1] * frontHeight,1); // left
      translate([size[0],0])        rotate(90)  toothwork(size[1] * frontHeight,1); // right
      //translate([0,size[1] - platteDicke ])     toothwork(size[0],1); // top
   }
}
//front(flyerFlaeche, 1); // front
//front(flyerFlaeche, 0);

module halfCircle(diameter){
    difference(){
        circle(d=diameter);
        translate([0,-diameter/2]) square(diameter,center=true);
    }
}
//halfCircle(10);

module side(area){
    size = [flyerExtrusion, area[1]*frontHeight];
    difference(){
      union(){
        square(size);
        if(shouldStand){
            translate([size[1]/4, -size[1]/20]) rotate(flyerAngle) halfCircle(area[1]*0.7);
        }
      }
      translate([0,-0.1])                               toothwork(size[0],0);
      translate([platteDicke + 0.1,0])  rotate(90)      toothwork(size[1],0);
      translate([size[0],0])        rotate(90)          toothwork(size[1],0);
      //translate([0,size[1] - platteDicke + 0.1])        toothwork(size[0],0);
   }
}

//side(flyerFlaeche);

module base(area){
   size = [area[0] + platteDicke*3,flyerExtrusion];
   difference(){
      square(size);
      translate([0,-0.1])                           toothwork(size[0],0);
      translate([platteDicke + 0.1,0])  rotate(90)  toothwork(size[1],1);
      translate([size[0],0])            rotate(90)  toothwork(size[1],1);
      translate([0,size[1] - platteDicke + 0.1])    toothwork(size[0],0);
   }
}
//base(flyerFlaeche);


module toCut(){
    front(flyerFlaeche, 1);
    translate([0, -flyerFlaeche[1] - 1]) front(flyerFlaeche, 0);
    translate([ -1, -flyerFlaeche[1]])  rotate(90) base(flyerFlaeche);
    /*
    translate([ flyerFlaeche[0] * cutOffset, -flyerFlaeche[1]/50]){
        rotate(-flyerAngle)side(flyerFlaeche);
        translate([flyerFlaeche[0]/2.5, -flyerFlaeche[1]/4]) rotate(-180 - flyerAngle) side(flyerFlaeche);
    }
    */
    translate([ flyerFlaeche[0]/3 +1 , flyerFlaeche[1]*cutOffset]){
        rotate(-flyerAngle)side(flyerFlaeche);
        translate([flyerFlaeche[0]/3, -flyerFlaeche[1]/13]) rotate(-180 - flyerAngle) side(flyerFlaeche);
    }
}
toCut();