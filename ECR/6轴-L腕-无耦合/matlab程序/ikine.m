function[q]=ikine(p,flag)

% a1=100;
% a2=100;
% a3=100;
% d1=100;
% d5=100;
% d6=100;

a1=105;
a2=350;
a3=350;
d1=393;
d5=165;
d6=100;

R=eul2rotm(deg2rad(p(4:6)),'ZYX');
nx=R(1,1); ox=R(1,2); ax=R(1,3); px=p(1);
ny=R(2,1); oy=R(2,2); ay=R(2,3); py=p(2);
nz=R(3,1); oz=R(3,2); az=R(3,3); pz=p(3);
clear R p;

% 逆解计算
% q1
q1=atan2(py-ay*d6, px-ax*d6)-flag(1)*pi;
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

% q6
q6=atan2(ny*cos(q1)-nx*sin(q1), oy*cos(q1)-ox*sin(q1))-flag(3)*pi;
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

% q5
% q5=atan2(cos(q6)*oz+sin(q6)*nz,az);
tmp1=ay*cos(q1)-ax*sin(q1);
tmp2=-(cos(q1)*cos(q6)*oy + cos(q1)*sin(q6)*ny - sin(q1)*cos(q6)*ox - sin(q1)*sin(q6)*nx);
if tmp1>1
    tmp1=1;
elseif tmp1<-1
    tmp1=-1;
end
if tmp2>1
    tmp2=1;
elseif tmp2<-1
    tmp2=-1;
end
q5=atan2(tmp1,tmp2);

% q2
tmp1=sin(q1)*(py-ay*d6)+cos(q1)*(px-ax*d6)-a1+...
    d5*(oy*sin(q1)*sin(q6)+ox*cos(q1)*sin(q6)-ny*sin(q1)*cos(q6)-nx*cos(q1)*cos(q6));
tmp2=pz-d1-az*d6-d5*nz*cos(q6)+d5*oz*sin(q6);
tmp=(tmp1*tmp1+tmp2*tmp2+a2*a2-a3*a3)/(2*a2);
q2=tmp1*tmp1+tmp2*tmp2-tmp*tmp;
if q2>=0
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
else
    q=[360,360,360,360,360,360];
    return;
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
% else
%     tmp=(tmp1^2+tmp2^2-a2^2-a3^2)/(2*a2*a3);
%     if tmp>1
%         tmp=1;
%     elseif tmp<-1
%         tmp=-1;
%     end
%     q3=atan2(tmp,flag(2)*sqrt(1-tmp^2));
%     if q3>pi
%         q3=q3-2*pi;
%     elseif q3<=-pi
%         q3=q3+2*pi;
%     end
%     
%     tmp3=tmp2*(a3*cos(q3))-(tmp1-a1)*(a3*sin(q3)+a2);
%     tmp4=tmp2*(a3*sin(q3)+a2)+(tmp1-a1)*(a3*cos(q3));
%     
%     q2=atan2(tmp3,tmp4);
%     if q2>pi
%         q2=q2-2*pi;
%     elseif q2<-pi
%         q2=q2+2*pi;
%     end
% end

% q4
tmp1=-az*cos(q5)-oz*sin(q5)*cos(q6)-nz*sin(q5)*sin(q6);%c234
tmp2=nz*cos(q6)-oz*sin(q6);%s234
q4=atan2(tmp2,tmp1)-q2-q3;
if q4>pi
    q4=q4-2*pi;
elseif q4<=-pi
    q4=q4+2*pi;
end

% 逆解结果，各关节位移
q=rad2deg([q1,q2,q3,q4,q5,q6]);
end
