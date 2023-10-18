% 运动学正解推算
% @Time:2021/11/18 17:30
% @Auther:Tonghui Wang
% @File:fkine.m
% @software:MATLAB

% 正解函数
% 输入：各关节位移
%	   旋转轴位移值单位为°,移动轴位移值单位为mm
% 输出：TCP位姿描述(XYZABC)
%	   XYZ输出值单位为mm,ABC输出值单位为°
function [p]=fkine(q)

% 定义DH参数
a1=120;
a2=500;
a3=400;

px=a3*cosd(q(2)+q(3))-a2*sind(q(2));
py=-q(1);
pz=a3*sind(q(2)+q(3))+a2*cosd(q(2))+a1;
pa=-q(2)-q(3)-q(4);
pa=rad2deg(atan2(sind(pa),cosd(pa)));

p=[px,py,pz,pa];
end
