pathofobj='C:\Users\njuee_000\Desktop\FullBodyWithImage.obj';

tic
[face,vertex,color,vt,vtface,vn,vnface]=obj_read_tooslow(pathofobj);
toc
%100.233030

tic
[Face,Vertex,Color,Vertext,Facet,Vertexn,Facen]=obj_read(pathofobj);
toc
%7.564675
