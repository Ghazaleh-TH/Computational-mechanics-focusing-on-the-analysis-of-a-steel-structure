
% function maxdispl: defines the maximum displacement of the structure

function [dUmax]=maxdispl(nElem,nInc,dXY,du)

dUmax=0;
for ne=1:nElem
    % Nodes of the ne-th element
      n1=nInc(ne,1);
      n2=nInc(ne,2);

    % Maximum displacement
      ds=(0:.02:1)';
      dLne=norm(dXY(n2,:)-dXY(n1,:),2);
      dCSne=(dXY(n2,:)-dXY(n1,:))/dLne;
   
      dQne=zeros([6,6]);
      dQne(1:2,1)=dCSne';
      dQne(1:2,2)=[0,-1;1,0]*dCSne';
      dQne(3,3)=1;
      dQne(4:6,4:6)=dQne(1:3,1:3);
      dUloc=dQne'*du(nInc(ne,3:8),1);
      duloc=[1-ds,zeros([51,2]),ds,zeros([51,2])]*dUloc;
      dvloc=[zeros([51,1]),1-3*ds.^2+2*ds.^3,dLne*ds.*(1-2*ds+ds.^2),zeros([51,1]),3*ds.^2-2*ds.^3,dLne*ds.*(-ds+ds.^2)]*dUloc;
      dUmax=max([sqrt(duloc.^2+dvloc.^2);dUmax]);
end

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%