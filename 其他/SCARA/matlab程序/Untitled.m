clear;
clc;

syms a1 a2;
syms q1 q2 q3 q4;
syms nx ny nz ox oy oz ax ay az px py pz;
pi=sym(pi);

% DH参数表
theta=[0,0,0,0];
d=[0,0,0,0];
a=[0,a1,a2,0];
alpha=[0,0,0,pi];
q=[q1, q2, q3, q4];

T=sym(eye(4));
% 计算T矩阵
for i=1:4
    if i==3
		A=mdh_matrix(a(i),alpha(i),d(i)+q(i),theta(i));
    else
        A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
    end
    disp(A);
    T=simplify(T*A);
end
disp(T);

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
