function [H,K,RT_direct,Moved_PointSet1]=GetPerspectiveP3_2d(PointSet1,PointSet2_2d,plotpoints)
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
    PointSet1=PointSet1';
    PointSet2_2d=PointSet2_2d';

    %Solve a Initial R
    p_ext=[PointSet2_2d;ones(1,length(PointSet2_2d))];
    P_3d=[PointSet1;ones(1,length(PointSet1))];
    H=(p_ext)/(P_3d);
    [u,~,v]=svd(H(1:2,1:3),'econ');
    R=u*v';
    R(3,:)=cross(R(1,:),R(2,:));
    if det(R)<0
        R(3,:)=cross(R(1,:),R(2,:));
    end

    %Solve Initial K    
    L1=[P_3d',zeros(size(P_3d')),-diag(p_ext(1,:))*P_3d'];
    L2=[zeros(size(P_3d')),P_3d',-diag(p_ext(2,:))*P_3d'];
    L=[L1;L2];
    [~,~,v]=svd(L,'econ');
    m=v(:,end-2:end);
    alpha=m(9:11,:)\R(3,:)';
    % Left=L*m;
    m_combine=m*alpha;
    M=zeros(4,3);
    M(:)=m_combine;
    M=M';
    [H,K,RT]=Solve_Perspective_M(M);
    
    Moved_PointSet1=H*P_3d;
    Moved_PointSet1=(Moved_PointSet1(1:2,:)./Moved_PointSet1([3,3],:))';
if plotpoints 
    plot(Moved_PointSet1(:,1),Moved_PointSet1(:,2),'b*')
end
%p2=reshape(OBJ83pDataSet(6,:),3,83)'
end

function [H,K,RT_direct]=Solve_Perspective_M(M)
% M/rou= | a*r1-a*cot(t)*r2+u*r3  tx |
%        | b/sin(t)*r2+v*r3       ty |
%        | r3                     tz |
%   
a1=M(1,1:3);
a2=M(2,1:3);
a3=M(3,1:3);
% B=M(:,4);
rou=1/sqrt(sum(a3.^2,2));
M_mult=M*rou;

u=rou*rou*(a1*a3');
v=rou*rou*(a2*a3');
% r2=(a2-v*a3)/norm(a2-v*a3);
abcos_sin2=-(a2-v*a3)*a1';
cost_symbol=(abcos_sin2>0)*2-1;

temp1=cross(a1,a3);
temp2=cross(a2,a3);
% r1=temp2/norm(temp2);
% r3=cross(r1,r2);
% r3_2=a3*rou;

cost=(temp1*temp2')/(norm(temp1)*norm(temp2));
cost=abs(cost)*cost_symbol;
sint=sqrt(1-cost^2);
% t=atan2(sint,cost)/pi*180;
a=rou*rou*norm(temp1)*sint;
b=rou*rou*norm(temp2)*sint;

K=[a,-a*(cost/sint),u;0,b/sint,v;0,0,1];
% T=-K\(rou*B);
% R=[r1;cross(r3,r1);r3];

% RT_calc=[R T];
RT_direct=K\M_mult;
if det(RT_direct(:,1:3))<0
    RT_direct=-RT_direct;
end


% K

% p_p=K*RT_direct*P;
% p_p_r=p_p./repmat(p_p(3,:),[3,1]);
% diff=p-p_p_r;

H=K*RT_direct; 
end
