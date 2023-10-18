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
% d1=100;
% d5=100;
% a1=100;
% a2=100;
% a3=100;
% a4=100;

d1=0;
d5=80;
a1=0;
a2=400;
a3=400;
a4=80;

if (q(4)>180)
    q(4)=q(4)-360;
elseif(q(4)<=-180)
    q(4)=q(4)+360;
end       

% 解耦补偿
q(3)=q(3)-q(2);

px=(a1-a2*sind(q(2))+a3*cosd(q(2)+q(3))+a4)*cosd(q(1));
py=(a1-a2*sind(q(2))+a3*cosd(q(2)+q(3))+a4)*sind(q(1));
pz=d1+a2*cosd(q(2))+a3*sind(q(2)+q(3))-d5; 
pa=q(1)-q(4);

p=[px,py,pz,pa];
end
