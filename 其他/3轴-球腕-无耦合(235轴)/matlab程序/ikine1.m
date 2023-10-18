function [q]=ikine1(p,flag)

a1=100;
a2=100;
a3=100;
d1=100;
d4=100;
d6=100;

R=eul2rotm(deg2rad(p(4:6)),'ZYX');
nx=R(1,1); ox=R(1,2); ax=R(1,3); px=p(1);
ny=R(2,1); oy=R(2,2); ay=R(2,3); py=p(2);
nz=R(3,1); oz=R(3,2); az=R(3,3); pz=p(3);
clear R p;

tmp1=px - a1 - d6*ax;
tmp2=pz - d1 + d6*nx;
tmp3=(tmp1^2 + tmp2^2 + a2^2 -a3^2 -d4^2)/(2*a2);
q2=atan2(tmp2,tmp1) - atan2(tmp3, flag*sqrt(tmp1^2 + tmp2^2 -tmp3^2));

q3=atan2(tmp2-a2*cos(q2), tmp1+a2*sin(q2)) - q2 - atan2(a3, d4);

q5=atan2(ax, nx) - q2 - q3;

% 逆解结果，各关节位移
q=rad2deg([0,q2,q3,0,q5,0]);
end
