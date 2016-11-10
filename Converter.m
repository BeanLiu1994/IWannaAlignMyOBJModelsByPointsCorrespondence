classdef Converter
    methods(Static)
        %% X 3p x 1 <=> p x 3
        function XResize=ResizeX_3p_2_px3(XBefore)
            XResize = zeros(3,length(XBefore)/3);
            XResize(:) = XBefore;
            XResize = XResize';
        end
        function XResize=ResizeX_px3_2_3p(XBefore)
            XResize = zeros(3*length(XBefore),1);
            XResize(:) = XBefore';
        end
        %% W 2p x 1 <=> p x 2
        function XResize=ResizeX_2p_2_px2(XBefore)
            XResize = zeros(2,length(XBefore)/2);
            XResize(:) = XBefore;
            XResize = XResize';
        end
        function XResize=ResizeX_px2_2_2p(XBefore)
            XResize = zeros(2*length(XBefore),1);
            XResize(:) = XBefore';
        end
        %% P 2 x 3 => 2p x 3p 
        function R=repmat_diag(A,n)
            %repeat blk A n times
            %AÊÇ¶þÎ¬µÄ
            [s1,s2,~]=size(A);
            numelofA=numel(A);
            newsize=size(A)*n;
            [r,c]=ind2sub([s1,s2],1:6);
            x1=zeros(numelofA*n,1);x2=x1;values=repmat(A(:),[n,1]);
            for i=1:n
                x1(numelofA*(i-1)+1:numelofA*i)=r+s1*(i-1);
                x2(numelofA*(i-1)+1:numelofA*i)=c+s2*(i-1);
            end
            R=sparse(x1,x2,values,size(A,1)*n,size(A,2)*n);
        end
        function out=repmat_PFill(P,p)
            out=Converter.repmat_diag(P,p);
        end
        %% D p x q => 3p x 3p
        function Di=Full_D(D_prototype)
            [p,q]=size(D_prototype);
            [r,c]=find(D_prototype==1);r=r';
            temp=[r*3-2;r*3-1;r*3];
            x1=temp(:);
            Di=sparse(x1,x1,ones(size(x1)),3*p,3*p);
        end
        % D p x q => 2p x 2p
        function Di=F2p_D(D_prototype)
            [p,q]=size(D_prototype);
            [r,c]=find(D_prototype==1);r=r';
            temp=[r*2-1;r*2];
            x1=temp(:);
            Di=sparse(x1,x1,ones(size(x1)),2*p,2*p);
        end
        %% W m x 2q => m x 2p
        function FullW=Full_W(W,Correspondence,p)
            m=size(W,1);
            q=length(Correspondence);
            NewInd=[Correspondence'*2-1;Correspondence'*2];
            NewInd=NewInd(:);
            x1=repmat(1:m,[2*q,1]);x1=x1(:);
            x2=repmat(NewInd,[1,m]);x2=x2(:);
            W=W'; 
            FullW=sparse(x1,x2,W(:),m,2*p);
        end
        function W=SelectW(W_in,list_in)
            list=zeros(size(W_in,2),2*length(list_in));
            for i=1:size(W_in,2)/2
                [a]=find(list_in==i);
                if ~isempty(a)
                    list(i*2,2*a)=1;
                    list(i*2-1,2*a-1)=1;
                end
            end
            W=W_in*list;
        end
        %% rou px1 => px4
        function rou=FullRou(rou)
            rou=rou(:,1);
            rou=repmat(rou,[1,4]);
        end
        %% L pxp => 3px3p
        function L=expandL(L_Base)
            [r,c,v]=find(L_Base);
            x1=[3*r-2,3*r-1,3*r];x1=x1(:);
            x2=[3*c-2,3*c-1,3*c];x2=x2(:);
            values=[v,v,v];values=values(:);
            L=sparse(x1,x2,values);
        end
    end
end