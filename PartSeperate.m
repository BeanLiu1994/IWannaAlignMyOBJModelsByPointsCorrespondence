function [Parts,Parts_v,Parts_v_Count]=PartSeperate(Tri)
    PartsWidth=max(Tri(:));Parts=[];
    PtsTraveled=zeros(PartsWidth,1);
    [Adjacent] = FindAdjByTri(Tri);
    TravelingNow=[];
    while(~isempty(find(PtsTraveled==0,1,'first')))
        if isempty(TravelingNow)
            TravelingNow=find(PtsTraveled==0,1,'first');
        else
            NewTravelStart=[];
            for i=1:length(TravelingNow)
                NewTravelStart=[NewTravelStart,Adjacent.Adj_index(TravelingNow(i),1:Adjacent.Count(TravelingNow(i)))];
            end
            TravelingNow=unique(NewTravelStart);
        end
        if ~isempty(find(PtsTraveled))
            TravelingNow=DeleteDuplicatedElement(TravelingNow,find(PtsTraveled));
        end
        if isempty(TravelingNow)
            Parts=[Parts;(PtsTraveled==1)'];
            PtsTraveled(PtsTraveled==1)=2;
        end
        PtsTraveled(TravelingNow)=1;
    end
    Parts_v=zeros(size(Parts,1),1);
    Parts_v_Count=zeros(size(Parts,1),1);
    for i=1:size(Parts,1)
        IndexOfPointsInThisPart=find(Parts(i,:)~=0);
        SizeOfPointsInThisPart=length(IndexOfPointsInThisPart);
        Parts_v_Count(i)=SizeOfPointsInThisPart;
        if size(Parts_v,2)<SizeOfPointsInThisPart
            Parts_v=[Parts_v,zeros(size(Parts,1),SizeOfPointsInThisPart-size(Parts_v,2))];
        end
        Parts_v(i,1:SizeOfPointsInThisPart)=IndexOfPointsInThisPart;
    end
end
