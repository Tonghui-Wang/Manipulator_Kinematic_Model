% 运动学逆解推算
% @Time:2021/10/30 17:30
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
a1=400;
a2=400;

px=p(1);
py=p(2);

tmp1=(a2^2-a1^2-px^2-py^2)/(2*a1);
q1_1=atan2(py,px)-atan2(tmp1, sqrt(px^2+py^2-tmp1^2))-pi/4;
q1_2=atan2(py,px)-atan2(tmp1, -sqrt(px^2+py^2-tmp1^2))-pi/4;
if abs(rad2deg(q1_1)-qlast(1))<=abs(rad2deg(q1_2)-qlast(1))
    q1=q1_1;
else
    q1=q1_2;
end

% tmp1=a1*sin(q1+pi/4)-px;
% tmp2=a1*cos(q1+pi/4)+py;
% q2=atan2(tmp1, tmp2)-q1;

tmp1=-a1*sin(q1+pi/4)+px;
tmp2= a1*cos(q1+pi/4)+py;
q2=atan2(tmp2, tmp1)-q1-pi/4;

% 耦合补偿
% q2=q2+q1;

q=rad2deg([q1, q2]);
end
