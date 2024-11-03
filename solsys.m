
% function solsys: solves the equation system

function [du,dR]=solsys(dK,dT,nUu,nUs,dUs,nDofTot)

% Sub-matrices in the solving system
% Partitioning the global Stiffness Matrix dK
  dKuu=dK(nUu,nUu);
  dKus=dK(nUu,nUs);
  dKsu=dK(nUs,nUu);
  dKss=dK(nUs,nUs);

% Partitioning known terms collected by vector dT
  dTu=dT(nUu,1);
  dTs=dT(nUs,1);

% Solution 
% Computing unknown displacements 
  dUu=dKuu\(dTu-dKus*dUs);

% Computing reaction forces
  dRs=dKsu*dUu+dKss*dUs-dTs;

% Recovering nodal displacements following the original dof numbering
  du=zeros([nDofTot,1]);
  du(nUu,1)=dUu;
  du(nUs,1)=dUs;

% Recovering reaction forces in the original dof numbering
  dR=zeros([nDofTot,1]);
  dR(nUs,1)=dRs;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%