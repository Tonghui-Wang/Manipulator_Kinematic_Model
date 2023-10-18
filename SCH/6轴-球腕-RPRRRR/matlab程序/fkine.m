% 运动学正解推算
% @Time:2021/11/18 17:30
% @Auther:Tonghui Wang
% @File:fkine.m
% @software:MATLAB

% 正解函数
% 输入：各关节位移
%	   旋转轴位移值单位为°,移动轴位移值单位为mm
% 输出：TCP位姿描述(XYZABC)
%	   XYZ输出值单位为mm,ABC输出值单位为°
function [p]=fkine(q)

% 定义DH参数
d1=100;
d4=100;
d6=100;
a2=100;

s1=sind(q(1));
s3=sind(q(3));
s13=sind(q(1)+q(3));
s4=sind(q(4));
s5=sind(q(5));
s6=sind(q(6));
c1=cosd(q(1));
c3=cosd(q(3));
c13=cosd(q(1)+q(3));
c4=cosd(q(4));
c5=cosd(q(5));
c6=cosd(q(6));

T=eye(4);
T(1,1)=s13*c4*s6 + (c13*c5 + s13*s4*s5)*c6;
T(1,2)=s13*c4*c6 - (c13*c5 + s13*s4*s5)*s6;
T(1,3)=c13*s5 - s13*s4*c5;
T(1,4)=a2*c1 + d4*c13 + d6*T(1,3);
T(2,1)=-c13*c4*s6 + c6*(-c13*s4*s5 + s13*c5);
T(2,2)=-c13*c4*c6 + s6*(c13*s4*s5 - s13*c5);
T(2,3)=c13*s4*c5 + s13*s5;
T(2,4)=a2*s1 + d4*s13 + d6*T(2,3);
T(3,1)=c4*s5*c6 - s4*s6;
T(3,2)=-c4*s5*s6 - s4*c6;
T(3,3)=-c4*c5;
T(3,4)=d1 + q(2) + d6*T(3,3);

p=[T(1:3,4)',rad2deg(tform2eul(T,'ZYX'))];
end
