%输入: Tri
%输出: Adjacent
%根据三角关系找相邻点信息
function [Adjacent] = FindAdjByTri(Tri)
    MAXconnection=15;
    point_amount=max(Tri(:));triangle_amount=length(Tri);
    [graphIndex,overflow]=graphIndexGenerate(Tri,point_amount,triangle_amount,MAXconnection);
    if(sum(overflow)>0)
        disp('MAXconnection设置偏小,请调大');
        return
    end
    Adjacent.Count=sum((graphIndex>0)~=0,2);
	Adjacent.Adj_index=graphIndex;
end

function [graphIndex,overflow]=graphIndexGenerate(triangle2Point,point_amount,triangle_amount,MAXconnection)
%     MAXconnection=15;%运行完查看graphIndex的最后一列，为溢出的数量，可以参考溢出数量来增大MAXconnection的值
    graphIndex = zeros(point_amount,MAXconnection);%点序号的索引
    indexTop = ones(1,point_amount);
    overflow = zeros(point_amount,1);
    %(triangle_amount,3,3)
    for t = 1:triangle_amount
        for i = 1:3
            A = triangle2Point(t,mod(i+2,3)+1);
            B = triangle2Point(t,mod(i,3)+1);
            C = triangle2Point(t,mod(i+1,3)+1);
            
            Find = zeros(1,MAXconnection);
            Find(squeeze(graphIndex(A,:,1) == B)) = 1;
            Find_B = sum(Find);
            
            if(Find_B == 0)
                if(indexTop(A) > MAXconnection)
                    overflow(A) = overflow(A) + 1;
                else
                    graphIndex(A,indexTop(A)) = B;
                end
                indexTop(A) = indexTop(A) + 1;
            end
            
            Find = zeros(1,MAXconnection);
            Find(squeeze(graphIndex(A,:,1) == C)) = 1;
            Find_C = sum(Find);
            
            if(Find_C == 0)
                if(indexTop(A) > MAXconnection)
                    overflow(A) = overflow(A) + 1;
                else
                    graphIndex(A,indexTop(A)) = C;
                    indexTop(A) = indexTop(A) + 1;
                end
            end
        end
    end
    sort(graphIndex,2);
end

        
    