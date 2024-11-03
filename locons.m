
% function locons: defines boundary conditions (loads and constraints)

function [nCons,dC,nForce,dF,dpq_const,dpq_var]=locons

% Load matrix dF: 
% the i-th row of dF collects the number of the loaded node, the number of
% the loaded degree of freedom and the load intensity.
% dF(i,1)=node number;
% dF(i,2)=loaded dof;
% dF(i,3)=load intensity;
%Student ID NUMBER
Matrico=[2 2 0 4 6 1]; 

% a=Matrico(1); b=Matrico(2); 

c=Matrico(3); d=Matrico(4); e=Matrico(5); f=Matrico(6);

h1=(2.9+0.05*d); h2=2.8; h3=1.4;
l1=(5.6+0.1*f); l2=(3.75-0.05*e); lc=1;
alfa=35*pi/180;

%Concentrated Loads Qenv1 and Qenv2 and 16 KN/m is equal to 16 N/mm
  dF=[4, 11, -16*(h2);  %KN
      7, 20, -16*(h3); %KN
      8, 23, -16*(h3); %KN
      6,  17, -16*(h2)]; %KN

  nForce=size(dF,1);  % nForce=total number of applied loads

% Constraint matrix dC: 
% the k-th row in dC collects the number of the constrained node, the
% number of the constrained degree of freedom and the magnitude of the
% imposed displacement.
% dC(k,1)=node number;
% dC(k,2)=constrained dof;
% dC(k,3)=magnitude of the imposed displacement;
  dC=[ 1,1,0;
       1,2,0;
       1,3,0;
       2,4,0;
       2,5,0;
       2,6,0;
       3,7,0;
       3,8,0;
       3,9,0];

  nCons=size(dC,1);  % nCons=total number of constrained dofs

%%%%%%%%%%%%%%%%%%% MODIFIED PART OF MATLAB CODE %%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. dpq_const= [iElem , p , q];
%       iElem : Element Number
%       p     : Uniform Distributed Load along the Beam Axis
%       q     : Uniform Transversal Distributed Load
% If no Constant Dist. Loads: dpq_const=[0];
% KN/m 

% dpq_const=  [1,  0,    0;
%              2,  0,    -3*((h1)/(h1+h2+h3));
%              3,  0,    -3*((h1+h2)/(h1+h2+h3));
%              4,  0,    0;
%              5,  0,    0;
%              6,  0,    -6*((h1+h2)/(h1+h2+h3));
%              7,  0,    0;
%              8,  0,    -6*((h1)/(h1+h2+h3)); 
%              9,  0,   -25;
%              10, 0,   -20;
%              11, 0,     0;
%              12, 0, -(8+5);
%              13,-sin(alfa)*(cos(alfa)*12.5), -cos(alfa)*(cos(alfa)*12.5);
%              14,-sin(alfa)*(cos(alfa)*12.5), -cos(alfa)*(cos(alfa)*12.5);
%              15, +sin(alfa)*(cos(alfa)*12.5), -cos(alfa)*(cos(alfa)*12.5);
%              16, 0,    0;
%              17, 0,    0;
%              18, 0,    0;
%              19, 0,    0];
dpq_const=  [1,  0,    0;
             2,  0,    0;
             3,  0,    0;
             4,  0,    0;
             5,  0,    0;
             6,  0,    0;
             7,  0,    0;
             8,  0,    0;
             9,-sin(alfa)*(cos(alfa)*12.5), -cos(alfa)*(cos(alfa)*12.5);
             10, +sin(alfa)*(cos(alfa)*12.5), -cos(alfa)*(cos(alfa)*12.5);
             11, 0,   -20;
             12, 0, -(8+5);
             13,  0,   -25;
             14, 0,     0;
             15,-sin(alfa)*(cos(alfa)*12.5), -cos(alfa)*(cos(alfa)*12.5);
             16, 0,    0;
             17, 0,    0;
             18, 0,    0;
             19, 0,    0];
% 2. dpq_var= [iElem , p(x) , q(x)]; 
%       iElem : Element Number
%       p(x)  : Variable Distributed Load along the Beam Axis
%       q(x)  : Variable Transversal Distributed Load
% Note: x -> starts from "Node 1" to "Node 2" of element as defined in "geotop.m"
% If no Variable Dist. Loads: dpq_var=[0];

syms x
dpq_var=  [1, 0, 3*((x)/(h1+h2+h3));
           2, 0, 0;
           3, 0, 6*((x)/(h1+h2+h3));
           4, 0, 3*((x+h1)/(h1+h2+h3));
           5, 0, 0;
           6, 0, 6*((x+h1)/(h1+h2+h3)); 
           7, 0, 3*((x+h1+h2)/(h1+h2+h3)); 
           8, 0, 6*((x+h1+h2)/(h1+h2+h3)); 
           9, 0, 0;
           10, 0, 0;
           11, 0, 0;
           12, 0, 0;
           13, 0,  0;
           14, 0, 0;
           15, 0, 0; 
           16, 0, 0;
           17, 0, 0;
           18, 0, 0;
           19, 0, 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%