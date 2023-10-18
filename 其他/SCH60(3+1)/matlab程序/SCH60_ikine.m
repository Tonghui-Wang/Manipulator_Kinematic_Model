% 运动学正解推算
% @Time:2021/12/18 12:00
% @Auther:Tonghui Wang
% @File:SCD20_ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q,error]=SCD20_ikine(p)

%{
|_i_|_theta_|_d_|_a_|_alpha_|__axis__|
| 1 |   0   |d1 | 0 |   0   | axis1  |
| 2 |   0   | 0 |a2 |   0   | axis2  |
| 3 |  180  | 0 |a3 |   0   | axis3  |
| 4 |  180  |d4 |a4 |  180  | axis4  |
%}

% 连杆参数
d1=500;
d4=200;
a2=200;
a3=1200;
a4=550;

% TCP位姿
px=p(1)-a2; 
py=p(2);
pz=p(3)-d1+d4;
pa=deg2rad(p(4));

% q1
q1=pz;

% q2
tmp1=(px^2+py^2+a3^2-a4^2)/(2*a3*sqrt(px^2+py^2));
if tmp>1
    tmp1=1
elseif tmp1<-1
    tmp1=-1
end
q2=atan2(py,px)+acos(tmp1);

% q3
tmp1=(a3^2+a4^2-px^2-py^2)/(2*a3*a4);
if tmp1>1
    tmp1=1
elseif tmp1<-1
    tmp1=-1
end
q3=acos(tmp1);

% q4
q4=q2+q3-pa;
q4=atan2(sin(q4),cos(q4));

q=[q1,rad2deg([q2,q3,q4])];
end
