% 运动学正解推算
% @Time:2021/04/16 17:30
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
d1=100;
d3=100;
a1=100;
a2=100;

px=(q(3)+d3)*cosd(q(1))-(a1-a2)*sind(q(1));
py=(q(3)+d3)*sind(q(1))+(a1-a2)*cosd(q(1));
pz=q(2)+d1;
pa=q(1)-q(4);

p=[px,py,pz,pa];
end
