clear all;
close all;
rng(5);
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
h = plot(points(:,1),points(:,2),'DisplayName','Fisher投影平面');
%% 画出决策平面
n = [w(2),-w(1)];
%xsweep = -5:5;
points = center  +  xsweep.'*n;
h = plot(points(:,1),points(:,2),'DisplayName','Fisher分类平面');
%% 分类
%训练集分类并总结错误率
threshold = center*w.';
Trprelabel =linearclass(XTrain(:,1:end-1),w,threshold);
[Tracc,TrSummary,TrSummaryinrate] = classResSumary(Trprelabel,XTrain(:,end))
disp(['训练集错误率' num2str(1 - Tracc)]);
%测试集分类并总结错误率
Teprelabel =linearclass(XTest(:,1:end-1),w,threshold);
[Teacc,TeSummary,TeSummaryinrate] = classResSumary(Teprelabel,XTest(:,end))
disp(['测试集错误率' num2str(1 - Teacc)]);
%% 计算Bhattacharyya误差界限
Jb = 1/8*(mu2-mu1)/((sigma1+sigma2)/2)*(mu2-mu1).'...
    + 0.5*log(det((sigma1+sigma2)/2)/sqrt(det(sigma1)*det(sigma2)));
pe = 0.5*exp(-Jb);
disp(['Bhattacharyya理论误差限:' num2str(pe)]);
%% 贝叶斯理论误差
syms x
syms y 
if size(mu1,2)~=1
mu1 = mu1.';
mu2 = mu2.';
end
XY = [x;y];
pxw1 = 1/(2*pi*sqrt(det(sigma1)))*exp(-(XY-mu1).'*inv(sigma1)*(XY-mu1)/2);
pxw2 = 1/(2*pi*sqrt(det(sigma2)))*exp(-(XY-mu2).'*inv(sigma2)*(XY-mu2)/2);
%贝叶斯决策曲线
g = solve(pxw1==pxw2,x);
gnumeric = str2func(['@(y)',vectorize(simplify(g))]);
%画出贝叶斯决策面
figure(1);
tempy=-15:0.01:10;
tempx = feval(gnumeric,tempy);
plot(tempx,tempy,'DisplayName','贝叶斯决策面')
%通过积分计算pe1
h1 = int(pxw1,x,g,inf);
fy1 = str2func(['@(y)',vectorize(simplify(h1))]);
pe1 = integral(fy1,-inf,inf);
%通过积分计算pe2
h2 = int(pxw2,x,-inf,g);
fy2 = str2func(['@(y)',vectorize(simplify(h2))]);
pe2 = integral(fy2,-inf,inf);
%贝叶斯理论误差
pe = 0.5*pe1 + 0.5*pe2;
disp(['贝叶斯理论误差:' num2str(pe)]);