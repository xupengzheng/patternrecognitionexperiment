function labels =linearclass(X,w,threshold)
%   线性分类器
%   w*x比threshold大划为第一类，否则为第二类
Nx = size(X,1);
labels = 2*ones(Nx,1);
results = X*w.';
labels(find(results>threshold)) = 1;
end

