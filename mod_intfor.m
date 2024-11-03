function [H_Dist,T_Dist,M_Dist,xM_vec] = mod_intfor(mesh_num,nElem,Leng_Elem,dpq_const,dpq_var,dNVM)

syms x
H_Dist=zeros(nElem,mesh_num); % H_Dist(i,:)=Axial Force Distribution in Element i
T_Dist=zeros(nElem,mesh_num); % T_Dist(i,:)=Shear Force Distribution in Element i
M_Dist=zeros(nElem,mesh_num); % M_Dist(i,:)=Bending Moment Distribution in Element i
for ne=1:nElem
    xxx=linspace(0,Leng_Elem(ne),mesh_num);
    
    % ------- Shear Distribution -----------------
    % Total q(x) : Constant + Variable
    xExt_Load=dpq_const(ne,3)+dpq_var(ne,3);
   
    %xT   T(x)=(Boundary Cond. at Node 1) + int(q(x))
    xT=dNVM(ne,2)+int(xExt_Load,x);
    T_Dist(ne,:)=subs(xT,x,xxx);
    
    % --------- Bending Moment Dist. ------------
    %xM:  M(x)=(Boundary Cond. at Node 1) + int(T(x))
    xM=dNVM(ne,3)+int(xT,x);
    M_Dist(ne,:)=subs(xM,x,xxx);
    
    if ne==1
        xM_vec=xM; % Storing M(x)
    else
        xM_vec=[xM_vec ; xM];
    end
        
    % ------- Axial Dist.-----------------
    H_Dist(ne,:)=((dNVM(ne,4)-dNVM(ne,1))/Leng_Elem(ne))*xxx + dNVM(ne,1);
    
    
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%