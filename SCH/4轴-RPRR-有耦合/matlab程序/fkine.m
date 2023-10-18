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
d1=0;
a2=300;
a3=100;
% d1=0;
% a2=800;
% a3=1250;

c1=1;   %J1J3耦合比
c2=0.5; %J1J4耦合比
c3=0.7; %J3J4耦合比

%解耦
q(4)=q(4)-q(1)*c2-q(3)*c3;
q(3)=q(3)-q(1)*c1;

px=a3*cosd(q(1)+q(3))+a2*cosd(q(1));
py=a3*sind(q(1)+q(3))+a2*sind(q(1));
pz=q(2)+d1;
pa=q(1)+q(3)-q(4);
if pa>=180
    pa=pa-360;
elseif pa<=-180
    pa=pa+360;
end

p=[px,py,pz,pa];
end
