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

% DH参数
d1=0;
d3=100;
d4=0;
a3=36.5;

px=p(1);
py=p(2);
pz=p(3);
pa=p(4);

q2=pz;
q3=sqrt(px^2+py^2-a3^2)-d3;

q1=atan2(py,px)-atan2(a3,d3+q3);
q1=rad2deg(atan2(sin(q1),cos(q1)));

q4=q1-pa;

q=[q1,q2,q3,q4];
end
