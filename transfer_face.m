function transfer_face()
    paths_configure;
    %����Roth��ƪ���ĵ�˼·
    name_face=[paths.data_lib,'Head83p_facepart']; %�ļ���	
    [Tri,Pts]=obj_read([name_face,'.obj']);
    load([name_face,'_Cor.mat']);
    %% size
    list = 21:paths.image_mark_amount;
    p=length(Pts);
    q=length(list);
    %% D
    Di_p=zeros(p,q);
    for i=1:q
        Di_p(Correspondence(list(i)),i)=1;
    end
    Di_p=sparse(Di_p);
    XNew=Pts;
    %% W
    load([paths.data_temp,'W.mat']);
    W=Converter.SelectW(W,list);
    FullW=Converter.Full_W(W,Correspondence(list),p);
    %% ���㲿�� ���Ҫ������Ҫ�޸���һ����
    for i=1:2
        % ����L
        disp('������L');
        L=SolveL(Pts,Tri);
%         [L,L_Base]=SolveL_old(Tri);
        L=sparse(L);
        % ����P
        [PIter] = SolvePIter(XNew,W,Di_p);
        disp('������P');
        lambda=1;%(10e-4);
        % ���X
        [XNew,J1,J2,J2_] = SolveX(L,XNew,PIter,Di_p,FullW,lambda,i);
        save([paths.data_temp,'CalculationParams',num2str(i),'.mat'],'L','PIter','XNew','J1','J2');
        if i==1
            J1=0;
            J2=J2_;
            save([paths.data_temp,'CalculationParams',num2str(0),'.mat'],'PIter','XNew','J1','J2');
        end
        disp(['������',num2str(i),'��']);
        count=i;
        save([paths.data_temp,'CalculationParamsIterAmount.mat'],'count');
        obj_write([paths.data_temp,'FaceResultIter',num2str(i),'.obj'],Tri,XNew);%
        Checker_IterInfomation();
        pause(1);
    end
    %% ������
    save([paths.data_temp,'FaceResult.mat'],'XNew','Tri');% ͬ��
    obj_write([paths.data_temp,'FaceResult.obj'],Tri,XNew);% 1. ֮�����
    
    name_face=[paths.data_lib,'Head83p']; %�ļ���	
    [Tri,Pts]=obj_read([name_face,'.obj']);
    save([paths.data_temp,'source.mat'],'Tri','Pts','Correspondence');% 2. ԭ����ͷ
    load([paths.data_lib,'reserved.mat']);
    Pts(reserved,:)=XNew;
    
    obj_write([paths.data_temp,'BeforeMergeResult.obj'],Tri,Pts); % 3. ֮ǰ�ķ�������֮�����
    save([paths.data_temp,'newPointData.mat'],'Pts','Tri','Correspondence');% ͬ��
end