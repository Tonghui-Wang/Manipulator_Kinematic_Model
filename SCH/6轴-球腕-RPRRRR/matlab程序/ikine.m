% 运动学逆解推算
% @Time:2021/11/18 17:30
% @Auther:Tonghui Wang
% @File:ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=ikine(p,flag)

% 定义DH参数
d1=100;
d4=100;
d6=100;
a2=100;

% 最大工作半径检查
if p(1)^2+p(2)^2>(d4+d6+a2)^2
    q=[0,0,0,0,0,0];
    return;
end

% 等效变换
R=eul2rotm(deg2rad(p(4:6)),'ZYX');
nx=R(1,1); ox=R(1,2); ax=R(1,3); px=p(1)-d6*ax;
ny=R(2,1); oy=R(2,2); ay=R(2,3); py=p(2)-d6*ay;
nz=R(3,1); oz=R(3,2); az=R(3,3); pz=p(3)-d6*az;
clear R p;

% q1
tmp1=(d4^2-a2^2-px^2-py^2)/(2*a2);
q1=atan2(-px,py)-atan2(tmp1,flag(1)*sqrt(px^2+py^2-tmp1^2));

% q2
q2=pz-d1;

% q3
tmp1=(px^2+py^2-a2^2-d4^2)/(2*a2*d4);%cos(q3)
if tmp1>1
    tmp1=1
elseif tmp1<-1
    tmp1=-1
end
tmp2=flag(2)*sqrt(1-tmp1^2);%sin(q3)
q3=atan2(tmp2,tmp1);

s13=sin(q1+q3);
c13=cos(q1+q3);

% q5
tmp1=ax*c13+ay*s13;%sin(q5)
c5=flag(3)*sqrt(1-tmp1^2);%cos(q5)
tmp2=atan2(tmp1,tmp2);
% tmp2=(ay*c13-ax*s13)*s4-az*c4;
% q5=atan2(tmp1,tmp2)+flag(3)*pi;

% q4
tmp1=ay*c13-ax*s13;%sin(q4)*cos(q5)
tmp2=-az;%cos(q4)*cos(q5)
q4=atan2(tmp1,tmp2);%c5!=0情况下

% q6
tmp1=-ox*c13-oy*s13;%sin(q6)*cos(q5)
tmp2=nx*c13+ny*s13;%cos(q6)*cos(q5)
% tmp1=(nx*s13-ny*c13)*c4-az*s4;%sin(q6)
% tmp2=(ox*s13-oy*c13)*c4-oz*s4;%cos(q6)
q6=atan2(tmp1,tmp2);

q=[rad2deg(q1), q2, rad2deg([q3,q4,q5,q6])];
end
