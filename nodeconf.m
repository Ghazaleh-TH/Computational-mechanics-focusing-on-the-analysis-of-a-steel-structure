
% function nodeconf: displays the nodes of the structure

function nodeconf(nNode,dXY,dr)

 % Drawing of the nodes
   for nn=1:nNode
       dxc=dXY(nn,1);
       dyc=dXY(nn,2);
       dx=dxc+dr*[-.7,.7];
       dy=dyc*[1,1];
       plot(dx,dy,'r-')
       dx=dxc*[1,1];
       dy=dyc+dr*[-.7,.7];
       plot(dx,dy,'r-')
       
       
       % Draw Circles at the position of Node Index
       % radius r and center at dxc and dyc
       r=1.5*dr;
       th=0:pi/10:2*pi;
       x_vec=r * cos(th) + dxc+2.25*dr;
       y_vec=r * sin(th) + dyc+2*dr;
       
       dx_fill=x_vec';
       dy_fill=y_vec';
       fill(dx_fill,dy_fill,[103 150 170]/255,'FaceAlpha',.2)
       
       % Connecting two circles
       nPoint=length(th);
       dx_connect=[dxc , dx_fill(4*round(nPoint/8))];
       dy_connect=[dyc , dy_fill(4*round(nPoint/8))];
       
       plot(dx_connect,dy_connect,'k')
       text(dxc+1.8*dr,dyc+2*dr,sprintf('%d',nn),'color',[1,0,0],'linewidth',3)
       
   end

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%