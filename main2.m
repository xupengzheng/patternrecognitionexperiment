clear all;
close all;
%% 参数
mu1 = [-2,-2];sigma1=[1 0;0 1];
mu2 = [ 2,2]; sigma2=[1 0;0 4]; 
%% 产生仿真数据
N = 1100;
X1 = mvnrnd(mu1,sigma1,1100);
X2 = mvnrnd(mu2,sigma2,1100);
Ntrain = 100;
X1Train = X1(1:Ntrain,:);
X2Train = X2(1:Ntrain,:);
XTrain = [X1Train,ones(Ntrain,1);X2Train,2*ones(Ntrain,1)];
XTest = [ X1(Ntrain+1:end,:),ones(N-Ntrain,1); X2(Ntrain+1:end,:),2*ones(N-Ntrain,1)];
%% 画出仿真数据散点图
mulclasscatter2(XTrain);
title('训练样本分布');
axis equal;
%% fisher 线性分类器设计
mu1T = mean(X1Train)
mu2T = mean(X2Train)
sigmaX1T = cov(X1Train)
sigmaX2T = cov(X2Train)
sw = sigmaX1T + sigmaX2T;
w = (sw^-1*(mu1T-mu2T).').';
%% 画出投影平面
center = (mu1T+mu2T)/2;
xsweep = -6:6;
points = center  +  xsweep.'*w;
h = plot(points(:,1),points(:,2),'DisplayName','投影平面');
%% 画出决策平面
n = [w(2),-w(1)];
%xsweep = -5:5;
points = center  +  xsweep.'*n;
h = plot(points(:,1),points(:,2),'DisplayName','分类平面');
%% 分类
%训练集分类并总结错误率
threshold = center*w.';
Trprelabel =linearclass(XTrain(:,1:end-1),w,threshold);
[Tracc,TrSummary,TrSummaryinrate] = classResSumary(Trprelabel,XTrain(:,end))
disp('训练集错误率');
PeTr = 1 - Tracc
%测试集分类并总结错误率
Teprelabel =linearclass(XTest(:,1:end-1),w,threshold);
[Teacc,TeSummary,TeSummaryinrate] = classResSumary(Teprelabel,XTest(:,end))
disp('测试集错误率');
PeTe = 1 - Teacc
%% 计算Bhattacharyya误差界限
Jb = 1/8*(mu2-mu1)/((sigma1+sigma2)/2)*(mu2-mu1).'...
    + 0.5*log(det((sigma1+sigma2)/2)/sqrt(det(sigma1)*det(sigma2)));
disp('理论误差限:');
pe = 0.5*exp(-Jb)
disp('1-理论误差限:');
acc = 1 - pe



