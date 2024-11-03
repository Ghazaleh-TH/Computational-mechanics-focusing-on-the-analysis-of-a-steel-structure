%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              frame2DSt.m                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                       2D static analysis of frames                      %
%                                                                         %
%                            Giuseppe COCCHETTI                           %
%                                                                         %
%                            version 17/12/2010                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       THIS SOFTWARE IS TO BE USED FOR LEARNING PURPOSES ONLY            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is made of a core routine transferring data to the following  %
% functions:                                                              %
%  - geotop: defines geometry and topology data;                          %
%  - mecpar: defines mechanical parameters;                               %
%  - locons: defines boundary conditions (loads and constraints);         %
%  - stiffm: generates the stiffness matrix for each element;             %
%  - assilc: assigns boundary conditions (nodal loads and constraints);   %
%  - solsys: solves the equation system                                   %
%  - intfor: evaluates internal forces in the elements;                   %
%  - crefig: creates the window of a figure;                              %
%  - nodeconf: displays the nodes of the structure;                       %
%  - membconf: displays the structural members;                           %
%  - maxdispl: defines the maximum displacement of the structure;         %
%  - iforconf: displays internal forces diagrams;                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp('Static analysis of plane (2D) frames')
clear
format short e


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT: acquisition of the structural data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Geometry and topology data
  [nInc,nElem,dXY,nNode,Leng_Elem,l1]=geotop;

% Mechanical parameters
  [dPar,slender_el,section_height]=mecpar(Leng_Elem,nElem);

% Boundary conditions: loads and constraints
  [nCons,dC,nForce,dF,dpq_const,dpq_var]=locons;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting up the solving system %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Total number of dofs (before imposing boundary conditions)
  nDofTot=max(max(nInc(:,3:8)));

% Global stiffness matrix
  dK=zeros([nDofTot,nDofTot]); 

% Set up and assembly of the stiffness matrix of each beam element
  for ne=1:nElem
      % Numbers of the nodes of the ne-th element
      % n1=nInc(ne,1);  % First node of the ne-th beam
      % n2=nInc(ne,2);  % Second node of the ne-th beam
      % n12=[n1,n2];
      % All together: 
        n12=nInc(ne,1:2);

      % Coordinates of the nodes of the ne-th element
      % dXn1=dXY(n1,1);
      % dYn1=dXY(n1,2);
      % dXn2=dXY(n2,1);
      % dYn2=dXY(n2,2);
      % dXY12=[dXn1,dYn1; 
      %        dXn2,dYn2];
      % All together: 
        dXY12=dXY(n12,:);

      % Parameters of the ne-th element
      % dEne=dPar(ne,1);  % Young modulus of the material of the ne-th beam
      % dAne=dPar(ne,2);  % Area of the cross section of the ne-th beam
      % dIne=dPar(ne,3);  % Moment of inertia of the cross section of the ne-th beam
      % All together: 
        dParne=dPar(ne,:);

      % Stiffness matrix dKne for the ne-th beam element
        [dKne]=stiffm(dXY12,dParne);

      % Assembly of the overall stiffness matrix
        nVne=nInc(ne,3:8);                  % Recovers the dofs of the ne-th element
        dK(nVne,nVne)=dK(nVne,nVne)+dKne;   % Global stiffness matrix dK; element stiffness matrix dKne
 end

% Boundary conditions: nodal constraints and loads 
  [nUs,dUs,nUu,dT,Equ_Nod_elem_Global,Equ_Nod_elem_Local,dT_eq]=assilc(nForce,dF,dC,nDofTot,dpq_const,dpq_var,Leng_Elem,nInc,dXY);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT 1: computational results %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Solution of the system   
  [du,dR]=solsys(dK,dT,nUu,nUs,dUs,nDofTot);

% Computation of internal forces 
  [dNVM]=intfor(nElem,nInc,dXY,dPar,du,Equ_Nod_elem_Local);

% Modification of Distribution of Shear and Bending Momemnt
  mesh_num=10000; %only for graphical representation
  [H_Dist,T_Dist,M_Dist,xM_vec] = mod_intfor(mesh_num,nElem,Leng_Elem,dpq_const,dpq_var,dNVM);

