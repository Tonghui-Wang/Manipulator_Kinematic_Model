% 运动学正解推算
% @Time:2021/10/9 17:30
% @Auther:Tonghui Wang
% @File:ECR20_1500_ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=ECR20_1500_ikine(p)
% 连杆参数
a1=150;
a2=580;
a3=710;
a4=105;
d1=624;
d2=15;
d5=110;

% TCP位姿
px=p(1);
py=p(2);
pz=p(3);
pa=deg2rad(p(4));
pb=deg2rad(p(5));
pc=deg2rad(p(6));

% 求关节转角1
W=sqrt(px^2+py^2-d2^2);
q1=atan2(W-d2,-W-d2)-atan2(px+py,-sqrt((W-d2)^2+(-W-d2)^2-(px+py)^2));

if q1>pi
    q1=q1-pi*2;
elseif q1<-pi
    q1=q1+pi*2;
end

% 求关节转角4
q4=q1 - pa;
q4=atan2(sin(q4), cos(q4));

% 求关节转角2
px=px - cos(q1)*a4 - sin(q1)*d2;
py=py - sin(q1)*a4 + cos(q1)*d2;
pz=pz + d5 - d1;

temp=sqrt(px^2 + py^2)-a1;

q21=atan2(pz, temp);
q22=acos((a2^2 + temp^2 + pz^2 - a3^2)/(2*a2*sqrt(temp^2+pz^2)));
q2=q21 + q22 - pi/2;

% 求关节转角3
c3=(a2^2 + a3^2 - (temp^2+pz^2))/(2*a2*a3);
q3=acos(c3) - (pi/2-q2);

q=rad2deg([q1,q2,q3,q4]);
end
