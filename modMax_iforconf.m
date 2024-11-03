
% function iforconf: displays internal forces diagram

function modMax_iforconf(nElem,nInc,dXY,dIF,dIFmax,dSmax,mesh_num)
 
if dIFmax==0
    dIFmax=1;
end

for ne=1:nElem
    % Nodes of the ne-th element
      n12=nInc(ne,1:2);

    % Coordinates of the nodes of the ne-th element
      dx=dXY(n12,1);
      dy=dXY(n12,2);

    % Length of the ne-th element
      dLne=norm([dx(2)-dx(1),dy(2)-dy(1)],2);

    % Cosine & Sine of the ne-th element inclination
      dCSne=[dx(2)-dx(1),dy(2)-dy(1)]/dLne;

    % Drawing of the ne-th element and relative internal force diagram
      dIFne=dIF(ne,[1 end]);
      ds=linspace(0,1,mesh_num-1)';
      dx=[dx;
          dx(2,1)*(1-ds)+dx(1,1)*ds+dSmax*dCSne(2)*(dIF(ne,end:-1:2)'.*(1-ds)+dIF(ne,end-1:-1:1)'.*ds)/dIFmax];
      
      dy=[dy;
          dy(2,1)*(1-ds)+dy(1,1)*ds-dSmax*dCSne(1)*(dIF(ne,end:-1:2)'.*(1-ds)+dIF(ne,end-1:-1:1)'.*ds)/dIFmax];
 
      fill(dx,dy,[.1 1 .6],'FaceAlpha',.1)
      
%       dxtext=(.75*dx(1)+.25*dx(2))+.35*dSmax*dCSne(2);
%       dytext=(.75*dy(1)+.25*dy(2))+.65*dSmax*dCSne(1);
%       text(dxtext,dytext,sprintf('%1.3g',dIFne(1)))
%       dxtext=(.25*dx(1)+.75*dx(2))+.35*dSmax*dCSne(2);
%       dytext=(.25*dy(1)+.75*dy(2))+.65*dSmax*dCSne(1);
%       text(dxtext,dytext,sprintf('%1.3g',dIFne(2)))
%       

      % Displaying Max Values of diagrams
      [~,Loc]=max(abs(dIF(ne,:)));
      
      dxtext=(.50*dx(1)+.50*dx(2))+.35*dSmax*dCSne(2);
      dytext=(.50*dy(1)+.50*dy(2))+.65*dSmax*dCSne(1);
      text(dxtext,dytext,sprintf('%1.3g',dIF(ne,Loc)))
      
      hold on
      plot(dx(1001-Loc+2),dy(1001-Loc+2),'r*','linewidth',4)
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
