% 运动学逆解推算
% @Time:2021/11/18 17:30
% @Auther:Tonghui Wang
% @File:ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=ikine(p, qlast)

% 定义DH参数
a1=120;
a2=500;
a3=400;

% 等效变换
px=p(1);
py=p(2);
pz=p(3)-a1;
pa=deg2rad(p(4));

if (pz*pz+px*px)<(a2-a3)*(a2-a3)
    q=qlast;
    return;
end

% q1
q1=-py;

% q2
tmp1=(px^2+pz^2+a2^2-a3^2)/(2*a2);
tmp2=atan2(pz,px)-atan2(tmp1, sqrt(pz^2+px^2-tmp1^2));
tmp3=atan2(pz,px)-atan2(tmp1, -sqrt(pz^2+px^2-tmp1^2));
if abs(qlast(2)-rad2deg(tmp2))<=abs(qlast(2)-rad2deg(tmp3))
    q2=tmp2;
else
    q2=tmp3;
end

% q3
q3=atan2(pz-a2*cos(q2),px+a2*sin(q2))-q2;

% q4
q4=-pa-q2-q3;
q4=atan2(sin(q4),cos(q4));
if (q4-deg2rad(qlast(4)))>pi
	q4=q4-pi*2;
elseif (q4-deg2rad(qlast(4)))<-pi
	q4=q4+pi*2;
end

q=[q1, rad2deg([q2,q3,q4])];
end
