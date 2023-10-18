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

% 连杆参数
d1=100;
d3=100;
d4=100;

px=(q(3)+q(4)+d3+d4)*cosd(q(1));
py=(q(3)+q(4)+d3+d4)*sind(q(1));
pz=q(2)+d1;
pa=q(1)-q(5);

p=[px,py,pz,pa];
end
