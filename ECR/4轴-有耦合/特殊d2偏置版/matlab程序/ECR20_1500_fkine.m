% 运动学正解推算
% @Time:2021/10/07 17:30
% @Auther:Tonghui Wang
% @File:ECR20_1500_fkine.m
% @software:MATLAB

% 正解函数
% 输入：各关节位移
%	   旋转轴位移值单位为°,移动轴位移值单位为mm
% 输出：TCP位姿描述(XYZABC)
%	   XYZ输出值单位为mm,ABC输出值单位为°
function [p]=ECR20_1500_fkine(q)

% 连杆参数
a1=150;
a2=580;
a3=710;
a4=105;
d1=624;
d2=15;
d5=110;

q=deg2rad(q);

% 位姿计算
x=cos(q(1))*(a1 - a2*sin(q(2)) + a3*cos(q(3)) + a4)+sin(q(1))*d2;
y=sin(q(1))*(a1 - a2*sin(q(2)) + a3*cos(q(3)) + a4)-cos(q(1))*d2;
z=d1 + a2*cos(q(2)) + a3*sin(q(3)) - d5;
a=rad2deg(q(1) - q(4));
b=0;
c=-180;

% 结果输出
p=[x,y,z,a,b,c];
end
