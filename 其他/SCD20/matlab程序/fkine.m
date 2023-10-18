% 运动学正解推算
% @Time:2021/12/18 12:00
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
d4=0;
a1=0;
a2=1250;
a3=600;

x=a1+a2*cosd(q(2))-a3*cosd(q(2)+q(3));
y=a2*sind(q(2))-a3*sind(q(2)+q(3));
z=q(1)+d1-d4;
a=q(2)+q(3)-q(4);

p=[x,y,z,a];
end
