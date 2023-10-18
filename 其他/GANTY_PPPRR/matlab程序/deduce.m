clear;
clc;

% 连杆参数
syms a6 d6;
syms q1 q2 q3 q4 q5;
syms nx ny nz ox oy oz ax ay az px py pz;
pi=sym(pi);

%{
|_i_|_theta_|_d_|__a__|_alpha_|_axis_l__|
| 4 |  -90  | 0 |  0  |  -90  | axis1_4 |
| 5 |   90  | 0 |  0  |  -90  | axis1_5 |
| 6 |  -90  |d6 | a6  |  -90  |    0    |
%}

theta=[-pi/2, pi/2, -pi/2];
d=[0, 0, d6];
a=[0, 0, a6];
alpha=[-pi/2, -pi/2, -pi/2];

A3=sym(eye(4));A3(1:3,4)=[q1;q2;q3];
A4=mdh_matrix(a(1),alpha(1),d(1),theta(1)+q4);
A5=mdh_matrix(a(2),alpha(2),d(2),theta(2)+q5);
A6=mdh_matrix(a(3),alpha(3),d(3),theta(3));

T=A3*A4*A5*A6;
for i=1:3
    for j=1:4
        disp(simplify(T(i,j)))
    end
end

% T=[nx,ox,ax,px; ny,oy,ay,py; nz,oz,az,pz; 0,0,0,1];
% 
% T_1=inv(A3)*T;
% T_2=A4*A5*A6;
% for i=1:3
%     for j=1:4
%         tmp=sprintf('%s = %s',simplify(T_1(i,j)),simplify(T_2(i,j)));
%         disp(tmp);
%     end
% end

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
