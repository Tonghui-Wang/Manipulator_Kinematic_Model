clear;
clc;

% 连杆参数
syms d1 d3 a1 a2;
syms q1 q2 q3 q4;
pi=sym(pi);

%{
|_i_|_theta_|_d_|_a_|_alpha_|_q_|
| 1 |   90  |d1 | 0 |   0   |ql |
| 2 |  180  | 0 | a1|   0   |q2 |
| 3 |   0   |d3 | a2|  -90  |q3 |
| 4 |  -90  | 0 | 0 |  -90  |q4 |
%}

a=[0,a1,a2,0];
d=[d1,0,d3,0];
alpha=[0,0,-pi/2,-pi/2];
theta=[pi/2,pi,0,-pi/2];
q=[q1,q2,q3,q4];

T=sym(eye(4));
% 计算T矩阵
for i=1:4
    if i==1 || i==4
        A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
    else
        A=mdh_matrix(a(i),alpha(i),d(i)+q(i),theta(i));
    end
    A=simplify(A);
    disp(A);
    T=simplify(T*A);
end
disp(T);

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
