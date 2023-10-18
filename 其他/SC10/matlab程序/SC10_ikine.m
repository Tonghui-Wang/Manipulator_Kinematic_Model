% 运动学正解推算
% @Time:2021/8/24 17:30
% @Auther:Tonghui Wang
% @File:SC10_ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=SC10_ikine(p)

% 连杆参数
a1=1304;
a3=950;
d1=600;
d3=1100-d1;

% TCP位姿
px=p(1); 
py=p(2);
pz=p(3);
pa=deg2rad(p(4));
pb=deg2rad(p(5));
pc=deg2rad(p(6));

r=sqrt(px^2+py^2);

curj3=2;%当前J3轴的角位移

% 求关节转角1
q11=atan2(py,px);
cq12=(a1^2+r^2-a3^2)/(2*a1*r);
sq12=sqrt(1-cq12^2);
q12=atan2(sq12,cq12);
q1=q11+q12;

% 求关节转角2
l2=pz-d1-d3;

% 求关节转角3
cq3=(a3^2+a1^2-r^2)/(2*a1*a3);
sq3=sqrt(1-cq3^2);
q3=atan2(sq3,cq3);

% 判断旋转方向
if q3*curj3<0
    q3=-q3;
    q1=q1-2*q12;
end

% 求关节转角4
q4=q1+q3-pa;

q=[rad2deg(q1),l2,rad2deg(q3),rad2deg(q4)];
end
