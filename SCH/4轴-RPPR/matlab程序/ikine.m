% 运动学逆解推算
% @Time:2022/04/16 17:30
% @Auther:Tonghui Wang
% @File:ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=ikine(p,qlast)

% DH参数
d1=100;
d3=100;
a1=100;
a2=100;

px=p(1);
py=p(2);
pz=p(3);
pa=p(4);

q3=sqrt(px^2+py^2-(a1-a2)^2)-d3;

tmp1=rad2deg(atan2(a1-a2+d3+q3,a1-a2-d3-q3)-atan2(px+py,px-py));
tmp2=rad2deg(atan2(a1-a2+d3+q3,a1-a2-d3-q3)-atan2(px+py,py-px));
if abs(qlast(1)-tmp1)<=abs(qlast(1)-tmp2)
    q1=tmp1;
else
    q1=tmp2;
end

q2=pz-d1;
q4=q1-pa;

% 无a1 a2的情况
% q1=rad2deg(atan2(py,px));
% q2=pz-d1;
% q3=sqrt(px^2+py^2)-d3;
% q4=q1-pa;

q=[q1, q2, q3, q4];
end
