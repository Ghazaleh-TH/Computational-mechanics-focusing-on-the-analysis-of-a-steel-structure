
% function stiffm: generates the stiffness matrix for each element

function [dKne]=stiffm(dXY12,dParne)

% Element length
% dXn1=dXY12(1,1);
% dYn1=dXY12(1,2);
% dXn2=dXY12(2,1);
% dYn2=dXY12(2,2);
% dLne=sqrt((dXn2-dXn1)^2+(dYn2-dYn1)^2);
% All together: 
  dLne=norm(dXY12(2,:)-dXY12(1,:),2);

% Cosine and Sine of the beam inclination angle
% dCne=(dXn2-dXn1)/dLne;
% dSne=(dYn2-dYn1)/dLne;
% dCSne=[dCne,dSne];
% All together: 
  dCSne=(dXY12(2,:)-dXY12(1,:))/dLne;

% Stiffness matrix
  dEne=dParne(1);
  dAne=dParne(2);
  dIne=dParne(3);

  dKne=(dEne*dAne/dLne)*[ 1,0,0,-1,0,0;
                          0,0,0, 0,0,0;
                          0,0,0, 0,0,0;
                         -1,0,0, 1,0,0;
                          0,0,0, 0,0,0;
                          0,0,0, 0,0,0];

  dKne=dKne+(12*dEne*dIne/dLne^3)*[0, 0,0,0, 0,0;
                                   0, 1,0,0,-1,0;
                                   0, 0,0,0, 0,0;
                                   0, 0,0,0, 0,0;
                                   0,-1,0,0, 1,0;
                                   0, 0,0,0, 0,0];

  dKne=dKne+(6*dEne*dIne/dLne^2)*[0,0, 0,0, 0, 0;
                                  0,0, 1,0, 0, 1;
                                  0,1, 0,0,-1, 0;
                                  0,0, 0,0, 0, 0;
                                  0,0,-1,0, 0,-1;
                                  0,1, 0,0,-1, 0];

  dKne=dKne+(4*dEne*dIne/dLne)*[0,0,0,0,0,0;
                                0,0,0,0,0,0;
                                0,0,1,0,0,0;
                                0,0,0,0,0,0;
                                0,0,0,0,0,0;
                                0,0,0,0,0,1];

  dKne=dKne+(2*dEne*dIne/dLne)*[0,0,0,0,0,0;
                                0,0,0,0,0,0;
                                0,0,0,0,0,1;
                                0,0,0,0,0,0;
                                0,0,0,0,0,0;
                                0,0,1,0,0,0];

% Rotation matrix
  dQne=zeros([6,6]);
  dQne(1:2,1)=dCSne';
  dQne(1:2,2)=[0,-1;1,0]*dCSne';
  dQne(3,3)=1;
  dQne(4:6,4:6)=dQne(1:3,1:3);
   
% Projection in the global system
  dKne=dQne*dKne*dQne';

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%