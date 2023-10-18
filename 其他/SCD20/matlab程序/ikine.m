% 运动学正解推算
% @Time:2021/12/18 12:00
% @Auther:Tonghui Wang
% @File:ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=ikine(p,qlast)

% DH参数
d1=0;
d4=0;
a1=0;
a2=1250;
a3=600;

% TCP位姿
px=p(1); 
py=p(2);
pz=p(3);
pa=p(4);

% q1
q1=pz+d4-d1;

% q2
tmp1=((px-a1)^2+py^2+a2^2-a3^2)/(2*a2);
tmp2=(px-a1)^2+py^2-tmp1^2;
if tmp2<0
    q=[0,0,0,0];  
    return;
end
tmp3=atan2(a1-px,py)-atan2(-tmp1,sqrt(tmp2));
tmp4=atan2(a1-px,py)-atan2(-tmp1,-sqrt(tmp2));
if abs(deg2rad(qlast(2))-tmp3)<abs(deg2rad(qlast(2))-tmp4)
	q2=tmp3;
else
	q2=tmp4;
end

% q3
tmp1=-(py-a2*sin(q2))/a3;
tmp2=-(px-a1-a2*cos(q2))/a3;
q3=atan2(tmp1,tmp2)-q2;

% q4
q4=q2+q3-deg2rad(pa);

q=[q1,rad2deg([q2,q3,q4])];
end
