function [Face,Vertex,Color,Vertext,Facet,Vertexn,Facen]=obj_read_poly(filepath)
%% 打开前判断
if ~exist(filepath,'file')
    error('Error while opening file: File not exists.   要打开的文件不存在');
end
%% 仅支持三角面
LoadingInfo=0;% 文件过大时自动打印读取状态
%% 先快速读取所有内容
fileID=fopen(filepath,'r');
AllContent = fread(fileID,'*char');%读取所有内容到AllContent内
fclose(fileID);
%分析行数和每行片段
NewLineSymbol=sprintf('\n');%定义换行符
NewLineSymbolPos=strfind(AllContent',NewLineSymbol)';%换行符的位置
StartAndEndOfEveryRow=[[1;NewLineSymbolPos+1],[NewLineSymbolPos-1;length(AllContent)]];
if NewLineSymbolPos(end)==length(AllContent)
    StartAndEndOfEveryRow=StartAndEndOfEveryRow(1:end-1,:);
end

%根据换行符位置得到每行起止
LineAmount=length(NewLineSymbolPos);

if LineAmount>200000
    LoadingInfo=1;
end

%% 开始读取内容 按行的顺序来 先初始化一些变量
% 当初次读取某一类变量时才初始化
if LoadingInfo
    delta_i=round(linspace(1,LineAmount,50));
    disp(['文件共',num2str(LineAmount),'行  进度:' ]);
    disp('|--------------------------------------------------|')
    fprintf('[');
end
ColorMode=[];FaceMode=[];InitCap=10000;
Vertex=zeros(InitCap,3);VertexCounter=0;
Vertexn=[];VertexnCounter=0;
Vertext=[];VertextCounter=0;
Face=zeros(InitCap,3);FaceCounter=0;
FacenRange=[];FacetRange=[];FaceRange=1:3;
%% 开始逐行读取
for i=1:LineAmount
    RowStart=StartAndEndOfEveryRow(i,1);
    RowEnd=StartAndEndOfEveryRow(i,2);
    Line=AllContent(RowStart:RowEnd)';
    if LoadingInfo && ~isempty(find(delta_i==i,1))
        fprintf('=')
    end
    if(~isempty(Line))
        switch Line(1)
            case '#'
                %读取到了注释什么也不做
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
                    [Vertext,VertextCounter]=HandleIt(Vertext,VertextCounter,Result(1:2));
                end
            case 'f'
                if isempty(FaceMode) %init
                    [MeshPointsSplitCount,MeshPropertyPerPoint,MeshPropertyNumberPerPoint]=FacePartLineInfoExtract(Line);
                    Face=zeros(InitCap,MeshPropertyNumberPerPoint*MeshPointsSplitCount);
                    PtAmount=MeshPropertyNumberPerPoint*MeshPointsSplitCount;
                    FaceMode=[MeshPointsSplitCount,MeshPropertyPerPoint,MeshPropertyNumberPerPoint,0];
                end
                OriginalLine=Line;
                Line(Line=='/')=' ';
                Result=sscanf(Line(3:end),'%f')';
                if length(Result)>FaceMode(4)
                    [MeshPointsSplitCount,MeshPropertyPerPoint,MeshPropertyNumberPerPoint]=FacePartLineInfoExtract(OriginalLine);
                    PtAmount=MeshPropertyNumberPerPoint*MeshPointsSplitCount;
                    if MeshPropertyPerPoint==2
                        FaceRange=1:2:PtAmount;
                        FacetRange=2:2:PtAmount;
                    elseif MeshPropertyPerPoint==3
                        if MeshPropertyNumberPerPoint==2
                            FaceRange=1:2:PtAmount;
                            FacenRange=2:2:PtAmount;
                        elseif MeshPropertyNumberPerPoint==3
                            FaceRange=1:3:PtAmount;
                            FacetRange=2:3:PtAmount;
                            FacenRange=3:3:PtAmount;
                        end
                    end
                    FaceMode=[MeshPointsSplitCount,MeshPropertyPerPoint,MeshPropertyNumberPerPoint,PtAmount];
                end
                [Face,FaceCounter]=HandleIt(Face,FaceCounter,Result);
            otherwise
                %什么也不做
        end
    end
end
if LoadingInfo
    disp(']读取完毕')
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
%% 结束
%一些情况的处理 (有点却没有面信息)
if isempty(Facen)&&~isempty(Vertexn)
    Facen=Face;
end
if isempty(Facet)&&~isempty(Vertext)
    Facet=Face;
end
end
% 对于不同的部分的处理
function [Variable,VariableCounter]=HandleIt(Variable,VariableCounter,ToAppend)
VariableCounter=VariableCounter+1;
if VariableCounter>length(Variable)
    Variable=DoubleSpace(Variable);
end    
if size(Variable,2)<size(ToAppend,2)
    Variable=ExtendSpace(Variable,size(ToAppend,2));
end
Variable(VariableCounter,1:length(ToAppend))=ToAppend;
end
function [MeshPointsSplitCount,MeshPropertyPerPoint,MeshPropertyNumberPerPoint]=FacePartLineInfoExtract(Line)
    TextInLine=strsplit(Line(3:end),{' ','\t','\r'});
    MeshPointsSplitCount=0;
    for j=1:length(TextInLine)
        if(~isempty(TextInLine{j}))
            MeshPointsSplitCount=MeshPointsSplitCount+1;
        end
    end
    MeshPropertyPerPoint=length(find(Line=='/'))/MeshPointsSplitCount+1;
    Line(Line=='/')=' ';
    MeshPropertyNumberPerPoint=length(sscanf(Line(3:end),'%f'))/MeshPointsSplitCount;
end
%% 空间分配
function Output=DoubleSpace(Input)
Output=[Input;zeros(size(Input))];
end
function Output=ExtendSpace(Input,Column)
Output=[Input,zeros(size(Input,1),Column-size(Input,2))];
end
