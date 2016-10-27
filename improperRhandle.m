function R=improperRhandle(R)
    if det(R)<0 && length(find(diag(R)<0))~=2
        R=diag((diag(R)>0)*2-1)*R;
    end
end