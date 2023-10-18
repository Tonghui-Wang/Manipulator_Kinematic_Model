% 运动学正解推算
% @Time:2021/11/12 17:30
% @Auther:Tonghui Wang
% @File:fkine.m
% @software:MATLAB

% 正解函数
% 输入：各关节位移
%	   旋转轴位移值单位为°,移动轴位移值单位为mm
% 输出：TCP位姿描述(XYZABC)
%	   XYZ输出值单位为mm,ABC输出值单位为°
function [p]=fkine(q)

% 连杆参数
a1=230;
a2=1740;
d2=811;
d3=1500;
d4=298;
d5=353;
d6=226;
lamda=6;

ab=a2/(lamda-1);
bc=d3/(lamda-1);

l2=q(2);
l3=q(3);

x=bc+l3;
z=abs(ab-l2);

if l2<ab
    beta=acos((x^2+z^2+bc^2-ab^2)/(2*sqrt(x^2+z^2)*bc))...
        -atan2(z,x);
else
    beta=acos((x^2+z^2+bc^2-ab^2)/(2*sqrt(x^2+z^2)*bc))...
        +atan2(z,x);
end

s1=sind(q(1));
c1=cosd(q(1));
s4=sind(rad2deg(beta)-q(4));
c4=cosd(rad2deg(beta)-q(4));

nx=c1*s4;
ox=-c1*c4;
ax=s1;
px=c1*(-a1+a2+lamda*q(3))-s1*d4;
ny=s1*s4;
oy=-c4*s1;
ay=-c1;
py=s1*(-a1+a2+lamda*q(3))+c1*d4;
nz=c4;
oz=s4;
az=0;
pz=d2+d3+q(2)*(lamda-1);

T=[nx,ox,ax,px;
    ny,oy,ay,py;
    nz,oz,az,pz;
    0,0,0,1];

p=[T(1:3,4)',rad2deg(tform2eul(T,'ZYX'))];
end
