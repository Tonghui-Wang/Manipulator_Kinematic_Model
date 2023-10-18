% 运动学正解推算
% @Time:2021/7/29 17:30
% @Auther:Tonghui Wang
% @File:fkine.m
% @software:MATLAB

% 正解函数
% 输入：各关节位移
%	   旋转轴位移值单位为°,移动轴位移值单位为mm
% 输出：TCP位姿描述(XYZABC)
%	   XYZ输出值单位为mm,ABC输出值单位为°
function [p]=fkine(q)

% DH参数
d1=0;
d3=100;
d4=0;
a3=36.5;

px=(d3+q(3))*cosd(q(1))-a3*sind(q(1));
py=(d3+q(3))*sind(q(1))+a3*cosd(q(1));
pz=q(2);
pa=q(1)-q(4);

p=[px,py,pz,pa];
end
