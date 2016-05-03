function obj_write_poly(file,face,vertex,   color,   vt,fvt,imagepath,   vn,fvn)
%% support 'v' 'f' ‘vt' infomation
%% param judge
faceAvalibale=1;
colorAvalibale=1;
vtAvalible=1;
vtImgAvalible=1;
vnAvalible=1;
if ~exist('face','var');face=[];end;
if ~exist('color','var');color=[];end;
if ~exist('vt','var');vt=[];end;
if ~exist('fvt','var');fvt=[];end;
if ~exist('imagepath','var');imagepath=[];end;
if ~exist('vn','var');vn=[];end;
if ~exist('fvn','var');fvn=[];end;
if isempty(face);faceAvalibale=0;end;
if isempty(color);colorAvalibale=0;end;
if isempty(vt)||isempty(fvt);vtAvalible=0;end;
vtImgAvalible=vtAvalible;
if isempty(imagepath);vtImgAvalible=0;end;
if isempty(vn)||isempty(fvn);vnAvalible=0;end;
%% file part
NameBegin=sort([find(file=='/'),find(file=='\')]);
if ~isempty(NameBegin)
    NameBegin=NameBegin(end);
else
    NameBegin=0;
end
pathoffile=file(1:NameBegin);
file=file(NameBegin+1:end);
fid=fopen([pathoffile,file],'w');
%% 保存基本信息
save([pathoffile,file(1:end-4),'.mat'],'face','vertex','color','vt','fvt','imagepath','vn','fvn');
%% vt material part
    if vtAvalible
        fprintf(fid,'mtllib %s\n',[file(1:end-4),'.mtl']);
        fprintf(fid,'usemtl material_0\n');
    end
%% vertex part
    if ~colorAvalibale
        for i=1:length(vertex)
            fprintf(fid,'v %s\n',num2str(vertex(i,:),'%f '));
        end
    else
        if size(color,1)==1;color=repmat(color,[size(vertex,1),1]);end;
        if size(vertex,1)~=size(color,1);error('点数和颜色不匹配');end;
        if size(color,2)==1;color=repmat(color,[1,3]);end;
        if size(vertex,2)~=size(color,2);error('点数和颜色不匹配');end;
        for i=1:length(vertex)
            fprintf(fid,'v %s\n',[num2str(vertex(i,:),'%f '),' ',num2str(color(i,:),'%f ')]);
        end
    end
%% vt pts part
    if vtAvalible
        for i=1:length(vt)
            fprintf(fid,'vt %s\n',num2str(vt(i,:),'%f '));
        end
    end
%% vn pts part    
    if vnAvalible
        for i=1:length(vn)
            fprintf(fid,'vn %s\n',num2str(vn(i,:),'%f '));
        end
    end
    %% facepart
    if faceAvalibale
        if vtAvalible
            if vnAvalible
                for i=1:length(face)
                    faceThisLine=face(i,:);faceThisLine=faceThisLine(faceThisLine~=0);
                    fvtThisLine=fvt(i,:);fvtThisLine=fvtThisLine(faceThisLine~=0);
                    fvnThisLine=fvn(i,:);fvnThisLine=fvnThisLine(faceThisLine~=0);
                    ThisLineContent=[faceThisLine;fvtThisLine;fvnThisLine];
                    ThisLineContent_resize=zeros(numel(ThisLineContent),1);
                    ThisLineContent_resize(:)=ThisLineContent;
                    fprintf(fid,'f %s\n',num2str(ThisLineContent_resize,'%d\\%d '));
                end
            else
                for i=1:length(face)
                    faceThisLine=face(i,:);faceThisLine=faceThisLine(faceThisLine~=0);
                    fvtThisLine=fvt(i,:);fvtThisLine=fvtThisLine(faceThisLine~=0);
                    ThisLineContent=[faceThisLine;fvtThisLine];
                    ThisLineContent_resize=zeros(numel(ThisLineContent),1);
                    ThisLineContent_resize(:)=ThisLineContent;
                    fprintf(fid,'f %s\n',num2str(ThisLineContent_resize,'%d\\%d '));
                end
            end
        else
            if vnAvalible
                for i=1:length(face)
                    faceThisLine=face(i,:);faceThisLine=faceThisLine(faceThisLine~=0);
                    fvnThisLine=fvn(i,:);fvnThisLine=fvnThisLine(faceThisLine~=0);
                    ThisLineContent=[faceThisLine;fvnThisLine];
                    ThisLineContent_resize=zeros(numel(ThisLineContent),1);
                    ThisLineContent_resize(:)=ThisLineContent;
                    fprintf(fid,'f %s\n',num2str(ThisLineContent_resize,'%d\\\\%d '));
                end
            else
                for i=1:length(face)
                    faceThisLine=face(i,:);faceThisLine=faceThisLine(faceThisLine~=0);
                    ThisLineContent=faceThisLine;
                    fprintf(fid,'f %s\n',num2str(ThisLineContent,'%d '));
                end
            end
        end
    end
%% 结束obj文件的写入
    fclose(fid);
%% vt mtl and image part
    if vtAvalible
        mtlfid=fopen([pathoffile,file(1:end-4),'.mtl'],'w');
        fprintf(mtlfid,'newmtl material_0\n');
        fprintf(mtlfid,'Ka 0.200000 0.200000 0.200000\n');
        fprintf(mtlfid,'Kd 1.000000 1.000000 1.000000\n');
        fprintf(mtlfid,'Ks 1.000000 1.000000 1.000000\n');
        fprintf(mtlfid,'Tr 1.000000\n');
        fprintf(mtlfid,'illum 2\n');
        fprintf(mtlfid,'Ns 0.000000\n');
        if vtImgAvalible
            fprintf(mtlfid,'map_Kd %s\n',[file(1:end-4),'.png']);
        end
        fclose(mtlfid);
        if vtImgAvalible
            imwrite(imread(imagepath),[pathoffile,file(1:end-4),'.png']);
        end
    end

    
end