function [XNew,J1,J2,J2_]=SolveX(L,Pts,PIter,Di_p,W,lambda,initialJ)
    L2=L*L;
    XBefore=Converter.ResizeX_px3_2_3p(Pts);
    Di=Converter.Full_D(Di_p);
    Di_2=Converter.F2p_D(Di_p);
    Left=zeros(size(L));
    Right=zeros(size(L,1),1);
    
    if(lambda~=0)
        for i=1:size(W,1)
            disp(['矩阵开始计算第',num2str(i),'个图片']);
            Pik=squeeze(PIter(i,:,:));
            T=sparse(Di_2*repmat(Pik(1:2,4),[length(L)/3,1]));
            PikMat=Converter.repmat_PFill(Pik(1:2,1:3),length(L)/3);
            Left=Left+(PikMat*Di)'*(PikMat*Di);
            Right=Right+(PikMat)'*(W(i,:)'-T);
        end
    end
    disp(['矩阵开始计算相邻点约束信息']);
    Left=lambda*Left+L2;
    Right=lambda*Right+L2*XBefore;
    disp('求解XNew');
    XNew=sparse(Left)\Right;
    
    %% 计算调试信息
    J1=L*XNew-L*XBefore;
    % J1=L*XNew+H0*N;
    J2=zeros(size(W,2),1);
    if(lambda~=0)
        for i=1:size(W,1)
            Pik=squeeze(PIter(i,:,:));
            T=sparse(Di_2*repmat(Pik(1:2,4),[length(L)/3,1]));
            PikMat=Converter.repmat_PFill(Pik(1:2,1:3),length(L)/3);
            J2=J2+lambda*(PikMat*Di*XNew-(W(i,:)'-T));
        end
    end
    
    J2_=zeros(size(W,2),1);
    if(lambda~=0&&initialJ==1)
        for i=1:size(W,1)
            Pik=squeeze(PIter(i,:,:));
            T=sparse(Di_2*repmat(Pik(1:2,4),[length(L)/3,1]));
            PikMat=Converter.repmat_PFill(Pik(1:2,1:3),length(L)/3);
            J2_=J2_+lambda*(PikMat*Di*XBefore-(W(i,:)'-T));
        end
    end
    
    XNew=Converter.ResizeX_3p_2_px3(XNew);
end