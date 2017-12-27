function [Parts,Parts_count]=PartSeperate_2(Tri)
    G = GenGraph(Tri);
    len=max(Tri(:));
    TravelingBefore = logical(false(len,1));
    TravelingNow = TravelingBefore;TravelingNow(1)=1;
    Parts = zeros(len,50);count=0;
    PartsSum = false(len,1);
    while(isempty(Parts)||any(PartsSum~=ones(len,1)))
        while(any(TravelingNow~=TravelingBefore))
            TravelingBefore = TravelingNow;
            TravelingNow_v = G(:,TravelingNow);
            [TravelingNow_v,~,~]=find(TravelingNow_v);
            TravelingNow(TravelingNow_v)=1;
        end
        if(isempty(Parts)||any(PartsSum~=ones(len,1)))
            count=count+1;
            if(count>size(Parts,2))
                Parts=[Parts,zeros(size(Parts))];
            end
            Parts(:,count)=TravelingNow;
            PartsSum = PartsSum|TravelingNow;
            TravelingNow = false(size(TravelingNow));
            TravelingNow(find(PartsSum==0,1))=1;
            disp(['Parts Amount Now: ',num2str(count)]);
        end
    end
    Parts=Parts(:,1:count);
    Parts_count=zeros(count,1);
    for i=1:count
        Parts_count(i)=numel(find(Parts(:,i)));
    end
[Parts_count,IC]=sort(Parts_count,'descend');
Parts=Parts(:,IC);
end