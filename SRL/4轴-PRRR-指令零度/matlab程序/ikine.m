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
function [q]=ikine(p, qlast, config)

% 定义DH参数
a1=120;
a2=500;
a3=400;

% 等效变换
px=p(1);
py=p(2);
pz=p(3)-a1;
pa=deg2rad(p(4));

if (pz*pz+px*px)<(a2-a3)*(a2-a3)
    q=qlast;
    return;
end

% q1
q1=-py;

% q3
tmp1=(px^2+pz^2-a2^2-a3^2)/(-2*a2*a3);
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
    case 1 %前身，q3取非正解
        if tmp2<=0
            q3=tmp2;
        elseif tmp3<=0
            q3=tmp3;
        end
    case 2 %后身，q3取非负解
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

% q2
q2=atan2(-px,pz)-atan2(-a3*sin(q3),a2-a3*cos(q3));
if q2>=pi
    q2=q2-2*pi;
elseif q2<-pi
    q2=q2+2*pi;
end

% q4
q4=-pa-q2-q3;
q4=atan2(sin(q4),cos(q4));
if (q4-deg2rad(qlast(4)))>pi
	q4=q4-pi*2;
elseif (q4-deg2rad(qlast(4)))<-pi
	q4=q4+pi*2;
end

q=[q1, rad2deg([q2,q3,q4])];
end
