function [Pts_new]=GetNewPts(Pts,Aeq,Beq,Tri,method)
addpath(genpath('./'));
% Pts :size p x 3   Tri :size m x 3
% 输出的值尽量满足 Pts_new(Aeq,:)=Beq; 的条件  Aeq :size k x 1   Beq :size k x 3
% method: 1:sRT move
%         2:LaplaceCoordinate type1 With sRt first [Default]
%         3:LaplaceCoordinate type2 With sRt first
%         4:LaplaceCoordinate type1 Without sRt  (Need Manully Alignment)
%         5:LaplaceCoordinate type2 Without sRt  (Need Manully Alignment)
if nargin==2
    Pts_new=Pts;
    return;
elseif nargin==3
    method=1;
elseif nargin==4
    method=2;
end

switch(method)
    case 1
        [H]=GetsRT3d(Pts(Aeq,:),Beq);
        Pts_new = [Pts,ones(length(Pts),1)] * H;
        Pts_new = Pts_new(:,1:3);
    case 2
        temp = GetNewPts(Pts,Aeq,Beq,[],1);
        [L]=SolveL_type1(Tri);
        Pts_new=SolveKernel(L,L*temp,Aeq,Beq,20,2);
    case 3
        temp = GetNewPts(Pts,Aeq,Beq,[],1);
        [L]=SolveL_type2(temp,Tri);
        Pts_new=SolveKernel(L,L*temp,Aeq,Beq,20,2); 
    case 4
        [L]=SolveL_type1(Tri);
        Pts_new=SolveKernel(L,L*Pts,Aeq,Beq,20,2);
    case 5
        [L]=SolveL_type2(Pts,Tri);
        Pts_new=SolveKernel(L,L*Pts,Aeq,Beq,20,2);
end

end