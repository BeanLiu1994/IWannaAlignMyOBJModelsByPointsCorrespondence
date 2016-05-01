function result = SolveKernel(L,LPts,Aeq,Beq,lambda,Mode)
% mode 1:seperate  2:combine
% ²î±ð²»´ó
A1=L;
B1=LPts;

A2=zeros(length(Aeq),length(LPts));
A2(:,Aeq)=eye(length(Aeq));
B2=Beq;
A=[];B=[];

if Mode==1
    A=sparse([A1;lambda*A2]);
    B=[B1;lambda*B2];
elseif Mode==2 
    A=A1;B=B1;
    A(Aeq,:)=lambda*A2;
    B(Aeq,:)=lambda*B2;
    A=sparse(A);
end
if isempty(A)
    result=[];
else
    result=A\B;
end
end