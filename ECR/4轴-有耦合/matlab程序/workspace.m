% ECR系列工作空间对比
% 通过采样方法，比较23轴动态限位的有无对工作空间的影响
% 理论上替换fkine函数，也可拓展计算其他系列机型

% @Time:2021/11/22 17:30
% @Auther:Tonghui Wang
% @File:workspace.m
% @software:MATLAB

clear;
clc;

%随机采样次数(根据电脑性能和计算时长可更改)
n=1000000;

%关节限位(此处只为计算四轴机的23轴限位影响，也可拓展更多轴限位)
q1_lim=[-150,+150];%q1为角位移，单位°
q2_lim=[-75,+25];%q2为角位移，单位°
q3_lim=[-65,+23];%q3为角位移，单位°
q4_lim=[-180,+180];%q4为角位移，单位°

%工作空间比较
workspace1(n,q1_lim,q2_lim,q3_lim,q4_lim);%无动态限位
workspace2(n,q1_lim,q2_lim,q3_lim,q4_lim);%有动态限位

%不考虑23轴动态限位的工作空间切片(XOZ面投影)
function workspace1(n,q1_lim,q2_lim,q3_lim,q4_lim)

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
plot3(p(:,1),p(:,2),p(:,3),'r.');
hold on;

pose_max=max(p);
pose_min=min(p);
disp("|限位| X | Y | Z | A |");
disp(["|正限|",num2str(pose_max)]);
disp(["|负限|",num2str(pose_min)]);

%绘制边界值坐标
for i=1:2
    for j=1:2
        qtmp=[0,q2_lim(i),q3_lim(j),0];
        ptmp=fkine(qtmp);
        plot3(ptmp(1),ptmp(2),ptmp(3),'g*');
        joint=sprintf("q2=%d,q3=%d",q2_lim(i),q3_lim(j));
        text(ptmp(1),ptmp(2),ptmp(3),joint,'Color','g');
    end
end
end

%考虑23轴动态限位的工作空间切片(XOZ面投影)
function workspace2(n,q1_lim,q2_lim,q3_lim,q4_lim)

p=zeros(n,4);%初始化位姿矩阵
q=zeros(n,4);%初始化关节矩阵

%设置动态限位(纳博特思路)
q23_lim=[q2_lim(1)+q3_lim(2), q2_lim(2)+q3_lim(1)];%保留边界值的两个中位值
q23_lim=sort(q23_lim);%从小到大排列即为动态限位范围

%关节矩阵赋值
% q1=zeros(n,1);
q1=q1_lim(1)+diff(q1_lim)*rand(n,1);%q1在正负限位范围内进行蒙特卡洛随机采样
q2=q2_lim(1)+diff(q2_lim)*rand(n,1);%q2在正负限位范围内进行蒙特卡洛随机采样
for i=1:n
    q3_lim_new=q23_lim-q2(i,1);%根据每次q2的取值，实时更新q3新限位
    
    if q3_lim(1)>q3_lim_new(1)%与q3原负限位比较
        q3_lim_new(1)=q3_lim(1);%选择相对较大的数做实际取值的负限位
    end
    if q3_lim(2)<q3_lim_new(2)%与q3原正限位比较
        q3_lim_new(2)=q3_lim(2);%选择相对较小的数做实际取值的正限位
    end
    
    q3(i,1)=q3_lim_new(1)+diff(q3_lim_new)*rand;%q3在新正负限位范围内进行蒙特卡洛随机采样
end
q4=q4_lim(1)+diff(q4_lim)*rand(n,1);%q4在正负限位范围内进行蒙特卡洛随机采样
q=[q1,q2,q3,q4];

%绘制采样值正解后的笛卡尔坐标
for i=1:size(q,1)
    p(i,:)=fkine(q(i,:));
end
% figure(1);
plot3(p(:,1),p(:,2),p(:,3),'b.');
hold on;

pose_max=max(p);
pose_min=min(p);
disp("|限位| X | Y | Z | A |");
disp(["|正限|",num2str(pose_max)]);
disp(["|负限|",num2str(pose_min)]);

%绘制边界值坐标
% for i=1:2
%     for j=1:2
%         qtmp=[0,q2_lim(i),q3_lim(j),0];
%         ptmp=fkine(qtmp);
%         plot3(ptmp(1),ptmp(2),ptmp(3),'b*');
%         joint=sprintf("[%d,%d]",q2_lim(i),q3_lim(j));
%         text(ptmp(1),ptmp(2),ptmp(3),joint,'Color','b');
%     end
% end
end
