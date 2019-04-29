function [Mconver,Xlabelcover,Mhistory,Xlabelhistory] = Cmeancluster(X,M)
%   C均值聚类方法
%   X为样本数据，M为初值中心 
%   Mconver为最终收敛到的类别中心,Mhistory包含类别中心的每次迭代的历史结果
%   Xlabelcover为最终类别结果,Xlabelhistory每次迭代的类别历史结果
while(flag ==1)
    flag = 0;
    nclass = size(M,1);
    for i = 1:size(X,1)
        x = X(1,:);
        labe = nearest(x,M);
    end
    m = zeros(size(M));
    for i = 1:size(X,1)
        m(X(i,end),:) =  m(X(i,end),:) + X(i,1:end-1);
        labe = nearest(x,M);
    end
    flag = notisequal()
end
end

