function [s,R,Moved_PointSet1]=GetsRT3_2d(PointSet1,PointSet2_2d,plotpoints)
if ~exist('plotpoints','var')
    plotpoints=0;
end
%将PointSet1与PointSet2对齐,并返回对齐后的PointSet1及相应的变化
if plotpoints
    close all;
    figure;
    plot(PointSet2_2d(:,1),PointSet2_2d(:,2),'b.')
    figure;
    plot3(PointSet1(:,1),PointSet1(:,2),PointSet1(:,3),'r.')
end
% sR*PointSet1'+T=PointSet2'
    H=[PointSet2_2d,ones(length(PointSet2_2d),1)]'*pinv([PointSet1,ones(length(PointSet1),1)]');
    [u,s,v]=svd(H(1:2,1:3),'econ');
    R=zeros(3,3);
    R(1:2,:)=u*v';
    R(3,:)=cross(R(1,:),R(2,:));
    if det(R)<0
        R(:,3)=cross(R(1,:),R(2,:));
    end
    s=mean(diag(s));
    T=mean(PointSet2_2d'-s*R(1:2,1:3)*PointSet1',2);
    Moved_PointSet1=(s*R*PointSet1'+repmat([T;0],[1,length(PointSet1)]))';
if plotpoints 
    plot3(Moved_PointSet1(:,1),Moved_PointSet1(:,2),Moved_PointSet1(:,3),'b*')
end
%p2=reshape(OBJ83pDataSet(6,:),3,83)'