function [q]=ikine(p,flag)

a1=142;
a2=680;
a3=110;
d1=332;
d4=630;
d6=103;

R=eul2rotm(deg2rad(p(4:6)),'ZYX');
nx=R(1,1); ox=R(1,2); ax=R(1,3); px=p(1)-ax*d6;
ny=R(2,1); oy=R(2,2); ay=R(2,3); py=p(2)-ay*d6;
nz=R(3,1); oz=R(3,2); az=R(3,3); pz=p(3)-az*d6;
clear R p;

q1=atan2(py,px);
s1=sin(q1);
c1=cos(q1);

tmp1=((sqrt(px^2+py^2)-a1)^2+(pz-d1)^2-a2^2-a3^2-d4^2)/(2*a2);
q3=atan2(-a3,d4)-atan2(-tmp1,sqrt(a3^2+d4^2-tmp1^2)*flag(2));

tmp1=(a1-sqrt(px^2+py^2))*a3+(pz-d1)*d4;
tmp2=(a1-sqrt(px^2+py^2))*d4-(pz-d1)*a3;
tmp3=(a2^2-a3^2-d4^2-(a1-sqrt(px^2+py^2))^2-(pz-d1)^2)/2;
q23=atan2(tmp2,tmp1)-atan2(tmp3,sqrt(tmp1^2+tmp2^2-tmp3^2)*flag(1));
q2=q23-q3;
s23=sin(q23);
c23=cos(q23);

q4=atan2(-(ax*s1-ay*c1),-(az*c23-(ax*c1+ay*s1)*s23));

tmp1=az*s23+(ax*c1+ay*s1)*c23;
q5=atan2(tmp1,sqrt(1-tmp1^2)*flag(3));

q6=atan2(-(ox*c1+oy*s1)*c23-oz*s23,nz*s23+(nx*c1+ny*s1)*c23);

% 逆解结果，各关节位移
q=rad2deg([q1,q2,q3,q4,q5,q6]);
end
