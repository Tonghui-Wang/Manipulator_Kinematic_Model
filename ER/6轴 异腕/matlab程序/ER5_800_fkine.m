% 运动学正解推算
% @Time:2021/7/15 17:30
% @Auther:Tonghui Wang
% @File:ER5_800_fkine.m
% @software:MATLAB

clear;
clc;

q=deg2rad([10,5,-10,10,5,0]);

p=fkine(q);%正解
disp(p);

% 正解函数
% 输入：各关节角位移
% 输出：TCP位姿(XYZABC)
function [p]=fkine(q)

% 定义DH参数
a1=70; a2=350; a3=78; a5=70;
d1=163; d4=380; d6=112;

theta=[0, pi/2, 0, 0, 0, 0];
d=[d1, 0, 0, d4, 0, d6];
a=[0, a1, a2, a3, 0, a5];
alpha=[0, pi/2, 0, pi/2, -pi/2, pi/2];

% 计算基座与末端的T矩阵
T=eye(4);
for i=1:6
    A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
    T=T*A;
end

p=[T(1:3,4)', rad2deg(tform2eul(T,'ZYX'))];
end

% A矩阵的计算函数(MDH方法)
function [A]=mdh_matrix(a,alpha,d,theta)
A=eye(4);
A(1,1)=cos(theta);
A(1,2)=-sin(theta);
A(1,3)=0;
A(1,4)=a;

A(2,1)=sin(theta)*cos(alpha);
A(2,2)=cos(theta)*cos(alpha);
A(2,3)=-sin(alpha);
A(2,4)=-sin(alpha)*d;

A(3,1)=sin(theta)*sin(alpha);
A(3,2)=cos(theta)*sin(alpha);
A(3,3)=cos(alpha);
A(3,4)=cos(alpha)*d;

A(4,1)=0;
A(4,2)=0;
A(4,3)=0;
A(4,4)=1;
end
