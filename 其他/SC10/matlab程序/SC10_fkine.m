% 运动学正解推算
% @Time:2021/8/24 12:00
% @Auther:Tonghui Wang
% @File:SC10_fkine.m
% @software:MATLAB

% 正解函数
% 输入：各关节位移
%	   旋转轴位移值单位为°,移动轴位移值单位为mm
% 输出：TCP位姿描述(XYZABC)
%	   XYZ输出值单位为mm,ABC输出值单位为°
function [p]=SC10_fkine(axis)

%{
|_i_|_theta_|_d_|_a_|_alpha_|__axis__|
| 1 |   0   |d1 | 0 |   0   | axis1  |
| 2 |   0   | 0 |a1 |   0   | axis2  |
| 3 |  180  |d3 | 0 |   0   | axis3  |
| 4 |  180  | 0 |a3 |  180  | axis4  |
%}

% 连杆参数
a1=1304;
a3=950;
d1=600;
d3=1100-d1;

% DH参数
a=[0,a1,0,a3];
d=[d1,0,d3,0];
alpha=[0,0,0,pi];
theta=[0,0,pi,pi];

T=eye(4);
for i=1:4
    if i==2
        A=mdh_matrix(a(i),alpha(i),d(i)+axis(i),theta(i));
    else
        A=mdh_matrix(a(i),alpha(i),d(i),theta(i)+deg2rad(axis(i)));
    end
    T=T*A;
end

% 等效变换
p=[T(1:3,4)',rad2deg(tform2eul(T,'ZYX'))];
end

% A矩阵的计算函数(MDH方法)
function [A]=mdh_matrix(a,alpha,d,theta)
A=eye(4);
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
