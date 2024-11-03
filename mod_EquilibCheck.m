function [Sigma_X,Sigma_Y,Sigma_M] = mod_EquilibCheck(nDofTot,dR,dF,nInc,dXY,Equ_Nod_elem_Global)
Sigma_M=1;
% Assign direction to all DOFs

dir_Dof=zeros(nDofTot,1);
for nd=1:nDofTot
    [~,col]=find(nInc(:,3:end)==nd);
    if col(1)==1 || col(1)==4
        dir_Dof(nd,1)=1111;
    elseif col(1)==2 || col(1)==5
        dir_Dof(nd,1)=2222;
    elseif col(1)==3 || col(1)==6
        dir_Dof(nd,1)=3333;
    end
end

% Recover the direction of Dofs
  [x_row,~]=find(dir_Dof==1111);
  [y_row,~]=find(dir_Dof==2222);
  [rot_row,~]=find(dir_Dof==3333);

% Recovering Values for Nodal External Loads
  ndF=size(dF);


% ....:::: Calculation of \Sigma X ::::....
    
    % External Load Contrib.
      Ext_cont=sum(Equ_Nod_elem_Global(:,2))+sum(Equ_Nod_elem_Global(:,5));
     
    % Reaction Contribution
      R_cont=sum(dR(x_row,1));
    
    % Nodal Ext Load
      NEL=0;
      for idf=1:ndF
          if ismember(dF(idf,2),x_row)
              NEL=NEL+dF(idf,3);
          end
      end

Sigma_X=Ext_cont+R_cont+NEL;


% ....:::: Calculation of \Sigma Y ::::....
    
% External Load Contrib.
      Ext_cont=sum(Equ_Nod_elem_Global(:,3))+sum(Equ_Nod_elem_Global(:,6));
     
    % Reaction Contribution
      R_cont=sum(dR(y_row,1));
    
    % Nodal Ext Load
      NEL=0;
      for idf=1:ndF
          if ismember(dF(idf,2),y_row)
              NEL=NEL+dF(idf,3);
          end
      end

Sigma_Y=Ext_cont+R_cont+NEL;


% ....:::: Calculation of \Sigma M (over Ox,Oy) ::::....

Ox=dXY(1,1); Oy=dXY(1,2);

    % External Load Contrib.
      Ext_cont_x=sum(Equ_Nod_elem_Global(:,2).*(dXY(nInc(:,1),2)-Oy))...
             + sum(Equ_Nod_elem_Global(:,5).*(dXY(nInc(:,2),2)-Oy));
         
      Ext_cont_y=sum(Equ_Nod_elem_Global(:,3).*(dXY(nInc(:,1),1)-Ox))...
             + sum(Equ_Nod_elem_Global(:,6).*(dXY(nInc(:,2),1)-Ox));
         
    % Reaction Contribution
      R_cont=0;
      for nd=1:nDofTot
          
      end
      
    % Nodal Ext Load
      NEL=0;
      for idf=1:ndF
          if ismember(dF(idf,2),y_row)
              NEL=NEL+dF(idf,3);
          end
      end

Sigma_Mo=Ext_cont_x+Ext_cont_y+R_cont+NEL;
end

