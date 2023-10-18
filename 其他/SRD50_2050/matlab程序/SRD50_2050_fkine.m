% 运动学正解推算
% @Time:2021/7/5 17:30
% @Auther:Tonghui Wang
% @File:SRD50_2050_fkine.m
% @software:MATLAB

clear;
clc;

q=deg2rad([0,180,90,0,90,0]);

T=fkine(q);%正解
output=[T(1:3,4)',rad2deg(tform2eul(T,'ZYX'))];
disp(output);

% 正解函数
% 输入：各关节角位移
% 输出：位姿的齐次变换矩阵
function [T]=fkine(q)

%{
|_i_|_theta_|_d_|_a_|_alpha_|_angle_|
| 1 |   0   |d1 | 0 |   0   |   q1  |
| 2 |   90  | 0 |a1 |   90  |   q2  |
| 3 |   0   | 0 |a2 |   0   |   q3  |
| 4 |   0   |d4 |a3 |   90  |   q4  |
| 5 |  -90  | 0 | 0 |  -90  |   q5  |
| 6 |   0   |d6 | 0 |   90  |   q6  |
%}
% 定义DH参数
a1=145; a2=870; a3=170;
d1=530; d4=1039; d6=225;

theta=[0, pi/2, 0, 0, -pi/2, 0];
d=[d1, 0, 0, d4, 0, d6];
a=[0, a1, a2, a3, 0, 0];
alpha=[0, pi/2, 0, pi/2, -pi/2, pi/2];

% 计算基座与末端的T矩阵
T=eye(4);
for i=1:6
    A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
    T=T*A;
end
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
