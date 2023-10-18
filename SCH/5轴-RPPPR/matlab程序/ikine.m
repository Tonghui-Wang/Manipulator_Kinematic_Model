% 运动学逆解推算
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

% 连杆参数
d1=100;
d3=100;
d4=100;

px=p(1);
py=p(2);
pz=p(3);
pa=p(4);

% J3位移占J3J4位移之和的比例
ratio=0.5; % 299.9998539/(299.9998539+240.00176805);

% 逆解计算
q1=rad2deg(atan2(py,px));
q2=pz-d1;
q3=(sqrt(px^2+py^2)-d3-d4)*ratio;
q4=sqrt(px^2+py^2)-d3-d4-q3;
q5=q1-pa;

if q3>=50
    q3=50;
end
if q4>=50
    q4=50;
end

%逆解结果，各关节位移
q=[q1,q2,q3,q4,q5];
end
