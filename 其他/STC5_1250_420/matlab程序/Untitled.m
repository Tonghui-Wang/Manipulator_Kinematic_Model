clear;
clc;

% 连杆参数
syms d1 d3 d4 a3;
syms q1 q2 q3 q4;
pi=sym(pi);

%{
|_i_|_theta_|_d_|_a_|_alpha_|_axis_l__|
| 1 |   0   |d1 | 0 |   0   | axis1_l |
| 2 |  -90  | 0 | 0 |   0   | axis1_2 |
| 3 |   0   |d3 | 0 |  -90  | axis1_3 |
| 4 |  -90  |d4 | -a3 |  -90  | axis1_4 |
%}

theta=[0, -pi/2, 0, -pi/2];
d=[d1, 0, d3, d4];
a=[0, 0, 0, -a3];
alpha=[0, 0, -pi/2, -pi/2];

q=[q1, q2, q3, q4];

T=sym(eye(4));
% 计算T矩阵
for i=1:4
    if i==1 || i==4
        A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
    elseif i==2 || i==3
        A=mdh_matrix(a(i),alpha(i),d(i)+q(i),theta(i));
    end
    disp(simplify(A));
    T=simplify(T*A);
end
disp(T(1,4))
disp(T(2,4))
disp(T(3,4))

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
