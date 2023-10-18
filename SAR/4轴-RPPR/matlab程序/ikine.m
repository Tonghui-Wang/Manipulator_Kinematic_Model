% 运动学正解推算
% @Time:2021/8/10 17:30
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
% a1=100;
% a2=100;
% a3=100;
% d1=20;
% d2=100;
% d3=100;
% d4=100;

a1=192;
a2=1740;
a3=150;
d1=290;
d2=0;
d3=1380;
d4=149.5;

lamda=a2/d1;

px=p(1);
py=p(2);
pz=p(3);
pa=p(4);

% 关节计算
q1=rad2deg(atan2(py,px));
q2=(pz-d2-d3+d4)/(lamda-1);
q3=(sqrt(px^2+py^2)+a1-a2-a3)/lamda;
q4=q1-pa;
q5=0;
q6=0;

% 结果输出
q=[q1,q2,q3,q4,q5,q6];
end
