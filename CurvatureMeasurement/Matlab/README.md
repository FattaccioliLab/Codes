# MechanicalStressOfImmuneCells

There are 2 files to use to measure the mechanical stress :
1- ComputeCurvature_multiple.m
This file computes the analytical curvature from the (x,y) data and (x,y) centroid measured with the BIG ESnake routine
Sample data are in this directory : ./Image_18-4_ROI_Coordinates/
2- ComputeStress_v2.m
This routine takes the interfacial tension as parameter, and two curvature files (one resting and one constrained)
It saves several graphs.
