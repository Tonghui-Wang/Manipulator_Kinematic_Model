% 运动学正解推算
% @Time:2021/8/10 17:30
% @Auther:Tonghui Wang
% @File:fkine.m
% @software:MATLAB

% 正解函数
% 输入：各关节位移
%	   旋转轴位移值单位为°,移动轴位移值单位为mm
% 输出：TCP位姿描述(XYZABC)
%	   XYZ输出值单位为mm,ABC输出值单位为°
function [p]=fkine(q)

% 连杆参数
% a1=100;
% a2=100;
% a3=100;
% d1=20;
% d2=100;
% d3=100;
% d4=100;

a1=192;
a2=1740;
a3=150;
d1=290;
d2=0;
d3=1380;
d4=149.5;

lamda=a2/d1;

% 位姿计算
x=(lamda*q(3)+a2+a3-a1)*cosd(q(1));
y=(lamda*q(3)+a2+a3-a1)*sind(q(1));
z=(lamda-1)*q(2)+d2+d3-d4;
a=q(1)-q(4);
b=0;
c=0;

% 结果输出
p=[x,y,z,a,b,c];
end
