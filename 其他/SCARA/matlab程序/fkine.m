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
a1=375;
a2=275;

px=a1*cosd(q(1))+a2*cosd(q(1)+q(2));
py=a1*sind(q(1))+a2*sind(q(1)+q(2));
pz=q(3);
pa=q(1)+q(2)-q(4);

p=[px,py,pz,pa];
end
