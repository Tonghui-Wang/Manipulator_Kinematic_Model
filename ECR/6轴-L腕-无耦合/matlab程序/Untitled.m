clear;
clc;

syms a1 a2 a3 d1 d5 d6;
syms q1 q2 q3 q4 q5 q6;
syms nx ny nz ox oy oz ax ay az px py pz;
pi=sym(pi);

% 连杆参数
% a1=105;
% a2=350;
% a3=350;
% d1=393;
% d5=165;
% d6=100;

%{
|_i_|_theta_|_d_|_a_|_alpha_|_angle_|
| 1 |   0   |d1 | 0 |   0   |   q1  |
| 2 |   90  | 0 |a1 |   90  |   q2  |
| 3 |  -90  | 0 |a2 |   0   |   q3  |
| 4 |   90  | 0 |a3 |   0   |   q4  |
| 5 |   90  |d5 | 0 |   90  |   q5  |
| 6 |  -90  |d6 | 0 |  -90  |   q6  |
%}

% DH参数表
theta=[0, pi/2, -pi/2, pi/2, pi/2, -pi/2];
d=[d1, 0, 0, 0, d5, d6];
a=[0, a1, a2, a3, 0, 0];
alpha=[0, pi/2, 0, 0, pi/2, -pi/2];

q=[q1, q2, q3, q4, q5, q6];

%% 正解推导
% T=sym(eye(4));
% % 计算T矩阵
% for i=1:6
%     A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+q(i));
%     disp(simplify(A));
%     T=simplify(T*A);
% end
% disp(T);

%% 逆解推导
A1=simplify(mdh_matrix(a(1),alpha(1),d(1),theta(1)+q(1)));
A2=simplify(mdh_matrix(a(2),alpha(2),d(2),theta(2)+q(2)));
A3=simplify(mdh_matrix(a(3),alpha(3),d(3),theta(3)+q(3)));
A4=simplify(mdh_matrix(a(4),alpha(4),d(4),theta(4)+q(4)));
A5=simplify(mdh_matrix(a(5),alpha(5),d(5),theta(5)+q(5)));
A6=simplify(mdh_matrix(a(6),alpha(6),d(6),theta(6)+q(6)));
T=[nx,ox,ax,px; ny,oy,ay,py; nz,oz,az,pz; 0,0,0,1];

T_1=simplify(inv(A1)*T*inv(A6)*inv(A5));
T_2=simplify(A2*A3*A4);

for i=1:3
    for j=1:4
        tmp=sprintf('%s = %s',T_1(i,j),T_2(i,j));
        disp(tmp);
    end
    disp('---');
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
