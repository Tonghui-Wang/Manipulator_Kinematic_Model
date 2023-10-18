function [q]=sr_ikine(config,p)

a1=145;
a2=870;
a3=170;
d1=530;
d3=0;
d4=1039;
d5=0;
d6=225;

if config(1)==0
    n1=1;
    if config(2)==0
        n3=1;
    else
        n3=-1;
    end
else
    n1=-1;
    if config(2)==0
        n3=-1;
    else
        n3=1;
    end
end
if config(3)==0
    n5= 1;
else
    n5= -1;
end

% DH参数
pa=deg2rad(p(4));
pb=deg2rad(p(5));
pc=deg2rad(p(6));

sa=sin(pa);
sb=sin(pb);
sc=sin(pc);
ca=cos(pa);
cb=cos(pb);
cc=cos(pc);

t=eye(3);
t(1,1)=ca*cb;
t(1,2)=ca*sb*sc - cc*sa;
t(1,3)=sa*sc + ca*cc*sb;
t(2,1)=cb*sa;
t(2,2)=ca*cc + sa*sb*sc;
t(2,3)=cc*sa*sb - ca*sc;
t(3,1)=-sb;
t(3,2)=cb*sc;
t(3,3)=cb*cc;

px=p(1)-t(1,3)*d6;
py=p(2)-t(2,3)*d6;
pz=p(3)-t(3,3)*d6-d1;

%求关节转角1
ldv_t1 = px * px + py * py;
ldv_t2 = d3 * d3;
if ldv_t1 > ldv_t2
    ldv_t1 = sqrt(ldv_t1 - ldv_t2);
    theta1 = atan2(py,px) - atan2(d3,n1*ldv_t1);
end

if theta1 > pi*2
    theta1 = theta1 - pi*2;
elseif theta1 < -pi*2
    theta1 = theta1 + pi*2;
end
if theta1 > pi
    theta1 = theta1 - pi*2;
elseif theta1 < -pi
    theta1 = theta1 + pi*2;
end

%求关节转角3
ldv_s1 = sin(theta1);
ldv_c1 = cos(theta1);
ldv_t2 = px * px + py * py + pz * pz + a1 * a1 - 2*a1*(ldv_c1*px + ldv_s1*py);
ldv_t2 = (ldv_t2 - a2 * a2 - a3 * a3 - d3 * d3 - d4 * d4) / (2*a2);
ldv_t3 = ldv_t2 * ldv_t2;
ldv_t1 = a3 * a3 + d4 * d4;

if ldv_t1>ldv_t3
    ldv_t3 = sqrt(ldv_t1 - ldv_t3);
    theta3 = atan2(a3,d4) - atan2(ldv_t2,n3*ldv_t3);
end

if theta3 > pi*2
    theta3 = theta3 - 2*pi;
elseif theta3 < -pi*2
    theta3 = theta3 + 2*pi;
end
if theta3 > pi
    theta3 = theta3 - 2*pi;
elseif theta3 < -pi
    theta3 = theta3 + 2*pi;
end

%计算转角2和转角3的和
ldv_s3 = sin(theta3);
ldv_c3 = cos(theta3);
ldv_s23 = ((-a3 - a2*ldv_c3)*pz - (ldv_c1*px + ldv_s1*py - a1)*(d4 - a2*ldv_s3))/(pz*pz + (ldv_c1*px + ldv_s1*py - a1)*(ldv_c1*px + ldv_s1*py - a1));
ldv_c23 = ((a2*ldv_s3 - d4)*pz + (a3 + a2*ldv_c3)*(ldv_c1*px + ldv_s1*py - a1))/(pz*pz + (ldv_c1*px + ldv_s1*py - a1)*(ldv_c1*px + ldv_s1*py - a1));
ldv_theta23 = atan2(ldv_s23,ldv_c23);

%计算转角2
theta2 = ldv_theta23 - theta3;

if theta2 > 2*pi
    theta2 = theta2 - 2*pi;
elseif theta2 < -2*pi
    theta2 = theta2 + 2*pi;
end
if theta2 > pi
    theta2 = theta2 - 2*pi;
elseif theta2 < -pi
    theta2 = theta2 + 2*pi;
end

%计算转角4,5
ldv_c5 = - ldv_c1*ldv_s23*t(1,3) - ldv_s1*ldv_s23*t(2,3) - ldv_c23*t(3,3);
if ldv_c5>1
    ldv_c5=1;
elseif ldv_c5<-1
    ldv_c5=-1;
end
theta5 = n5*acos(ldv_c5);

if abs(theta5) < 0.001
    theta4=0;
    theta6=0;
    if config(3) == 0
        config(3) = 1;
    else
        config(3) = 0;
    end
else
    ldv_rr13 = ldv_c1*ldv_c23*t(1,3) + ldv_s1*ldv_c23*t(2,3) - ldv_s23*t(3,3);
    ldv_rr33 = -ldv_s1*t(1,3) + ldv_c1*t(2,3);
    ldv_rr21 = - ldv_c1*ldv_s23*t(1,1) - ldv_s1*ldv_s23*t(2,1) - ldv_c23*t(3,1);
    ldv_rr22 = - ldv_c1*ldv_s23*t(1,2) - ldv_s1*ldv_s23*t(2,2) - ldv_c23*t(3,2);
    if theta5 > 0
        theta4 = atan2(ldv_rr33,-ldv_rr13);
        theta6 = atan2(-ldv_rr22,ldv_rr21);
    else
        theta4 = atan2(-ldv_rr33,ldv_rr13);
        theta6 = atan2(ldv_rr22,-ldv_rr21);
    end
end

theta2 = -theta2;
theta3 = -theta3;
theta5 = -theta5;

q=rad2deg([theta1,theta2-pi/2,theta3,theta4,theta5+pi/2,theta6]);
disp(q);
end
