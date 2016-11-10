function [L_Base,L]=SolveL_type1(Tri,LargeL)
if nargin==1
    LargeL=0;
end

if isempty(Tri)
    load('AdjSaved.mat');
else
    Adj=FindAdjByTri(Tri);
end
points_amount=length(Adj.Adj_index);

L_Base_x=zeros(length(Tri)*3+points_amount,1);
L_Base_y=zeros(length(Tri)*3+points_amount,1);
L_Base_v=zeros(length(Tri)*3+points_amount,1);
%% Á³ÉÏµÄµã
next=1;
for i=1:points_amount
    L_Base_x(next)=i;L_Base_y(next)=i;L_Base_v(next)=-1;next=next+1;
    count=Adj.Count(i);
    L_Base_x(next:next+count-1)=i;
    L_Base_y(next:next+count-1)=Adj.Adj_index(i,1:count);
    L_Base_v(next:next+count-1)=1/count;
    next=next+count;
end
L_Base=sparse(L_Base_x,L_Base_y,L_Base_v);

L=Converter.expandL(L_Base);
