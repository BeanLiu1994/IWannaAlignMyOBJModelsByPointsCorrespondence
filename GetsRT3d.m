function [H,s,R,T,Moved_PointSet1]=GetsRT3d(PointSet1,PointSet2,plotpoints)
if nargin<3
    plotpoints=0;
end
%将PointSet1与PointSet2对齐,并返回对齐后的PointSet1及相应的变化
if plotpoints
    close all;
    figure;hold on;
    plot3(PointSet2(:,1),PointSet2(:,2),PointSet2(:,3),'b.')
    plot3(PointSet1(:,1),PointSet1(:,2),PointSet1(:,3),'r.')
end
% sR*PointSet1'+T=PointSet2'
    H=[PointSet2,ones(length(PointSet2),1)]'*pinv([PointSet1,ones(length(PointSet1),1)]');
    [u,s,v]=svd(H(1:3,1:3));
    s=mean(diag(s));
    T=mean(PointSet2'-s*R'*PointSet1',2);
    H=[s*R,[0;0;0];[T',1]];
    Moved_PointSet1=(s*R'*PointSet1'+repmat(T,[1,length(PointSet1)]))';
if plotpoints 
    plot3(Moved_PointSet1(:,1),Moved_PointSet1(:,2),Moved_PointSet1(:,3),'b*')
end
%p2=reshape(OBJ83pDataSet(6,:),3,83)'