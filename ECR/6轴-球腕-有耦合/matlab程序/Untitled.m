clear;
clc;

syms a2 a3 a4 d1 d4 d6;
syms q1 q2 q3 q4 q5 q6;
syms nx ny nz ox oy oz ax ay az px py pz;
pi=sym(pi);

% 连杆参数
% a2=150;
% a3=770;
% a4=146;
% d1=707;
% d4=780;
% d6=165;

% DH参数表
theta=[0, pi/2, 0, 0, -pi/2, 0];
d=[d1, 0, 0, d4, 0, d6];
a=[0, a2, a3, a4, 0, 0];
alpha=[0, pi/2, 0, pi/2, -pi/2, pi/2];

q=[q1, q2, q3, q4, q5, q6];

A1=simplify(mdh_matrix(a(1),alpha(1),d(1),theta(1)+q(1)));
A2=simplify(mdh_matrix(a(2),alpha(2),d(2),theta(2)+q(2)));
A3=simplify(mdh_matrix(a(3),alpha(3),d(3),theta(3)+q(3)));
A4=simplify(mdh_matrix(a(4),alpha(4),d(4),theta(4)+q(4)));
A5=simplify(mdh_matrix(a(5),alpha(5),d(5),theta(5)+q(5)));
A6=simplify(mdh_matrix(a(6),alpha(6),d(6),theta(6)+q(6)));

% T=[nx,ox,ax,px; ny,oy,ay,py; nz,oz,az,pz; 0,0,0,1];
% 
% T_1=simplify(inv(A4)*inv(A3)*inv(A2)*inv(A1)*T);
% T_2=simplify(A5*A6);

% for i=1:3
%     for j=1:4
%         tmp=sprintf('%s = %s',T_1(i,j),T_2(i,j));
%         disp(tmp);
%     end
%     disp('---');
% end

T=A1*A2*A3*A4*A5*A6;
T=simplify(T);
for i=1:3
    for j=1:4
        disp(simplify(T(i,j)));
    end
end

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
