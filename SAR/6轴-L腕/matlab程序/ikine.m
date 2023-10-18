% 运动学逆解推算
% @Time:2021/11/12 17:30
% @Auther:Tonghui Wang
% @File:ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=ikine(p,qlast,flag)

% 连杆参数
a1=230;
a2=1740;
d2=811;
d3=1500;
d4=298;
d5=353;
d6=226;
lamda=6;

% 等效变换
R=eul2rotm(deg2rad(p(4:6)),'ZYX');
nx=R(1,1); ox=R(1,2); ax=R(1,3); px=p(1);
ny=R(2,1); oy=R(2,2); ay=R(2,3); py=p(2);
nz=R(3,1); oz=R(3,2); az=R(3,3); pz=p(3);
clear R p;

% 逆解计算
% q1
q1=rad2deg(atan2(ax,-ay));

% q2
q2=(pz-d2-d3)/(lamda-1);

% q3
q3=(sqrt(px^2+py^2-d4^2)+a1-a2)/lamda;

% q4
ab=a2/(lamda-1);
bc=d3/(lamda-1);

if q2<ab
    x=bc+q3;
    z=ab-q2;
    beta=acos((x^2+z^2+bc^2-ab^2)/(2*bc*sqrt(x^2+z^2)))-atan2(z,x);
else
    x=bc+q3;
    z=q2-ab;
    beta=acos((x^2+z^2+bc^2-ab^2)/(2*bc*sqrt(x^2+z^2)))+atan2(z,x);
end

q4=rad2deg(beta-atan2(oz,nz));

% 逆解结果，各关节位移
q=[q1,q2,q3,q4,0,0];
end
