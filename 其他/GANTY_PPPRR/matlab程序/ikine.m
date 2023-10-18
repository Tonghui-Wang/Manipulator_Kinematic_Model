% 运动学正解推算
% @Time:2021/7/29 17:30
% @Auther:Tonghui Wang
% @File:ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=ikine(p)

R=eul2rotm(deg2rad(p(4:6)),'ZYX');
nx=R(1,1); ox=R(1,2); ax=R(1,3); px=p(1);
ny=R(2,1); oy=R(2,2); ay=R(2,3); py=p(2);
nz=R(3,1); oz=R(3,2); az=R(3,3); pz=p(3);
clear R p;

%% 20230613
% % DH参数
% a5=100;
% d5=100;
% d6=100;
% 
% % q5
% q5=atan2(nz,-az);
% 
% % q4
% q4=atan2(ox,-oy);
% 
% s4=sin(q4);
% c4=cos(q4);
% s5=sin(q5);
% c5=cos(q5);
% 
% % q3
% q3=pz+d6*c5;
% 
% % q2
% q2=py-d6*s4*s5-a5*s4+d5*c4;
% 
% % q1
% q1=px-d6*c4*s5-a5*c4-d5*s4;

%% 20230615
% DH参数
a6=0;
d6=20;

% q5
q5=atan2(ay,-oy);

% q4
q4=atan2(-nz,nx);

s4=sin(q4);
c4=cos(q4);
s5=sin(q5);
c5=cos(q5);

% q3
q3=pz+d6*c4*c5+a6*c4*s5;

% q2
q2=py-d6*s5+a6*c5;

% q1
q1=px+d6*s4*c5+a6*s4*s5;

q3=-q3;
q4=-q4;

q=[q1,q2,q3,rad2deg([q4, q5, 0])];
end
