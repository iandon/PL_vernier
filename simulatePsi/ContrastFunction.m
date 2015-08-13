function [dPrime]   =   ContrastFunction(initials, contr)

DPmax    =   initials(1);    %asymptote (max d prime from data)
n       =   initials(2);    %initial slope
C50     =   initials(3);    %initial contrast threshold 

dPrime  =   (DPmax * (contr.^n)) ./ ((contr.^n) + C50.^n); 
