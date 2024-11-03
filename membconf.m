
% function membconf: displays the structural members

function [myhandler]=membconf(nElem,nInc,dXY,du,dAmplif,dt,sSt)

% Drawing of the members
  for ne=1:nElem
      % Nodes of the ne-th element
        n1=nInc(ne,1);
        n2=nInc(ne,2);

      % Drawing of the ne-th element
        ds=(0:.02:1)';
        dx=dXY(n1,1)*(1-ds)+dXY(n2,1)*ds;
        dy=dXY(n1,2)*(1-ds)+dXY(n2,2)*ds;
        dLne=norm(dXY(n2,:)-dXY(n1,:),2);
        dCSne=(dXY(n2,:)-dXY(n1,:))/dLne;

        if dAmplif > 0
            dQne=zeros([6,6]);
            dQne(1:2,1)=dCSne';
            dQne(1:2,2)=[0,-1;1,0]*dCSne';
            dQne(3,3)=1;
            dQne(4:6,4:6)=dQne(1:3,1:3);
            dUloc=dQne'*du(nInc(ne,3:8),1);
            duloc=[1-ds,zeros([51,2]),ds,zeros([51,2])]*dUloc;

            dvloc=[zeros([51,1]),1-3*ds.^2+2*ds.^3,dLne*ds.*(1-2*ds+ds.^2),zeros([51,1]),3*ds.^2-2*ds.^3,dLne*ds.*(-ds+ds.^2)]*dUloc;
            dx=dx+dAmplif*[duloc,dvloc]*[dCSne(1);-dCSne(2)];
            dy=dy+dAmplif*[duloc,dvloc]*[dCSne(2);dCSne(1)];
        end
        myhandler=plot(dx,dy,sSt);

        if dt ~= 0
            dxtext=(dXY(n1,1)+dXY(n2,1))/2-dt*dCSne(2);
            dytext=(dXY(n1,2)+dXY(n2,2))/2+dt*dCSne(1);
            text(dxtext,dytext,sprintf('%d',ne),'color',[0,0,1],'linewidth',3)
        end
  end

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%