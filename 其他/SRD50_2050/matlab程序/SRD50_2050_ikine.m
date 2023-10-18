% 运动学逆解推算
% @Time:2021/7/22 17:30
% @Auther:Tonghui Wang
% @File:SRD50_2050_ikine.m
% @software:MATLAB

clear;
clc;

q=deg2rad([0, 51, 0, 0, 0, 0]);

p=fkine(q);%正解
% disp(p);
q=ikine(p);%逆解
disp(q);

% 正解函数
% 输入：各关节角位移
% 输出：TCP位姿(XYZABC)
function [p]=fkine(q)

% 定义DH参数
a1=145; a2=870; a3=170;
d1=530; d4=1039; d6=225;

theta=[0, pi/2, 0, 0, -pi/2, 0];
d=[d1, 0, 0, d4, 0, d6];
a=[0, a1, a2, a3, 0, 0];
alpha=[0, pi/2, 0, pi/2, -pi/2, pi/2];

% 计算基座与末端的T矩阵
T=eye(4);
for i=1:6
    A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
    T=T*A;
end

p=[T(1:3,4)', rad2deg(tform2eul(T,'ZYX'))];
end

% 逆解函数
% 输入：TCP位姿(XYZABC)
% 输出：各关节角位移
function [q]=ikine(p)

a1=145; a2=870; a3=170;
d1=530; d4=1039; d6=225;

d=[d1, 0, 0, d4, 0, d6];
a=[0, a1, a2, a3, 0, 0];

T=eul2tform(deg2rad(p(4:6)),'ZYX');
T(1:3,4)=p(1:3)'-T(1:3,3)*d(6);

nx=T(1,1); ox=T(1,2); ax=T(1,3); px=T(1,4);
ny=T(2,1); oy=T(2,2); ay=T(2,3); py=T(2,4);
nz=T(3,1); oz=T(3,2); az=T(3,3); pz=T(3,4);

% q1
% q1=atan2(py,px);
q1=atan2(-py,-px);

% q2
r=sqrt(px^2+py^2)-a1;
s=pz-d1;
l23=a2;
l34=sqrt(a3^2+d4^2);
l24=sqrt(r^2+s^2);

c2=(l23^2+l24^2-l34^2)/(2*l23*l24);
q2=atan2(sqrt(1-c2^2),c2)+atan2(s,r)-pi/2;

% q3
c3=(l23^2+l34^2-l24^2)/(2*l23*l34);
q3=atan2(sqrt(1-c3^2),c3)+atan2(d4,a3)-pi;

% q4
q23=q2+q3;
q4=atan2(ay*cos(q1)-ax*sin(q1), ...
    (ax*cos(q1)+ay*sin(q1))*sin(q23)-az*cos(q23));

% q5
s5=(ax*cos(q1)+ay*sin(q1))*cos(q23)+az*sin(q23);
q5=atan2(s5, sqrt(1-s5^2));

% q6
q6=atan2(-(ox*cos(q1)+oy*sin(q1))*cos(q23)-oz*sin(q23), ...
    (nx*cos(q1)+ny*sin(q1))*cos(q23)+nz*sin(q23));

% if q5<0
%     q4=q4-pi;
%     q6=q6+pi;
% end

q=rad2deg([q1,q2,q3,q4,q5,q6]);
end

% A矩阵的计算函数(MDH方法)
function [A]=mdh_matrix(a,alpha,d,theta)
A=eye(4);
A(1,1)=cos(theta);
A(1,2)=-sin(theta);
A(1,3)=0;
A(1,4)=a;

A(2,1)=sin(theta)*cos(alpha);
A(2,2)=cos(theta)*cos(alpha);
A(2,3)=-sin(alpha);
A(2,4)=-sin(alpha)*d;

A(3,1)=sin(theta)*sin(alpha);
A(3,2)=cos(theta)*sin(alpha);
A(3,3)=cos(alpha);
A(3,4)=cos(alpha)*d;

A(4,1)=0;
A(4,2)=0;
A(4,3)=0;
A(4,4)=1;
end
