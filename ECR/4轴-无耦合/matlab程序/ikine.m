% 运动学逆解推算
% @Time:2021/10/30 17:30
% @Auther:Tonghui Wang
% @File:ikine.m
% @software:MATLAB

% 逆解函数
% 输入：TCP位姿描述(XYZABC)
%       XYZ输出值单位为mm,ABC输出值单位为°
% 输出：各关节位移
%       旋转轴位移值单位为°,移动轴位移值单位为mm
function [q]=ikine(p,flag)

% DH参数
d1=100;
d5=100;
a1=100;
a2=100;
a3=100;
a4=100;

px=p(1);
py=p(2);
pz=p(3);
pa=deg2rad(p(4));

q1=atan2(py,px);

tmp1=sqrt(px^2+py^2)-a1-a4;
tmp2=pz-d1+d5;
tmp3=(tmp1^2+tmp2^2+a2^2-a3^2)/(2*a2);
q2=atan2(tmp2,tmp1)-atan2(tmp3,sqrt(tmp1^2+tmp2^2-tmp3^2)*flag(1));

s3=(tmp1^2+tmp2^2-a2^2-a3^2)/(2*a2*a3);
c3=sqrt(1-s3^2)*flag(2);
q3=atan2(s3,c3);

q4=q1-pa;

q=rad2deg([q1, q2, q3, q4]);
end
