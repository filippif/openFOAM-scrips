// Gmsh project created on Fri Jul 12 21:12:05 2024
SetFactory("OpenCASCADE");

// Input
//---------------------------------------

Mesh_Start = 1;             // 0: Dont Mesh, 1: Mesh
Mesh_Elements_Order = 1;    // 1: P1, 2: P2

// Geometry
//---------------------------------------
//+
// parameters
ld = DefineNumber[9, Name "Parameters/ld" ];  // ellipse longer radius
re = DefineNumber[ 3, Name "Parameters/re" ]; // ellipse shorter radius
rt = DefineNumber[ 0.1, Name "Parameters/rt" ];  // throat radius
li = DefineNumber[ 3, Name "Parameters/li" ]; // entance distance
ri = DefineNumber[ 1.0, Name "Parameters/ri" ]; // entrance radius

// points

Point(1) = {0, 0, 0, 1.0};
Point(2) = {ri, 0, 0, 1.0};
Point(3) = {rt, li, 0, 1.0};
Point(4) = {re, li+ld, 0, 1.0};
Point(5) = {5, li+ld, 0, 1.0};
Point(6) = {6, li+ld-0.01, 0, 1.0};
Point(7) = {10, li+ld-0.01, 0, 1.0};
Point(8) = {10, li+ld+20, 0, 1.0};
// find the centre of the ellipse
Point(9) = {0,  li + ld, 0, 1.0};

// mirror the geometry
out[] = Symmetry {1, 0, 0, 0} {
  Duplicata { Point{1}; Point{2}; Point{3}; Point{4}; Point{5}; Point{6}; Point{7}; Point{8}; Point{9};}
};

//
// Define the lines

Line(1) = {2, 3};
Ellipse(2) = {3, 9, 1, 4};
Line(3) = {4, 5};
Line(4) = {5, 6};
Line(5) = {6, 7};
Line(6) = {7, 8};
Line(7) = {8, out[7]};
Line(8) = {17, 16};
Line(9) = {16, 15};
Line(10) = {15, 14};
Line(11) = {14, 13};
Ellipse(12) = {13, 9, 1, 12};
Line(13) = {12, 11};
Line(14) = {11, 2};

//
//+ define some points to increase the mesh resolution
//
//+
Point(90) = {0, li+ld+2, 0, 0.1};
Point(91) = {0, li+ld+4, 0, 0.1};
Point(92) = {0, li+ld+6, 0, 0.1};
Point(93) = {0, li+ld+8, 0, 0.1};
Point(94) = {0, li+ld+10, 0, 0.1};
Point(95) = {0, li+ld+12, 0, 0.1};
Point(96) = {-(re + 2), li+ld+2, 0, 0.1};
Point(97) = {-(re + 2), li+ld+4, 0, 0.1};
Point(98) = {-(re + 2), li+ld+6, 0, 0.1};
Point(99) = {-(re + 2), li+ld+8, 0, 0.1};
Point(100) = {-(re + 2), li+ld+10, 0, 0.1};
Point(101) = {-(re + 2), li+ld+12, 0, 0.1};
Point(102) = {(re + 2), li+ld+2, 0, 0.1};
Point(103) = {(re + 2), li+ld+4, 0, 0.1};
Point(104) = {(re + 2), li+ld+6, 0, 0.1};
Point(105) = {(re + 2), li+ld+8, 0, 0.1};
Point(106) = {(re + 2), li+ld+10, 0, 0.1};
Point(107) = {(re + 2), li+ld+12, 0, 0.1};
Point(108) = {0, li+ld+14, 0, 0.1};
Point(109) = {-(re + 2), li+ld+14, 0, 0.1};
Point(110) = {(re + 2), li+ld+14, 0, 0.1};
Point(111) = {0, li+ld+16, 0, 0.1};
Point(112) = {-(re + 2), li+ld+16, 0, 0.1};
Point(113) = {(re + 2), li+ld+16, 0, 0.1};
Point(114) = {0, li+ld+16, 0, 0.1};
Point(115) = {-(re + 2), li+ld+16, 0, 0.1};
Point(116) = {(re + 2), li+ld+16, 0, 0.1};


//+
// curve loops
//
Curve Loop(1) = {11, 12, 13, 14, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
//+
Plane Surface(1) = {1};
Point{90} In Surface{1};
Point{91} In Surface{1};
Point{92} In Surface{1};
Point{93} In Surface{1};
Point{94} In Surface{1};
Point{95} In Surface{1};
Point{96} In Surface{1};
Point{97} In Surface{1};
Point{98} In Surface{1};
Point{99} In Surface{1};
Point{100} In Surface{1};
Point{101} In Surface{1};
Point{102} In Surface{1};
Point{103} In Surface{1};
Point{104} In Surface{1};
Point{105} In Surface{1};
Point{106} In Surface{1};
Point{107} In Surface{1};
Point{108} In Surface{1};
Point{109} In Surface{1};
Point{110} In Surface{1};
Point{111} In Surface{1};
Point{112} In Surface{1};
Point{113} In Surface{1};

//+
MeshSize {1, out[1], out[2], 2} = rt;
MeshSize {out[3], 4} = rt*2;
MeshSize {3, 12} = rt/25;
MeshSize {90, 91, 92, 93, 94, 95} = rt*2;
MeshSize {96, 97, 98, 99, 100, 101} = rt*4;
MeshSize {102, 103, 104, 105, 106, 107} = rt*4;
MeshSize {108, 109, 110, 111, 112, 113, 114, 115, 116} = rt*4;

//+
// extrude geometry to have 3d 
//+

Extrude {0, 0, 1} {
  Surface{1}; 
  Layers{1};
  Recombine;
}

//+
// define surfaces and volumes
//
Physical Surface("inlet",1) = {5};
Physical Surface("outlet",2) = {10, 11, 12, 13, 14};
Physical Surface("gasjet",3) = {15, 2, 3, 4, 6, 7, 8, 9};
Physical Surface("back",4) = {1};
Physical Surface("front", 5) = {16};
Physical Volume("internal",6) = {1};

//
// do mesh 

If (Mesh_Start)

  Mesh.MshFileVersion = 2.2;
  Mesh.SaveAll = 0;
  Mesh.SaveElementTagType = 2;
  Mesh.ElementOrder = 1; // 1: P1, 2: P2
  Mesh 3;

  Save "PWBell.msh";
  Save "PWBell.vtk";
EndIf


