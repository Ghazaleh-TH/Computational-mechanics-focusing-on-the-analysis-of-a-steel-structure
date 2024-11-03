
% function assilc: assigns boundary conditions (nodal loads and constraints)

function [nUs,dUs,nUu,dT,Equ_Nod_elem_Global,Equ_Nod_elem_Local,dT_eq]=assilc(nForce,dF,dC,nDofTot,dpq_const,dpq_var,Leng_Elem,nInc,dXY)

% Constrained displacements
% nUs=zeros([nCons,1]);
% dUs=zeros([nCons,1]);
% for nc=1:nCons
%   nn=dC(nc,1); % Number of constrained node 
%   nk=dC(nc,2); % Constrained dof
%   nUs(nc,1)=nk; % Collects the constrained dof in vector nUs
%   dUs(nc,1)=dC(nc,3); % (Settlements) Collects the imposed displacement in vector dUs
% end
% All together:
  nUs=dC(:,2);
  dUs=dC(:,3);

% Sorts constrained dofs and corresponding imposed displacements
  [nUs,nI]=sort(nUs);
  dUs=dUs(nI,1);

% Free (unconstrained) dofs
  nUu=(1:nDofTot)';
  nUu(nUs)=[];

% Known terms in the unconstrained structures
  dT=zeros([nDofTot,1]);

% Collect force components in vector dT
 for nf=1:nForce
   % nn=dF(nf,1);               % Number of loaded node 
   ni=dF(nf,2);                 % Loaded dof
   dT(ni,1)=dT(ni,1)+dF(nf,3);  % Load intensity
 end
 
% ....:::: Calculation of Equivalent Nodal Forces for Each Memebr :::....

%     Equ_Nod_elem_Local(ni,:) =[iElem, H1, V1, W1, H2, V2, W2] in Local Reference System
%     Equ_Nod_elem_Global(ni,:)=[iElem, H1, V1, W1, H2, V2, W2] in Global Reference System
%     dT_eq(i,1) : Summation of Subjected Global Equivalent Nodal Forces to i-th dof
%
nElem=size(Leng_Elem,2);

Equ_Nod_elem_Local=zeros(nElem,7);
Equ_Nod_elem_Local(:,1)=1:nElem;
Equ_Nod_elem_Global=Equ_Nod_elem_Local;
dT_eq=zeros(nDofTot,1);

for ni=1:nElem
    
    % 1. Contribution of Unifrom Distributed Load
    if dpq_const(1,1)~=0
        
        % 1.1. Axial Contribution
        Equ_Nod_elem_Local(ni,[2,5])=dpq_const(ni,2)*Leng_Elem(ni)/2; % pl/2

        % 1.2. Bending Contribution
        Equ_Nod_elem_Local(ni,[3,6])=dpq_const(ni,3)*Leng_Elem(ni)/2; % ql/2
        
        Equ_Nod_elem_Local(ni,4)=dpq_const(ni,3)*(Leng_Elem(ni)^2)/12; %ql^2/12
        Equ_Nod_elem_Local(ni,7)= -Equ_Nod_elem_Local(ni,4);
    end
    
    % 2. Contribution of Variable Distributed Load
    if dpq_var(1,1)~=0
        
        syms x l
        % 2.1. Axial Contribution Contibution
        % Shape funcs. u(x): [Lu1 ; Lu2]
        Shape_funcs_axial=[1-x/l;
                           x/l];
        multip_pu=dpq_var(ni,2)*Shape_funcs_axial;
        int_pu=int(multip_pu,x); % Symbolic: integral (p(x) * u(x)) dx
        
        Equ_Nod_elem_Local(ni,2)=Equ_Nod_elem_Local(ni,2)...
            +(subs(int_pu(1),[x,l],[Leng_Elem(ni),Leng_Elem(ni)])-subs(int_pu(1),[x,l],[0,Leng_Elem(ni)]));
        Equ_Nod_elem_Local(ni,5)=Equ_Nod_elem_Local(ni,2)...
            +(subs(int_pu(2),[x,l],[Leng_Elem(ni),Leng_Elem(ni)])-subs(int_pu(2),[x,l],[0,Leng_Elem(ni)]));
        
        % 2.2. Bending Contibution
        % Shape funcs. v(x): [Lv1 ; Lphi1 ; Lv2 ; Lphi2]
        shape_funcs_bend=[(2*(x^3)/(l^3))-(3*(x^2)/(l^2))+1 ;
                          ((x^3)/(l^2))-(2*(x^2)/l)+x ;
                         -(2*(x^3)/(l^3))+(3*(x^2)/(l^2)) ;
                          ((x^3)/(l^2))-((x^2)/l)];
        multip_qv=dpq_var(ni,3)*shape_funcs_bend;
        int_qv=int(multip_qv,x); % Symbolic: integral (q(x) * v(x)) dx
        
        Equ_Nod_elem_Local(ni,3)=Equ_Nod_elem_Local(ni,3)...
            +(subs(int_qv(1),[x,l],[Leng_Elem(ni),Leng_Elem(ni)])-subs(int_qv(1),[x,l],[0,Leng_Elem(ni)]));
        Equ_Nod_elem_Local(ni,4)=Equ_Nod_elem_Local(ni,4)...
            +(subs(int_qv(2),[x,l],[Leng_Elem(ni),Leng_Elem(ni)])-subs(int_qv(2),[x,l],[0,Leng_Elem(ni)]));
        
        Equ_Nod_elem_Local(ni,6)=Equ_Nod_elem_Local(ni,6)...
            +(subs(int_qv(3),[x,l],[Leng_Elem(ni),Leng_Elem(ni)])-subs(int_qv(3),[x,l],[0,Leng_Elem(ni)]));
        Equ_Nod_elem_Local(ni,7)=Equ_Nod_elem_Local(ni,7)...
            +(subs(int_qv(4),[x,l],[Leng_Elem(ni),Leng_Elem(ni)])-subs(int_qv(4),[x,l],[0,Leng_Elem(ni)]));
    end

    % 3. Projection from Local to Global System 
    n12=nInc(ni,1:2); % Recovering Nodes of element
    dXY12=dXY(n12,:); % and their Coordinates
    dCSne=(dXY12(2,:)-dXY12(1,:))/Leng_Elem(ni); % Cosine and Sine of inclination of Element

    dQne=zeros([6,6]); % Initializing Rotation Matrix
    dQne(1:2,1)=dCSne';
    dQne(1:2,2)=[0,-1;1,0]*dCSne';
    dQne(3,3)=1;
    dQne(4:6,4:6)=dQne(1:3,1:3);
    
    Equ_Nod_elem_Global(ni,2:7)=(dQne*Equ_Nod_elem_Local(ni,2:7)')';

    % 4. Assigning Equivalent Nodal Forces to corresponding dof in dT_eq
    idof=nInc(ni,3:end)'; % Recovering dof of Element
    dT_eq(idof)=dT_eq(idof)+Equ_Nod_elem_Global(ni,2:7)';
end

dT=dT+dT_eq;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%