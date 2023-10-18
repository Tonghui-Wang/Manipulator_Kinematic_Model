function[q]=ikine(p,flag)

% a1=100;
% a2=100;
% a3=100;
% d1=100;
% d5=100;
% d6=100;

a1=0;
a2=350;
a3=350;
d1=393;
d4=50;
d5=165;
d6=100;

R=eul2rotm(deg2rad(p(4:6)),'ZYX');
nx=R(1,1); ox=R(1,2); ax=R(1,3); px=p(1);
ny=R(2,1); oy=R(2,2); ay=R(2,3); py=p(2);
nz=R(3,1); oz=R(3,2); az=R(3,3); pz=p(3);
clear R p;

% 逆解计算
% q1
tmp1=py-ay*d6;
tmp2=px-ax*d6;
q1=atan2(tmp1, tmp2)-atan2(-d4, flag(1)*sqrt(tmp1^2 + tmp2^2 - d4^2));
if q1>=2*pi
    q1=q1-2*pi;
elseif q1<=-2*pi
    q1=q1+2*pi;
end
if q1>pi
    q1=q1-2*pi;
elseif q1<=-pi
    q1=q1+2*pi;
end

% q5
tmp1=ay*cos(q1)-ax*sin(q1);
if tmp1<-1
    tmp1=-1;
elseif tmp1>1
    tmp1=1;
end
q5=flag(3) * asin(tmp1);

% q6
tmp1=oy*cos(q1)-ox*sin(q1);
tmp2=nx*sin(q1)-ny*cos(q1);
q6=atan2(tmp1,tmp2)-atan2(-cos(q5),0);
if q6>=2*pi
    q6=q6-2*pi;
elseif q6<=-2*pi
    q6=q6+2*pi;
end
if q6>pi
    q6=q6-2*pi;
elseif q6<=-pi
    q6=q6+2*pi;
end

% q2
tmp1=sin(q1)*(py-ay*d6)+cos(q1)*(px-ax*d6)-a1+...
    d5*(oy*sin(q1)*sin(q6)+ox*cos(q1)*sin(q6)-ny*sin(q1)*cos(q6)-nx*cos(q1)*cos(q6));
tmp2=pz-d1-az*d6-d5*nz*cos(q6)+d5*oz*sin(q6);
tmp=(tmp1*tmp1+tmp2*tmp2+a2*a2-a3*a3)/(2*a2);
q2=tmp1*tmp1+tmp2*tmp2-tmp*tmp;
if q2>=0
    q=[360,360,360,360,360,360];
    return;
end
q2=atan2(tmp2,tmp1)-atan2(tmp,flag(2)*sqrt(q2));
if q2>=2*pi
	q2=q2-2*pi;
elseif q2<=-2*pi
	q2=q2+2*pi;
end
if q2>pi
	q2=q2-2*pi;
elseif q2<=-pi
	q2=q2+2*pi;
end

% q3
tmp1=(tmp1+a2*sin(q2))/a3;%c23
tmp2=(tmp2-a2*cos(q2))/a3;%s23
q3=atan2(tmp2,tmp1)-q2;
if q3>pi
	q3=q3-2*pi;
elseif q3<=-pi
	q3=q3+2*pi;
end

% q4
tmp1=-az*cos(q5)-oz*sin(q5)*cos(q6)-nz*sin(q5)*sin(q6);%c234
tmp2=nz*cos(q6)-oz*sin(q6);%s234
q4=atan2(tmp2,tmp1)-q2-q3;
q4=atan2(sin(q4),cos(q4));

% 逆解结果，各关节位移
q=rad2deg([q1,q2,q3,q4,q5,q6]);
% 调整到与UR零位一致
q(2)=q(3)-90;
q(5)=q(5)+90;
end
