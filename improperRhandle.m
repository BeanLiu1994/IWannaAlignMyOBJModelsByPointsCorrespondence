function R=improperRhandle(R)
    if det(R)<0
        num=length(find(diag(R)<0));
        if num==1
            R=R*diag((diag(R)>0)*2-1);
        else
            R=R*diag((diag(R)<0)*2-1);
        end
    end
end