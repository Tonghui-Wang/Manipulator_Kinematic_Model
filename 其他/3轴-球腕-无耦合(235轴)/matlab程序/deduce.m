clear;
clc;

syms a1 a2 a3 d1 d4 d6;
syms q1 q2 q3 q4 q5 q6;
syms nx ny nz ox oy oz ax ay az px py pz;
pi=sym(pi);

% DH参数表(4、5、6轴)
theta=[0, pi/2, 0, 0, -pi/2, 0];
d=[d1, 0, 0, d4, 0, d6];
a=[0, a1, a2, a3, 0, 0];
alpha=[0, pi/2, 0, pi/2, -pi/2, pi/2];
q=[0, q2, q3, 0, q5, 0];

A1=mdh_matrix(a(1),alpha(1),d(1),theta(1)+q(1));
A2=mdh_matrix(a(2),alpha(2),d(2),theta(2)+q(2));
A3=mdh_matrix(a(3),alpha(3),d(3),theta(3)+q(3));
A4=mdh_matrix(a(4),alpha(4),d(4),theta(4)+q(4));
A5=mdh_matrix(a(5),alpha(5),d(5),theta(5)+q(5));
A6=mdh_matrix(a(6),alpha(6),d(6),theta(6)+q(6));

T=A1*A2*A3*A4*A5*A6;
for i=1:3
    for j=1:4
        disp(simplify(T(i,j)))
    end
end

% T=[nx,ox,ax,px; ny,oy,ay,py; nz,oz,az,pz; 0,0,0,1];
% 
% T_1=inv(A3)*inv(A2)*inv(A1)*T;
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
