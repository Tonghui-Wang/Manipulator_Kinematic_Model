clear;
clc;

% 连杆参数
syms a1 a2;
syms q1 q2;
pi=sym(pi);

%{
|_i_|_theta_|_d_|_a_|_alpha_|_q_|
| 1 |  -45  | 0 | 0 |   0   |ql |
| 2 |   90  | 0 |a1 |   0   |q2 |
| 3 |  -45  | 0 |a2 |   0   | 0 |
%}

a=[0,a1,a2];
d=[0,0,0];
alpha=[0,0,0];
theta=[-pi/4,pi/2,-pi/4];
q=[q1,q2,0];

T=sym(eye(4));
% 计算T矩阵
for i=1:3
    A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
%     disp(simplify(A));
    T=simplify(T*A);
end
% disp(T);
disp(T(1,4));
disp(T(2,4));


% 等效变换
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
