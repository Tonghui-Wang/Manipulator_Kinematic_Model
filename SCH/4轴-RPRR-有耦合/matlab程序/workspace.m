% 工作空间计算
% 理论上替换fkine函数，也可拓展计算其他系列机型

% @Time:2021/11/20 17:30
% @Auther:Tonghui Wang
% @File:workspace.m
% @software:MATLAB

clear;
clc;

%随机采样次数(根据电脑性能和计算时长可更改)
n=100000;

%关节限位
q1_lim=[-180,+180];%q1为角位移，单位°
q2_lim=[0,+400];%q2为线位移，单位mm
q3_lim=[-180,+180];%q3为角位移，单位°
q4_lim=[-180,+180];%q4为角位移，单位°

%工作空间计算
space(n,q1_lim,q2_lim,q3_lim,q4_lim);

% p1=[-754.62, 98.6, 88.279, -88.8];%初始姿态
% p2=[1603.041, 25.351, -120.536, 2.301];%最终姿态
% scatter3(p1(1),p1(2),p1(3),"b*");hold on;
% scatter3(p2(1),p2(2),p2(3),"b*");hold on;
% plot3([p1(1),p2(1)],[p1(2),p2(2)],[p1(3),p2(3)],"r-");%起末点连线

%工作空间绘制
function space(n,q1_lim,q2_lim,q3_lim,q4_lim)

p=zeros(n,4);%初始化位姿矩阵
q=zeros(n,4);%初始化关节矩阵

%关节矩阵赋值
q1=q1_lim(1)+diff(q1_lim)*rand(n,1);%q1在正负限位范围内进行蒙特卡洛随机采样
q2=q2_lim(1)+diff(q2_lim)*rand(n,1);%q2在正负限位范围内进行蒙特卡洛随机采样
q3=q3_lim(1)+diff(q3_lim)*rand(n,1);%q3在正负限位范围内进行蒙特卡洛随机采样
q4=q4_lim(1)+diff(q4_lim)*rand(n,1);%q4在正负限位范围内进行蒙特卡洛随机采样
q=[q1,q2,q3,q4];

%绘制采样值正解后的笛卡尔坐标
for i=1:size(q,1)
    p(i,:)=fkine(q(i,:));
end
figure(1);
plot3(p(:,1),p(:,2),p(:,3),'.');
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
hold on;

%绘制边界值坐标
% for i=1:2
%     for j=1:2
%         qtmp=[0,q2_lim(i),q3_lim(j),0];
%         ptmp=fkine(qtmp);
%         plot3(ptmp(1),ptmp(2),ptmp(3),'g*');
%         joint=sprintf("q2=%d,q3=%d",q2_lim(i),q3_lim(j));
%         text(ptmp(1),ptmp(2),ptmp(3),joint,'Color','g');
%     end
% end
end
