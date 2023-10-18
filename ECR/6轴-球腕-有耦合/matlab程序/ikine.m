% 运动学逆解推算
% @Time:2021/11/17 17:30
% @Auther:Tonghui Wang
% @File:ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q,ierror]=ikine(p,flag)

% 连杆参数
a2=150;
a3=750;
a4=155;
d1=253;
d4=800;
d6=154;

% 等效变换
R=eul2rotm(deg2rad(p(4:6)),'ZYX');
nx=R(1,1); ox=R(1,2); ax=R(1,3); px=p(1);
ny=R(2,1); oy=R(2,2); ay=R(2,3); py=p(2);
nz=R(3,1); oz=R(3,2); az=R(3,3); pz=p(3);
clear R p;

px=px-ax*d6;
py=py-ay*d6;
pz=pz-az*d6;

% 逆解计算
% q1
q1=atan2(py, px);
if q1>0
    q1=q1+pi*flag(1);
else
    q1=q1-pi*flag(1);
end

% q3
K=(px^2+py^2+(pz-d1)^2+a2^2-a3^2-a4^2-d4^2-2*a2*(py*sin(q1)+px*cos(q1)))/(2*a3);
M=d4^2+(-a4)^2-(-K)^2;
if M>=0
    q3=atan2(-a4,d4)-atan2(-K,sqrt(M)*flag(2));
    ierror=0;
else
    q=[0,0,0,0,0,0];
    ierror=1;
    return;
end

% q2
M=pz-d1;
N=px*cos(q1)+py*sin(q1)-a2;
q23=atan2(M*(d4+a3*sin(q3))-N*(a4+a3*cos(q3)),...
          M*(a4+a3*cos(q3))+N*(d4+a3*sin(q3)));
q2=q23-q3;

% q4
q4=atan2(ax*sin(q1)-ay*cos(q1),...
        az*cos(q23)-(ax*cos(q1)+ay*sin(q1))*sin(q23));
if q4>0
    q4=q4+pi*flag(3);
else
    q4=q4-pi*flag(3);
end

% q5
S5=(ax*cos(q1)+ay*sin(q1))*cos(q23)+az*sin(q23);
C5=cos(q4)*((ax*cos(q1)+ay*sin(q1))*sin(q23)-az*cos(q23))...
    +sin(q4)*(ay*cos(q1)-ax*sin(q1));
q5=atan2(S5,C5);

% q6
K=[sin(q1)*cos(q4)+cos(q1)*sin(q23)*sin(q4);
   sin(q1)*sin(q23)*sin(q4)-cos(q1)*cos(q4);
   sin(q4)*cos(q23)];
M=[nx, ny, -nz];
N=[ox, oy, -oz];

S6=M*K;
C6=N*K;
q6=atan2(S6,C6);

clear K M N S5 C5 S6 C6;

% 逆解结果，各关节位移
q=rad2deg([q1,q2,q3+q2,q4,q5,q6]);
end
