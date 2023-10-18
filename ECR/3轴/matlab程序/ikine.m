function[q]=ikine(p,qlast)

a1=375;
a2=375;

x=p(1);
% y=p(2);
z=p(3);
a=deg2rad(p(4));

qlast=deg2rad(qlast);

% 逆解计算
% q1
tmp1=(x^2+z^2+a1^2-a2^2)/(2*a1);
tmp2=atan2(z,x)-atan2(tmp1,sqrt(x^2+z^2-tmp1^2));
tmp3=atan2(z,x)-atan2(tmp1,-sqrt(x^2+z^2-tmp1^2));
if abs(qlast(1)-tmp2)<abs(qlast(1)-tmp3)
    q1=tmp2;
else
    q1=tmp3;
end

% q2
tmp2=sin(q1);
tmp3=cos(q1);
q2=atan2(z-a1*tmp3,x+a1*tmp2)-q1;

% q3
q3=-a-q1-q2;

q=rad2deg([q1,q2,q3]);
end
