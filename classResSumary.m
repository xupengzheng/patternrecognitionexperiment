function [acc,Summary,Summaryinrate] = classResSummary(prelabel,truelabel)
%   对分类的结果进行统计
%   Summary为分类混淆矩阵
%   Summaryinrate为比率分类混淆矩阵
nlabels = max(truelabel);
Summary = zeros(nlabels+1);
Summaryinrate =zeros(nlabels+1);
for ii = 1:length(prelabel)
    Summary(truelabel(ii),prelabel(ii)) =  Summary(truelabel(ii),prelabel(ii))+1;
end
for ii = 1:nlabels
    Summary(ii,end) = sum(Summary(ii,1:end-1));
    Summaryinrate(ii,1:end-1) = Summary(ii,1:end-1)/Summary(ii,end);
    Summary(end,ii) = sum(Summary(1:end-1,ii));
end
Summary(end,end) = sum(Summary(end,1:end-1));
acc = sum(diag(Summary(1:end-1,1:end-1)))/Summary(end,end);
end
