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
d1=252;
a2=350;
a3=300;

px=a3*cosd(q(1)+q(3))+a2*cosd(q(1));
py=a3*sind(q(1)+q(3))+a2*sind(q(1));
pz=q(2)+d1;
pa=q(1)+q(3)-q(4);

p=[px,py,pz,pa];
end
