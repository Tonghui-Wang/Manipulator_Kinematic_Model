% 运动学正解推算
% @Time:2021/10/30 17:30
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
a1=400;
a2=400;

% 解耦补偿
% q(2)=q(2)-q(1);

% px=a1*sind(q(1) + 45) - a2*sind(q(1) + q(2));
% py=a2*cosd(q(1) + q(2)) - a1*cosd(q(1) + 45);
px=a1*sind(q(1) + 45) + a2*cosd(q(1) + q(2) + 45);
py=a2*sind(q(1) + q(2) + 45) - a1*cosd(q(1) + 45);

p=[px, py];
end
