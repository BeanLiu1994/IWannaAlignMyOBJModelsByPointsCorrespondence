function obj_write(file,face,vertex,   color,   vt,fvt,imagepath,   vn,fvn)
%% support 'v' 'f' ‘vt' infomation
%%
NameBegin=sort([find(file=='/'),find(file=='\')]);
if ~isempty(NameBegin)
    NameBegin=NameBegin(end);
else
    NameBegin=0;
end
pathoffile=file(1:NameBegin);
file=file(NameBegin+1:end);
fid=fopen([pathoffile,file],'w');
if nargin == 3
    for i=1:length(vertex)
        fprintf(fid,'v %f %f %f\n',vertex(i,1),vertex(i,2),vertex(i,3));
    end
    for i=1:length(face)
        fprintf(fid,'f %d %d %d\n',face(i,1),face(i,2),face(i,3));
    end
    fclose(fid);
elseif nargin == 4
    if isempty(color)
        for i=1:length(vertex)
            fprintf(fid,'v %f %f %f\n',vertex(i,1),vertex(i,2),vertex(i,3));
        end
    else
        for i=1:length(vertex)
            fprintf(fid,'v %f %f %f %f %f %f\n',vertex(i,1),vertex(i,2),vertex(i,3),color(i,1),color(i,2),color(i,3));
        end
    end
    for i=1:length(face)
        fprintf(fid,'f %d %d %d\n',face(i,1),face(i,2),face(i,3));
    end
    fclose(fid);
elseif nargin == 7
    fprintf(fid,'mtllib %s\n',[file(1:end-4),'.mtl']);
    fprintf(fid,'usemtl material_0\n');
    if isempty(color)
        color=[];
        for i=1:length(vertex)
            fprintf(fid,'v %f %f %f\n',vertex(i,1),vertex(i,2),vertex(i,3));
        end
    else
        for i=1:length(vertex)
            fprintf(fid,'v %f %f %f %f %f %f\n',vertex(i,1),vertex(i,2),vertex(i,3),color(i,1),color(i,2),color(i,3));
        end
    end
    for i=1:length(vt)
        fprintf(fid,'vt %f %f\n',vt(i,1),vt(i,2));
    end
    for i=1:length(face)        
        fprintf(fid,'f %d/%d %d/%d %d/%d\n',face(i,1),fvt(i,1),face(i,2),fvt(i,2),face(i,3),fvt(i,3));
%         fprintf(fid,'f %d/%d/%d %d/%d/%d %d/%d/%d\n',face(i,1),fvt(i,1),face(i,1),face(i,2),fvt(i,2),face(i,2),face(i,3),fvt(i,3),face(i,3));
    end
    fclose(fid);
    mtlfid=fopen([pathoffile,file(1:end-4),'.mtl'],'w');
    fprintf(mtlfid,'newmtl material_0\n');
    fprintf(mtlfid,'Ka 0.200000 0.200000 0.200000\n');
    fprintf(mtlfid,'Kd 1.000000 1.000000 1.000000\n');
    fprintf(mtlfid,'Ks 1.000000 1.000000 1.000000\n');
    fprintf(mtlfid,'Tr 1.000000\n');
    fprintf(mtlfid,'illum 2\n');
    fprintf(mtlfid,'Ns 0.000000\n');
    fprintf(mtlfid,'map_Kd %s\n',[file(1:end-4),'.png']);
    fclose(mtlfid);
    imwrite(imread(imagepath),[pathoffile,file(1:end-4),'.png']);
    save([pathoffile,file(1:end-4),'.mat'],'face','vertex','color','vt','fvt','imagepath');
elseif nargin==9
    if(~isempty(vt))
        fprintf(fid,'mtllib %s\n',[file(1:end-4),'.mtl']);
        fprintf(fid,'usemtl material_0\n');
    end
    if isempty(color)
        color=[];
        for i=1:length(vertex)
            fprintf(fid,'v %f %f %f\n',vertex(i,1),vertex(i,2),vertex(i,3));
        end
    else
        for i=1:length(vertex)
            fprintf(fid,'v %f %f %f %f %f %f\n',vertex(i,1),vertex(i,2),vertex(i,3),color(i,1),color(i,2),color(i,3));
        end
    end
    if(~isempty(vn))
        for i=1:length(vn)
            fprintf(fid,'vn %f %f %f\n',vn(i,1),vn(i,2),vn(i,3));
        end
        if(isempty(fvn)&&length(vn)==length(vertex))
            fvn=face;
        end
    end
    if(~isempty(vt))
        for i=1:length(vt)
            fprintf(fid,'vt %f %f\n',vt(i,1),vt(i,2));
        end
        if(isempty(fvt)&&length(vt)==length(vertex))
            fvt=face;
        end
    end
    if(isempty(vn))
        if(isempty(vt))
            for i=1:length(face)        
                fprintf(fid,'f %d %d %d\n',face(i,1),face(i,2),face(i,3));
        %         fprintf(fid,'f %d/%d/%d %d/%d/%d %d/%d/%d\n',face(i,1),fvt(i,1),face(i,1),face(i,2),fvt(i,2),face(i,2),face(i,3),fvt(i,3),face(i,3));
            end
        else
            for i=1:length(face)        
                fprintf(fid,'f %d/%d %d/%d %d/%d\n',face(i,1),fvt(i,1),face(i,2),fvt(i,2),face(i,3),fvt(i,3));
        %         fprintf(fid,'f %d/%d/%d %d/%d/%d %d/%d/%d\n',face(i,1),fvt(i,1),face(i,1),face(i,2),fvt(i,2),face(i,2),face(i,3),fvt(i,3),face(i,3));
            end
        end
    elseif(isempty(vt))
        for i=1:length(face)        
            fprintf(fid,'f %d//%d %d//%d %d//%d\n',face(i,1),fvn(i,1),face(i,2),fvn(i,2),face(i,3),fvn(i,3));
            %         fprintf(fid,'f %d/%d/%d %d/%d/%d %d/%d/%d\n',face(i,1),fvt(i,1),face(i,1),face(i,2),fvt(i,2),face(i,2),face(i,3),fvt(i,3),face(i,3));
        end
    else
        for i=1:length(face)        
            fprintf(fid,'f %d/%d/%d %d/%d/%d %d/%d/%d\n',face(i,1),fvt(i,1),fvn(i,1),face(i,2),fvt(i,2),fvn(i,2),face(i,3),fvt(i,3),fvn(i,3));
    %         fprintf(fid,'f %d/%d/%d %d/%d/%d %d/%d/%d\n',face(i,1),fvt(i,1),face(i,1),face(i,2),fvt(i,2),face(i,2),face(i,3),fvt(i,3),face(i,3));
        end
    end
    fclose(fid);
    if(~isempty(vt))
        mtlfid=fopen([pathoffile,file(1:end-4),'.mtl'],'w');
        fprintf(mtlfid,'newmtl material_0\n');
        fprintf(mtlfid,'Ka 0.200000 0.200000 0.200000\n');
        fprintf(mtlfid,'Kd 1.000000 1.000000 1.000000\n');
        fprintf(mtlfid,'Ks 1.000000 1.000000 1.000000\n');
        fprintf(mtlfid,'Tr 1.000000\n');
        fprintf(mtlfid,'illum 2\n');
        fprintf(mtlfid,'Ns 0.000000\n');
        if(~isempty(pathoffile))
            fprintf(mtlfid,'map_Kd %s\n',[file(1:end-4),'.png']);
        end
        fclose(mtlfid);
        if(~isempty(pathoffile))
            imwrite(imread(imagepath),[pathoffile,file(1:end-4),'.png']);
        end
        save([pathoffile,file(1:end-4),'.mat'],'face','vertex','color','vt','fvt','imagepath');
    end
else
    disp('未保存,因为输入参数有误')
end