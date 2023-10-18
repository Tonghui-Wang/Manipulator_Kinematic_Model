clear;
clc;

% 连杆参数
% a1=150;
% a2=580;
% a3=710;
% a4=105;
% d1=624;
% d2=15;
% d5=110;

syms a1 a2 a3 a4 d1 d2 d5;
syms q1 q2 q3 q4;
pi=sym(pi);

a=[0,a1,a2,a3];
d=[d1,d2,0,0];
alpha=[0,pi/2,0,pi/2];
theta=[0,pi/2,-pi/2,0];
q=[q1,q2,q3,q4];

q(3)=q(3)-q(2);

T=sym(eye(4));
% 计算T矩阵
for i=1:4
    A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
    A=simplify(A);
    T=simplify(T*A);
end

T(1,4)=T(1,4)+a4*cos(q(1));
T(2,4)=T(2,4)+a4*sin(q(1));
T(3,4)=T(3,4)-d5;

T=simplify(T);
disp(T(1,4));
disp(T(2,4));
disp(T(3,4));


% % 等效变换
% p=[T(1:3,4)',rad2deg(tform2eul(T,'ZYX'))];

% A矩阵的计算函数(MDH方法)
function [A]=mdh_matrix(a,alpha,d,theta)
A=sym(eye(4));
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
