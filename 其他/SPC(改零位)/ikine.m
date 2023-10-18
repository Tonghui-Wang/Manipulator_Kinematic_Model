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
function [q]=ikine(p,qlast)

% DH参数
a3=100;

px=p(1);
py=p(2);
pz=p(3);
pa=p(4);

tmp1=py+sqrt(a3^2-px^2);
tmp2=py-sqrt(a3^2-px^2);
if abs(tmp1-qlast(1))<=abs(tmp2-qlast(1))
    q1=tmp1;
else
    q1=tmp2;
end

q3=rad2deg(atan2(py-q1,px))-90;
if q3<-180
    q3=q3+360;
end

q2=pz;

q4=q3-pa;

q=[q1,q2,q3,q4];
end
