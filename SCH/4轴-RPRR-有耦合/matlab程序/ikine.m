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
function [q]=ikine(p,qlast,config)

% 定义DH参数
% d1=252;
% a2=350;
% a3=300;
d1=0;
a2=800;
a3=1250;

c1=1;   %J1J3耦合比
c2=0.5; %J1J4耦合比
c3=0.7; %J3J4耦合比

% 等效变换
px=p(1);
py=p(2);
pz=p(3);
pa=deg2rad(p(4));

% q2
q2=pz-d1;

% q3
tmp1=(px^2+py^2-a2^2-a3^2)/(2*a2*a3);
tmp2=sqrt(1-tmp1^2);
tmp3=-tmp2;
tmp2=atan2(tmp2,tmp1);
tmp3=atan2(tmp3,tmp1);
switch config
    case 0 %默认，q3取最小位移解
        if abs(deg2rad(qlast(3))-tmp2)<=abs(deg2rad(qlast(3))-tmp3)
            q3=tmp2;
        else
            q3=tmp3;
        end
    case 1 %左手，q3取非正解
        if tmp2<=0
            q3=tmp2;
        elseif tmp3<=0
            q3=tmp3;
        end
    case 2 %右手，q3取非负解
        if tmp2>=0
            q3=tmp2;
        elseif tmp3>=0
            q3=tmp3;
        end
    case 3 %自适应，q3取与前一点同手系的解
        if qlast(3)*tmp2>=0
            q3=tmp2;
        elseif qlast(3)*tmp3>=0
            q3=tmp3;
        end
end

% q1
q1=atan2(py,px)-atan2(a3*sin(q3),a2+a3*cos(q3));
if q1>=pi
    q1=q1-2*pi;
elseif q1<-pi
    q1=q1+2*pi;
end

% q4
q4=q1+q3-pa;

%{
% q1
tmp1=(px^2+py^2+a2^2-a3^2)/(2*a2);
tmp2=atan2(-px,py)-atan2(-tmp1,sqrt(px^2+py^2-tmp1^2));
tmp3=atan2(-px,py)-atan2(-tmp1,-sqrt(px^2+py^2-tmp1^2));

if tmp2>=pi
    tmp2=tmp2-2*pi;
elseif tmp2<-pi
    tmp2=tmp2+2*pi;
end
if tmp3>=pi
    tmp3=tmp3-2*pi;
elseif tmp3<-pi
    tmp3=tmp3+2*pi;
end

if abs(deg2rad(qlast(1))-tmp2)<abs(deg2rad(qlast(1))-tmp3)
    q1=tmp2;
else
    q1=tmp3;
end

% q2
q2=pz-d1;

% q3
q3=atan2(py-a2*sin(q1),px-a2*cos(q1))-q1;
if q3>=pi
    q3=q3-2*pi;
elseif q3<-pi
    q3=q3+2*pi;
end

% q4
q4=q1+q3-pa;
q4=atan2(sin(q4),cos(q4));
if (q4-deg2rad(qlast(4)))>pi
	q4=q4-pi*2;
elseif (q4-deg2rad(qlast(4)))<-pi
	q4=q4+pi*2;
end
%}

%组耦
q3=q3+q1*c1;
q4=q4+q1*c2+q3*c3;

q4=atan2(sin(q4),cos(q4));
if (q4-deg2rad(qlast(4)))>pi
	q4=q4-pi*2;
elseif (q4-deg2rad(qlast(4)))<-pi
	q4=q4+pi*2;
end

q=[rad2deg(q1), q2, rad2deg(q3), rad2deg(q4)];
end
