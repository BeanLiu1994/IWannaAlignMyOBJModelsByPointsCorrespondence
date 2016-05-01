function result=DeleteDuplicatedElement(Source,toBeDeleted)
% ascend sorted vecs
    pos=1;
    ReservedSource=ones(size(Source));
    for i=1:length(Source)
        while(pos<length(toBeDeleted)&&toBeDeleted(pos)<Source(i))
            pos=pos+1;
        end
        if Source(i)==toBeDeleted(pos)
            ReservedSource(i)=0;
            pos=pos+1;
            if pos>length(toBeDeleted)
                break;
            end
        end
    end
    result=Source(find(ReservedSource));
end