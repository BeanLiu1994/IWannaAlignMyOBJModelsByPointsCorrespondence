function Graph=GenGraph(Tri,Pts)
% ÎÞÏòÍ¼
% TriÎª m x 3
Edges=reshape([Tri,Tri]',2,3*length(Tri))';
xy=unique([Edges;Edges(:,[2,1])],'rows');
if ~exist('Pts','var')
    Graph=sparse(xy(:,1),xy(:,2),ones(size(xy,1),1));
else
    v=zeros(size(xy,1),1);
    for i=1:length(xy)
        temp=Pts([xy(i,1),xy(i,2)],:);
        v(i)=sqrt(sum((temp(1,:)-temp(2,:)).^2));
    end
    Graph=sparse(xy(:,1),xy(:,2),v);
end