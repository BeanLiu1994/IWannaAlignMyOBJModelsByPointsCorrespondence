function [Face,Vertex,Color,Vertext,Facet,Vertexn,Facen]=obj_read(filepath)
%% ��ǰ�ж�
if ~exist(filepath,'file')
    error('Error while opening file: File not exists.   Ҫ�򿪵��ļ�������');
end
%% ��֧��������
LoadingInfo=0;% �ļ�����ʱ�Զ���ӡ��ȡ״̬
%% �ȿ��ٶ�ȡ��������
fileID=fopen(filepath,'r');
AllContent = fread(fileID,'*char');%��ȡ�������ݵ�AllContent��
fclose(fileID);
%����������ÿ��Ƭ��
NewLineSymbol=sprintf('\n');%���廻�з�
NewLineSymbolPos=strfind(AllContent',NewLineSymbol)';%���з���λ��
StartAndEndOfEveryRow=[[1;NewLineSymbolPos+1],[NewLineSymbolPos-1;length(AllContent)]];
if NewLineSymbolPos(end)==length(AllContent)
    StartAndEndOfEveryRow=StartAndEndOfEveryRow(1:end-1,:);
end
%���ݻ��з�λ�õõ�ÿ����ֹ
LineAmount=length(NewLineSymbolPos);

if LineAmount>200000
    LoadingInfo=1;
end

%% ��ʼ��ȡ���� ���е�˳���� �ȳ�ʼ��һЩ����
% �����ζ�ȡĳһ�����ʱ�ų�ʼ��
if LoadingInfo
    delta_i=round(linspace(1,LineAmount,50));
    disp(['�ļ���',num2str(LineAmount),'��  ����:' ]);
    disp('|--------------------------------------------------|')
    fprintf('[');
end
ColorMode=[];FaceMode=[];InitCap=10000;
Vertex=zeros(InitCap,3);VertexCounter=0;
Vertexn=[];VertexnCounter=0;
Vertext=[];VertextCounter=0;
Face=zeros(InitCap,3);FaceCounter=0;
FacenRange=[];FacetRange=[];FaceRange=1:3;
%% ��ʼ���ж�ȡ
for i=1:LineAmount
    RowStart=StartAndEndOfEveryRow(i,1);
    RowEnd=StartAndEndOfEveryRow(i,2);
    Line=AllContent(RowStart:RowEnd)';
    if LoadingInfo && ~isempty(find(delta_i==i,1))
        fprintf('=')
    end
    if(~isempty(Line))
        switch Line(1)
            case '0'
                %ʲôҲ����
            case '#'
                %��ȡ����ע��ʲôҲ����
            case 'v'
                Result=sscanf(Line(3:end),'%f')';
                if Line(2)~='n'&&Line(2)~='t'
                    if isempty(ColorMode)
                        Splitter=strsplit(Line(3:end),{' ','\t'});
                        if length(Splitter)>5% 3 or 4
                            Vertex=zeros(InitCap,6);VertexCounter=0;
                            ColorMode=1;
                        else
                            ColorMode=0;
                        end
                    end
                    [Vertex,VertexCounter]=HandleIt(Vertex,VertexCounter,Result);
                elseif Line(2)=='n'
                    if isempty(Vertexn)
                        Vertexn=zeros(InitCap,3);VertexnCounter=0;
                    end
                    [Vertexn,VertexnCounter]=HandleIt(Vertexn,VertexnCounter,Result);
                elseif Line(2)=='t'
                    if isempty(Vertext)
                        Vertext=zeros(InitCap,2);VertextCounter=0;
                    end
                    [Vertext,VertextCounter]=HandleIt(Vertext,VertextCounter,Result);
                end
            case 'f'
                if isempty(FaceMode)
                    MeshPointsSplitCount=length(strsplit(Line(3:end),{' ','\t'}));
                    MeshPropertyPerPoint=length(find(Line=='/'))/MeshPointsSplitCount+1;
                    Line(Line=='/')=' ';MeshPropertyNumberPerPoint=length(sscanf(Line(3:end),'%f'))/MeshPointsSplitCount;
                    Face=zeros(InitCap,MeshPropertyNumberPerPoint*MeshPointsSplitCount);
                    if MeshPropertyPerPoint==2
                        FaceRange=1:2:3*2;
                        FacetRange=2:2:3*2;
                    elseif MeshPropertyPerPoint==3
                        if MeshPropertyNumberPerPoint==2
                            FaceRange=1:2:3*2;
                            FacenRange=2:2:3*2;
                        elseif MeshPropertyNumberPerPoint==3
                            FaceRange=1:3:3*3;
                            FacetRange=2:3:3*3;
                            FacenRange=3:3:3*3;
                        end
                    end
                    FaceMode=[MeshPointsSplitCount,MeshPropertyPerPoint,MeshPropertyNumberPerPoint];
                end
                Line(Line=='/')=' ';
                Result=sscanf(Line(3:end),'%f')';
                [Face,FaceCounter]=HandleIt(Face,FaceCounter,Result);
        end
    end
end
if LoadingInfo
    disp(']��ȡ���')
end
Facen=Face(1:FaceCounter,FacenRange);
Facet=Face(1:FaceCounter,FacetRange);
Face=Face(1:FaceCounter,FaceRange);
if ColorMode
    Color=Vertex(1:VertexCounter,4:6);
else
    Color=[];
end
Vertex=Vertex(1:VertexCounter,1:3);
Vertexn=Vertexn(1:VertexnCounter,:);
Vertext=Vertext(1:VertextCounter,:);
%% ����
%һЩ����Ĵ��� (�е�ȴû������Ϣ)
if isempty(Facen)&&~isempty(Vertexn)
    Facen=Face;
end
if isempty(Facet)&&~isempty(Vertext)
    Facet=Face;
end
end
% ���ڲ�ͬ�Ĳ��ֵĴ���
function [Variable,VariableCounter]=HandleIt(Variable,VariableCounter,ToAppend)
VariableCounter=VariableCounter+1;
if VariableCounter>length(Variable)
    Variable=DoubleSpace(Variable);
end
Variable(VariableCounter,:)=ToAppend;
end
%% �ռ����
function Output=DoubleSpace(Input)
Output=[Input;zeros(size(Input))];
end
