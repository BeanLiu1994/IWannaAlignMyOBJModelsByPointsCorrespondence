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

L_Base=zeros(points_amount);
%% Á³ÉÏµÄµã
for i=1:points_amount
    L_Base(i,i)=-1;
    count=Adj.Count(i);
    for j=1:count
        L_Base(i,Adj.Adj_index(i,j))=1/count;
    end
end

L=[];
if LargeL
    L=zeros(length(L_Base)*3);
    for i=1:length(L_Base)
        L_ThisLine=L_Base(i,:);
        ZerosToBeInserted=zeros(2,length(L_ThisLine));
        L_NewLine=zeros(1,length(L_Base)*3);
        L_NewLine(:)=[L_ThisLine;ZerosToBeInserted];
        L(3*i-2,:)=L_NewLine;
        L(3*i-1,:)=[0,L_NewLine(1:end-1)];
        L(3*i,:)=[0,0,L_NewLine(1:end-2)];
    end
    L=sparse(L);
end

L_Base=sparse(L_Base);
