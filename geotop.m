
% function geotop: defines geometry and topology data

function [nInc,nElem,dXY,nNode,Leng_Elem,l1]=geotop

% Matrix of the nodal coordinates dXY:
% the n-th row in dXY collects the nodal coordinates of n-th node 
% dXY(n,:)=[x coordinate of n-th node, y coordinate of n-th node]
Matrico=[2 2 0 4 6 1]; 

% a=Matrico(1); b=Matrico(2); 

c=Matrico(3); d=Matrico(4); e=Matrico(5); f=Matrico(6);

h1=(2.9+0.05*d); h2=2.8; h3=1.4;
l1=(5.6+0.1*f); l2=(3.75-0.05*e); lc=1;
alfa=35*pi/180;


  dXY=[     0,               0;%1
            l1,              0;%2
            l1+l2,           0;%3
            0,               h1;%4
            l1,              h1;%5
            l1+l2,           h1;%6
            0,               h1+h2;%7
            l1,              h1+h2;%8
            l1+l2,           h1+h2;%9
            -lc,             h1+h2+h3-(tan(alfa)*lc);%10
            0,               h1+h2+h3;%11
            l1/2,            h1+h2+h3+(tan(alfa)*(l1/2));%12
            l1,              h1+h2+h3;]%13


% Total number of nodes
  nNode=size(dXY,1);   

% Connection matrix nInc:
% the ne-th row of nInc contains the node numbers at the ne-th beam and the 
% corresponding dofs
% nInc(ne,:)=[n1, n2, n1u, n1v, n1f, n2u, n2v, n2f] 
  nInc=[1, 4, 1,2,3,10,11,12;%1%
        2, 5, 4,5,6,13,14,15;%2%
        3, 6, 7,8,9,16,17,18;%3%
        4, 7, 10,11,12,19,20,21;%4
        5, 8, 13,14,15,22,23,24;%5%
        6, 9, 16,17,18,25,26,27;%6%
        7, 11, 19,20,21,31,32,33;%7%
        8, 13, 22,23,24,37,38,39;%8%
        11, 12, 31,32,33,34,35,36;%9%
        12, 13, 34,35,36,37,38,39;%10%
        7, 8, 19,20,21,22,23,24;%11%
        8, 9, 22,23,43,25,26,42;%12%
        4, 5, 10,11,12,13,14,15;%13%
        5, 6, 13,14,41,16,17,40;%14%
        10, 11, 28,29,30,31,32,33;%15%
        5, 9, 13,14,48,25,26,49;%16%
        8, 6, 22,23,50,16,17,51;%17%
        2, 6, 4,5,44,16,17,45;%18%
        5, 3, 13,14,47,7,8,46;%19%
        ];
% nInc=[1, 2, 1,2,3,4,5,6;%1%
%         2, 3, 4,5,6,7,8,9;%2%
%         3, 5, 7,8,9,13,14,15;%3%
%         7, 8, 44,45,46,32,33,34;%4
%         8, 9, 32,33,34,22,23,24;%5%
%         9, 10, 22,23,24,19,20,21;%6%
%         11, 12, 48,49,50,38,39,40;%7%
%         12, 13, 38,39,40,27,28,29;%8%
%         2, 8, 4,5,6,32,33,34;%9%
%         3, 9, 7,8,9,22,23,24;%10%
%         8, 12, 32,33,36,38,39,42;%11%
%         9, 13, 22,23,25,27,28,30;%12%
%         4, 5, 10,11,12,13,14,15;%13%
%         5, 6, 13,14,15,16,17,18;%14%
%         6, 10, 16,17,18,19,20,21;%15%
%         9, 12, 22,23,26,38,39,41;%16%
%         8, 13, 32,33,35,27,28,31;%17%
%         8, 11, 32,33,37,48,49,51;%18%
%         7, 12, 44,45,47,38,39,43;%19%
%         ];

% Total number of beams
  nElem=size(nInc,1);  

  % Calculation of Length of each element
  Leng_Elem=zeros(1,nElem);
  for nnn=1:nElem
      Leng_Elem(nnn)=sqrt((dXY(nInc(nnn,2),2)-dXY(nInc(nnn,1),2))^2+(dXY(nInc(nnn,2),1)-dXY(nInc(nnn,1),1))^2);
  end

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%