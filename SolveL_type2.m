function [L_Base,L]=SolveL_type2(XBefore,Triangle,LargeL)
if nargin<3
    LargeL=0;
end

L_Base=zeros(length(XBefore));%填充时只填上半角,之后L_Base=L_Base+L_Base';
L_Base_Count=zeros(length(XBefore));%由于表面有边界 必然有边是只有一侧的 策略:只有一侧的话不除以2了
for i=1:length(Triangle)
    TriIterSort=sort(Triangle(i,:));
    %点3夹角对应边12
    Vector1=XBefore(TriIterSort(1),:)-XBefore(TriIterSort(3),:);Vector1=Vector1/norm(Vector1);
    Vector2=XBefore(TriIterSort(2),:)-XBefore(TriIterSort(3),:);Vector2=Vector2/norm(Vector2);
    costemp=Vector1*Vector2';
    sintemp=norm(cross(Vector1,Vector2));
    cot12=costemp/sintemp;
    
    %点2夹角对应边13
    Vector1=XBefore(TriIterSort(1),:)-XBefore(TriIterSort(2),:);Vector1=Vector1/norm(Vector1);
    Vector2=XBefore(TriIterSort(3),:)-XBefore(TriIterSort(2),:);Vector2=Vector2/norm(Vector2);
    costemp=Vector1*Vector2';
    sintemp=norm(cross(Vector1,Vector2));
    cot13=costemp/sintemp;
    
    %点1夹角对应边23
    Vector1=XBefore(TriIterSort(3),:)-XBefore(TriIterSort(1),:);Vector1=Vector1/norm(Vector1);
    Vector2=XBefore(TriIterSort(2),:)-XBefore(TriIterSort(1),:);Vector2=Vector2/norm(Vector2);
    costemp=Vector1*Vector2';
    sintemp=norm(cross(Vector1,Vector2));
    cot23=costemp/sintemp;
    
    L_Base(TriIterSort(1),TriIterSort(2))=L_Base(TriIterSort(1),TriIterSort(2))+cot12;
    L_Base_Count(TriIterSort(1),TriIterSort(2))=L_Base_Count(TriIterSort(1),TriIterSort(2))+1;
    
    L_Base(TriIterSort(1),TriIterSort(3))=L_Base(TriIterSort(1),TriIterSort(3))+cot13;
    L_Base_Count(TriIterSort(1),TriIterSort(3))=L_Base_Count(TriIterSort(1),TriIterSort(3))+1;
    
    L_Base(TriIterSort(2),TriIterSort(3))=L_Base(TriIterSort(2),TriIterSort(3))+cot23;
    L_Base_Count(TriIterSort(2),TriIterSort(3))=L_Base_Count(TriIterSort(2),TriIterSort(3))+1;
    
end
L_Base=L_Base+L_Base';
L_Base_Count=L_Base_Count+L_Base_Count';
L_Base_Count(L_Base_Count==0)=Inf;
L_Base=L_Base./L_Base_Count;
for i=1:length(L_Base)
    L_Base(i,i)=-sum(L_Base(i,:));
end
clearvars -except XBefore L_Base LargeL

L=[];
if LargeL
    L=zeros(length(XBefore)*3);
    for i=1:length(XBefore)
        L_ThisLine=L_Base(i,:);
        ZerosToBeInserted=zeros(2,length(L_ThisLine));
        L_NewLine=zeros(1,length(XBefore)*3);
        L_NewLine(:)=[L_ThisLine;ZerosToBeInserted];
        L(3*i-2,:)=L_NewLine;
        L(3*i-1,:)=[0,L_NewLine(1:end-1)];
        L(3*i,:)=[0,0,L_NewLine(1:end-2)];
    end
end

L_Base=sparse(L_Base);
