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
function [q]=ikine(p,qlast)

% 定义DH参数
a1=375;
a2=275;

% 等效变换
px=p(1);
py=p(2);
pz=p(3);
pa=deg2rad(p(4));

q=qlast;

% q2
tmp1 = (px^2+py^2-a1^2-a2^2)/(2*a1*a2);
tmp2=sqrt(1-tmp1^2);
tmp3=-tmp2;
tmp2=atan2(tmp2,tmp1);
tmp3=atan2(tmp3,tmp1);
if abs(qlast(2)-rad2deg(tmp2)) <= abs(qlast(2)-rad2deg(tmp3))
    q(2)=tmp2;
else
    q(2)=tmp3;
end

% q2
q(1) = atan2(py,px)-atan2(a2*sin(q(2)),a1+a2*cos(q(2)));

% q3
q(3) = pz;

% q4
q(4) = q(1)+q(2)-pa;

q=[rad2deg(q(1)), rad2deg(q(2)), q(3), rad2deg(q(4))];
end
