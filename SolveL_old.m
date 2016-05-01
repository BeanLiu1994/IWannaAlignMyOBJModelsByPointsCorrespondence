function [L,L_Base]=SolveL_old(Tri)

Adj=FindAdjByTri(Tri);
points_amount=max(Tri(:));

L_Base=zeros(points_amount);
%% Á³ÉÏµÄµã
for i=1:points_amount
    L_Base(i,i)=-1;
    count=Adj.Count(i);
    for j=1:count
        L_Base(i,Adj.Adj_index(i,j))=1/count;
    end
end


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

