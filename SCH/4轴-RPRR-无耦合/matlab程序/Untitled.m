clear;
clc;

syms d1 a2 a3;
syms q1 q2 q3 q4;
pi=sym(pi);

%{
|_i_|_theta_|_d_|_a_|_alpha_|_q_|
| 1 |   0   |d1 | 0 |   0   |ql |
| 2 |   0   | 0 | 0 |   0   |q2 |
| 3 |   0   | 0 |a2 |   0   |q3 |
| 4 |   0   | 0 |a3 |  180  |q4 |
%}

a=[0, 0, a2, a3];
alpha=[0, 0, 0, pi];
d=[d1, 0, 0, 0];
theta=[0, 0, 0, 0];
q=[q1,q2,q3,q4];

T=sym(eye(4));
% 计算T矩阵
for i=1:4
    if i==2
		A=mdh_matrix(a(i),alpha(i),d(i)+q(i),theta(i));
    else
        A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
    end
    disp(A);
    T=simplify(T*A);
end
disp(T);

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
