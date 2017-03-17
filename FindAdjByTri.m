%����: Tri
%���: Adjacent
%�������ǹ�ϵ�����ڵ���Ϣ
function [Adjacent] = FindAdjByTri(Tri)
    MAXconnection=30;
    G=GenGraph(Tri);
    [r,c,v]=find(G);%�ԳƵ�
    PtsAmount=max(Tri(:));
    Adjacent.Count=zeros(PtsAmount,1);
	Adjacent.Adj_index=zeros(PtsAmount,MAXconnection);
    indstart=1;
    for i=1:PtsAmount
        indend=indstart;
        while(c(indend+1)==i)
            indend=indend+1;
            if indend==length(c)
                break;
            end
        end
        ind=indstart:indend;
        Adjacent.Count(i)=length(ind);
        Adjacent.Adj_index(i,1:length(ind))=r(ind);
        indstart=indend+1;
    end
end