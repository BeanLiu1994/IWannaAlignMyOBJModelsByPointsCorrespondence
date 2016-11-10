function [L_Base,L]=SolveL_type2(XBefore,Triangle,LargeL)
if nargin<3
    LargeL=0;
end
L=[];

L_Base_x=zeros(length(Triangle)*3,1);
L_Base_y=zeros(length(Triangle)*3,1);
L_Base_value=zeros(length(Triangle)*3,1);%填充时只填上半角,之后L_Base=L_Base+L_Base';
L_Base_Count=zeros(length(Triangle)*3,1);%由于表面有边界 必然有边是只有一侧的 策略:只有一侧的话不除以2了
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
    
    L_Base_x(i*3-2:i*3)=[TriIterSort(1);TriIterSort(1);TriIterSort(2)];
    L_Base_y(i*3-2:i*3)=[TriIterSort(2);TriIterSort(3);TriIterSort(3)];
    L_Base_value(i*3-2:i*3)=L_Base_value(i*3-2:i*3)+[cot12;cot13;cot23];
    L_Base_Count(i*3-2:i*3)=L_Base_Count(i*3-2:i*3)+[1;1;1];
    
end
L_Base=sparse([L_Base_x;L_Base_y],[L_Base_y;L_Base_x],[L_Base_value;L_Base_value]);
L_Base_Count_Mat=sparse([L_Base_x;L_Base_y],[L_Base_y;L_Base_x],[L_Base_Count;L_Base_Count]);
[r,c,v]=find(L_Base);
[~,~,v_m]=find(L_Base_Count_Mat);
L_Base=sparse(r,c,v./v_m);
New_x=[1:length(L_Base)]';
New_v=zeros(length(L_Base),1);
for i=1:length(L_Base)
    New_v(i)=-sum(L_Base(i,:));
end
L_Base=sparse([r;New_x],[c;New_x],[v./v_m;New_v]);
if LargeL
    L=Converter.expandL(L_Base);
end