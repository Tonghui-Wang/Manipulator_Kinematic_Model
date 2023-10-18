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
a3=100;

px=a3*cosd(q(3)+90);
py=q(1)+a3*sind(q(3)+90);
pz=q(2);
pa=q(3)-q(4);

p=[px,py,pz,pa];
end
