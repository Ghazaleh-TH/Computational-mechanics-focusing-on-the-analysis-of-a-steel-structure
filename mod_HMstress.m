function [sigma_Dist,sigma_elem_max] = mod_HMstress(mesh_num,nElem,M_Dist,H_Dist,section_height,dPar)


%xH=zeros(nElem,1);

sigma_Dist=zeros(nElem,mesh_num);
sigma_elem_max=zeros(1,nElem);
for ne=1:nElem
    % Calculation of Normal Compression Stress along the Element
    sigma_Dist(ne,:)= (abs(M_Dist(ne,:)).*(section_height(ne,:)/2)/dPar(ne,3)) ...
                    - (H_Dist(ne,:)/ dPar(ne,2));
    sigma_elem_max(ne)=max(sigma_Dist(ne,:));
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%