% Caculation of Normal Compression Stress in Elements (Axial and Bending Moment Contrib.)
  [sigma_Dist,sigma_elem_max] = mod_HMstress(mesh_num,nElem,M_Dist,H_Dist,section_height,dPar);

  % Equilibrium Check [sigma Fx, sigma Fy, sigma M]
  [Sigma_X,Sigma_Y,Sigma_M] = mod_EquilibCheck(nDofTot,dR,dF,nInc,dXY,Equ_Nod_elem_Global)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUT 2: graphical representation of the computational results %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Characteristic structural dimensions
  dXmin=min(dXY(:,1));
  dXmax=max(dXY(:,1));
  dYmin=min(dXY(:,2));
  dYmax=max(dXY(:,2));
  dimXmax=dXmax-dXmin;
  dimYmax=dYmax-dYmin;

% FIGURE 1: UNDEFORMED STRUCTURE
% New window
% nF=Figure number
% vCoordFig =  horizontal & vertical coordinate (in pixel) of the lower left window corner;
%              horizontal & vertical coordinate (in pixel) of the upper right window corner;
% vCoordAxes = horizontal & vertical coordinate (in pixel) of the lower left figure corner; 
%              horizontal & vertical coordinate (in pixel) of the upper right figure corner;
  vCoordFig=[65 224 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10];
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Structural scheme';
  crefig(1,vCoordFig,vCoordAxes,cTit);

% Node size (N.B.: graphical convention only)
  dr=max(dimXmax,dimYmax)/80;

% Beam label distance
  dt=max(dimXmax,dimYmax)/40;

% Drawing of members
  membconf(nElem,nInc,dXY,du,0,dt,'b-');
  
% Drawing of nodes
  nodeconf(nNode,dXY,dr);

% FIGURE 2: DEFORMED AND UNDEFORMED STRUCTURE
% New window
  vCoordFig=[136 195 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10]; 
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Elastic deformed configuration';
  crefig(2,vCoordFig,vCoordAxes,cTit);

% Amplification factor for the graphical representation of displacements 
  dSmax=max(dimXmax,dimYmax)/30;
  dUmax=maxdispl(nElem,nInc,dXY,du);
  dAmplif=10^ceil(log10(dSmax/dUmax));
  text((dXmin+dXmax)/2,dYmax+dimYmax/12,sprintf('Displ. ampl. fact.: %0.5g',dAmplif))

% Drawing of undeformed structure
  myhandl1=membconf(nElem,nInc,dXY,du,0,dt,'k-');

% Displaced node coordinates (with amplified displacements)
   myhandl2=membconf(nElem,nInc,dXY,du,dAmplif,0,'m--');
   
  legend([myhandl1 myhandl2])
  
% Drawing of the internal force diagrams

% FIGURE 3: AXIAL FORCE DIAGRAM
% New window
  vCoordFig=[193 158 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10]; 
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Axial force';
  crefig(3,vCoordFig,vCoordAxes,cTit);

% Amplification factor for the graphical representation
  dNmax=max([abs(dNVM(:,1)'),abs(dNVM(:,4)')]);
  dSmax=max(dimXmax,dimYmax)/20;

% Drawing of the axial force diagram
  iforconf(nElem,nInc,dXY,dNVM(:,[1,4]),dNmax,dSmax);
 
% FIGURE 4: SHEAR FORCE DIAGRAM
% New window
  vCoordFig=[275 101 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10]; 
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Shear force';
  crefig(4,vCoordFig,vCoordAxes,cTit);

% Amplification factor for the graphical representation
  dVmax=max([abs(dNVM(:,2)'),abs(dNVM(:,5)')]);
  dSmax=max(dimXmax,dimYmax)/20;

% Drawing of the shear force diagram
  iforconf(nElem,nInc,dXY,dNVM(:,[2,5]),dVmax,dSmax); 

% FIGURE 5: BENDING MOMENT DIAGRAM
% New window
  vCoordFig=[378 52 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10]; 
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Bending moment';
  crefig(5,vCoordFig,vCoordAxes,cTit);

% Amplification factor for the graphical representation
  dMmax=max([abs(dNVM(:,3)'),abs(dNVM(:,6)')]);
  dSmax=max(dimXmax,dimYmax)/20;

% Drawing of the bending moment diagram
  iforconf(nElem,nInc,dXY,dNVM(:,[3,6]),dMmax,dSmax);

  
% FIGURE 6: AXIAL FORCE DIAGRAM
% New window
  vCoordFig=[193 158 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10]; 
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Axial Force Diagram';
  crefig(6,vCoordFig,vCoordAxes,cTit);

% Amplification factor for the graphical representation
  dHmax=max(max(abs(H_Dist)));
  dSmax=max(dimXmax,dimYmax)/20;

% Drawing of the axial force diagram
  mod_iforconf(nElem,nInc,dXY,H_Dist,dHmax,dSmax,mesh_num);
 
