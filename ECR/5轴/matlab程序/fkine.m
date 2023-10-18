clear;
clc;

syms d1 d5 a1 a2 a3 a4;
syms q1 q2 q3 q4 q5;
syms nx ny nz ox oy oz ax ay az px py pz;
pi=sym(pi);

% d1=314.5;
% d5=50;
% a1=90;
% a2=400;
% a3=400;
% a4=110;

% DH参数
a=[0,a1,a2,a3,a4];
d=[d1,0,0,0,d5];
alpha=[0,pi/2,0,0,pi/2];
theta=[0,pi/2,-pi/2,0,0];

q=[q1,q2,q3,q4,q5];
% q=[0,-pi/2,pi/2,0,0];

A1=simplify(mdh_matrix(a(1),alpha(1),d(1),theta(1)+q(1)));
A2=simplify(mdh_matrix(a(2),alpha(2),d(2),theta(2)+q(2)));
A3=simplify(mdh_matrix(a(3),alpha(3),d(3),theta(3)+q(3)));
A4=simplify(mdh_matrix(a(4),alpha(4),d(4),theta(4)+q(4)));
A5=simplify(mdh_matrix(a(5),alpha(5),d(5),theta(5)+q(5)));

T=[nx,ox,ax,px; ny,oy,ay,py; nz,oz,az,pz; 0,0,0,1];

T25_1=simplify(inv(A1)*T*inv(A5));
T25_2=simplify(A2*A3*A4);

disp(T25_1);
disp(T25_2);

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
