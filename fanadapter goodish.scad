// fan adapter parametric 
hullthick=.44*5;
//flanges=[[0,0,40,0],[-20,-20,80,60],[-10,-20,120,100]]; // [xshift,yshift,size,z]
flanges=[[0,0,40,0],[0,0,80,60]]; // [xshift,yshift,size,z]
platez=2; // flange thickness
sholed=3.5; // screw hole diameter
sholeinset=4; // distance from center of screw hole to edge
fanholemargin=.44*3;// wall thickness at narrowest point from fan circle cutout
straightpipe=.000000001; // length of straight pipe off each flange because openscad sucks
blend=.5; // small flange overhang taper end size
blendheight=20; // small flange overhang taper end height
holedepth=4; // hole depth into overhang taper
difference(){
    union(){// everything on the outer hull and flanges
        for (fan=[0:len(flanges)-2]){ // fan flanges
            translate([flanges[fan][0],flanges[fan][1],flanges[fan][3]])
            //linear_extrude(height=platez)
            difference(){
                hull(){ // taper on smaller hole flange
                    translate([0,0,platez])
                    linear_extrude(height=.2)
                    square([flanges[fan][2],flanges[fan][2]]);
                    translate([flanges[fan][2]*(1-blend)/2,flanges[fan][2]*(1-blend)/2,blendheight])
                    linear_extrude(height=.2)
                    square([flanges[fan][2]*blend,flanges[fan][2]*blend]);
                }
                linear_extrude(height=platez+holedepth) // holes into smaller flange taper
                for(a=[sholeinset,flanges[fan][2]-sholeinset])
                    for (b=[sholeinset,flanges[fan][2]-sholeinset])
                        translate([a,b])
                        circle(d=sholed,$fn=36);
            }
            translate([flanges[fan][0],flanges[fan][1],flanges[fan][3]])// smaller flange
            linear_extrude(height=platez) 
            difference(){
                square([flanges[fan][2],flanges[fan][2]]);
                for(a=[sholeinset,flanges[fan][2]-sholeinset])
                    for (b=[sholeinset,flanges[fan][2]-sholeinset])
                        translate([a,b])
                        circle(d=sholed,$fn=36);
            }
            translate([flanges[fan+1][0],flanges[fan+1][1],flanges[fan+1][3]])// larger flange
            linear_extrude(height=platez)
            difference(){
                square([flanges[fan+1][2],flanges[fan+1][2]]);
                for(a=[sholeinset,flanges[fan+1][2]-sholeinset])
                    for (b=[sholeinset,flanges[fan+1][2]-sholeinset])
                        translate([a,b])
                        circle(d=sholed,$fn=36);
            }
        }
        for (fan=[0:len(flanges)-2]){ // outer wall of main taper
            hull(){
                translate([flanges[fan][0],flanges[fan][1],flanges[fan][3]+platez]) // shift to top of bottom flange
                linear_extrude(height=straightpipe)
                difference(){
                    translate([flanges[fan][2]/2,flanges[fan][2]/2])
                    circle(d=(flanges[fan][2]-fanholemargin*2)+hullthick,$fn=360);
                };
                translate([flanges[fan+1][0],flanges[fan+1][1],flanges[fan+1][3]]) // goto bottom of top flange
                linear_extrude(height=straightpipe)
                difference(){
                    translate([flanges[fan+1][2]/2,flanges[fan+1][2]/2])
                    circle(d=(flanges[fan+1][2]-fanholemargin*2)+hullthick,$fn=360);
                }
            }
        };
    };
    //cut to form the inner wall
    for (fan=[0:len(flanges)-2]){ // inner wall
        hull(){
            translate([flanges[fan][0],flanges[fan][1],flanges[fan][3]+platez])
            linear_extrude(height=straightpipe)
            difference(){
                translate([flanges[fan][2]/2,flanges[fan][2]/2])
                circle(d=flanges[fan][2]-fanholemargin*2,$fn=360);
            };
            translate([flanges[fan+1][0],flanges[fan+1][1],flanges[fan+1][3]])
            linear_extrude(height=straightpipe)
            difference(){
                translate([flanges[fan+1][2]/2,flanges[fan+1][2]/2])
                circle(d=flanges[fan+1][2]-fanholemargin*2,$fn=360);
            }
        }
    };
    for (fan=[0:len(flanges)-1]){ // cut the final top and bottom holes again because of float errors
        translate([flanges[fan][0],flanges[fan][1],flanges[fan][3]-.1])
        linear_extrude(height=platez+.2)
        translate([flanges[fan][2]/2,flanges[fan][2]/2])
        circle(d=flanges[fan][2]-fanholemargin*2,$fn=360);

    }
}