% FIGURE 7: MODIFIED SHEAR FORCE DIAGRAM
% New window
  vCoordFig=[275 101 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10]; 
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Actual Shear Force Diagram';
  crefig(7,vCoordFig,vCoordAxes,cTit);

% Amplification factor for the graphical representation
  dTmax=max(max(abs(T_Dist)));
  dSmax=max(dimXmax,dimYmax)/20;

% Drawing of the shear force diagram
  mod_iforconf(nElem,nInc,dXY,T_Dist,dTmax,dSmax,mesh_num); 


  % FIGURE 8: MODIFIED BENDING MOMENT DIAGRAM
% New window
  vCoordFig=[378 52 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10]; 
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Actual Bending Moment Diagram';
  crefig(8,vCoordFig,vCoordAxes,cTit);

% Amplification factor for the graphical representation
  dMMmax=max(max(abs(M_Dist)));
  dSmax=max(dimXmax,dimYmax)/20;

% Drawing of the bending moment diagram
  mod_iforconf(nElem,nInc,dXY,M_Dist,dMMmax,dSmax,mesh_num);
  

  % FIGURE 9: Stress Distribution: Axial and Bending Contrib.
% New window
  vCoordFig=[378 52 560 420]; 
  vCoordAxes=[dXmin-dimXmax/10,dXmax+dimXmax/10,dYmin-dimYmax/10,dYmax+dimYmax/10]; 
  if vCoordAxes(1)==vCoordAxes(2)
      vCoordAxes(1)=vCoordAxes(1)-1;
      vCoordAxes(2)=vCoordAxes(2)+1;
  end 
  if vCoordAxes(3)==vCoordAxes(4)
      vCoordAxes(3)=vCoordAxes(3)-1;
      vCoordAxes(4)=vCoordAxes(4)+1;
  end 
  cTit='Normal Compression Stress Distribution: Axial and Bending Contrib.';
  crefig(9,vCoordFig,vCoordAxes,cTit);

% Amplification factor for the graphical representation
  dSSSmax=max(max(abs(sigma_Dist)));
  dSmax=max(dimXmax,dimYmax)/20;

% Drawing of the bending moment diagram
  mod_iforconf(nElem,nInc,dXY,sigma_Dist,dSSSmax,dSmax,mesh_num);

%%%%%%%%%%%
% The end %
%%%%%%%%%%%

%% 
% syms x l
% shape_funcs_bend=[(2*(x^3)/(l^3))-(3*(x^2)/(l^2))+1 ;
%                   ((x^3)/(l^2))-(2*(x^2)/l)+x ;
%                  -(2*(x^3)/(l^3))+(3*(x^2)/(l^2)) ;
%                   ((x^3)/(l^2))-((x^2)/l)];              
% Shape_funcs_axial=[1-x/l;
%                     x/l];
% 
% %Floor Beam (Disp)
% vx_floor=du([5,6,17,18]).*shape_funcs_bend;
% vx_floor=sum(vx_floor);
% 
% ux_floor=du([4,16]).*Shape_funcs_axial;
% ux_floor=sum(ux_floor);
% 
% rotx_floor=diff(vx_floor,x);
% 
% uD   =vpa(subs(ux_floor,[x,l]  ,[Leng_Elem(6),Leng_Elem(6)]))
% vD   =vpa(subs(vx_floor,[x,l]  ,[Leng_Elem(6),Leng_Elem(6)]))
% rotD =vpa(subs(rotx_floor,[x,l]  ,[Leng_Elem(6),Leng_Elem(6)]))
% 
% %Floor Beam (M)
% x_maxMpositive_floor=solve(diff(xM_vec(6),x)==0,x);
% leng_ratioMfloor=vpa(x_maxMpositive_floor/Leng_Elem(6))
% 
% %Roof Beam (M)
% x_maxMpositive_roof =solve(diff(xM_vec(3),x)==0,x);
% leng_ratioMroof =vpa(x_maxMpositive_roof/Leng_Elem(3))

%Displacements and rotation for point D 
%Function M(x) for the Element 9 (floor beam (b))
c1=du(12);
c2=du(11);
c3=du(10);

syms x
M=(5813025202432139*x)/70368744177664 - (25*x^2)/2 - 5771057109941217/70368744177664;
phiD=vpa(subs(int(M/(dPar(13,1)*dPar(13,3))),x,l1/2)+c1)

phiDsyms=int(M/(dPar(13,1)*dPar(13,3)))+c1;
vD=vpa(subs(int(phiDsyms),x,l1/2)+c2)

ux=((dNVM(13,1)*(l1/2))/(dPar(13,1)*dPar(13,2)))+c3






                       