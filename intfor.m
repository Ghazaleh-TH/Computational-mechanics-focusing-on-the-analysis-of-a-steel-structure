
% function intfor: evaluates internal forces in the elements

function [dNVM]=intfor(nElem,nInc,dXY,dPar,du,Equ_Nod_elem_Local)

% Matrix of internal forces; sign conventions:
% N: positive if traction
% V: positive if clockwise
% M: positive if bending fibers on the right side from node n1 to node n2
  dNVM=zeros([nElem,6]);
  
 for ne=1:nElem
     % Nodes of the ne-th element
       n12=nInc(ne,1:2);

     % Nodal Coordinates of the ne-th element
       dXY12=dXY(n12,:);

     % Length of the ne-th element
       dLne=norm(dXY12(2,:)-dXY12(1,:),2);

     % Cosine & Sine of the ne-th element inclination angle
       dCSne=(dXY12(2,:)-dXY12(1,:))/dLne;

     % Parameters of the ne-th element
       dParne=dPar(ne,:);

     % Stiffness matrix dKne for the ne-th element
       [dKne]=stiffm(dXY12,dParne);

     % Dofs relevant to the ne-th element
       nVne=nInc(ne,3:8);

     % Nodal displacement for the ne-th element
       dUne=du(nVne,1);

     % Nodal forces in the ne-th element
       dQne=zeros([6,6]);
       dQne(1:2,1)=dCSne';
       dQne(1:2,2)=[0,-1;1,0]*dCSne';
       dQne(3,3)=1;
       dQne(4:6,4:6)=dQne(1:3,1:3);
       dFne=dKne*dUne;

     % Internal forces (N, V, M) at nodes of the ne-th element
       dNVM(ne,:)=(dQne'*dFne)'-Equ_Nod_elem_Local(ne,2:end);
       dNVM(ne,[1,3,5])=-dNVM(ne,[1,3,5]);
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%