% sr_fkine

function [p]=sr_fkine(q)
a1=145;
a2=870;
a3=170;
d1=530;
d3=0;
d4=1039;
d5=0;
d6=225;

q1=q(1);
q2=q(2)+90;
q3=q(3);
q4=q(4);
q5=q(5)-90;
q6=q(6);

s1=sind(q1);
s2=sind(q2);
s3=sind(q3);
s4=sind(q4);
s5=sind(q5);
s6=sind(q6);
c1=cosd(q1);
c2=cosd(q2);
c3=cosd(q3);
c4=cosd(q4);
c5=cosd(q5);
c6=cosd(q6);

t=eye(4);
t(1,1)=s6*(c4*s1 - s4*(c1*c2*c3 - c1*s2*s3)) - c6*(s5*(c1*c2*s3 + c1*c3*s2) - c5*(s1*s4 + c4*(c1*c2*c3 - c1*s2*s3)));
t(2,1)=-c6*(s5*(c2*s1*s3 + c3*s1*s2) + c5*(c1*s4 - c4*(c2*c3*s1 - s1*s2*s3))) - s6*(c1*c4 + s4*(c2*c3*s1 - s1*s2*s3));
t(3,1)=c6*(s5*(c2*c3 - s2*s3) + c4*c5*(c2*s3 + c3*s2)) - s4*s6*(c2*s3 + c3*s2);
t(4,1)=0;
t(1,2)=s6*(s5*(c1*c2*s3 + c1*c3*s2) - c5*(s1*s4 + c4*(c1*c2*c3 - c1*s2*s3))) + c6*(c4*s1 - s4*(c1*c2*c3 - c1*s2*s3));
t(2,2)=s6*(s5*(c2*s1*s3 + c3*s1*s2) + c5*(c1*s4 - c4*(c2*c3*s1 - s1*s2*s3))) - c6*(c1*c4 + s4*(c2*c3*s1 - s1*s2*s3));
t(3,2)=-s6*(s5*(c2*c3 - s2*s3) + c4*c5*(c2*s3 + c3*s2)) - c6*s4*(c2*s3 + c3*s2);
t(4,2)=0;
t(1,3)=c5*(c1*c2*s3 + c1*c3*s2) + s5*(s1*s4 + c4*(c1*c2*c3 - c1*s2*s3));
t(2,3)=c5*(c2*s1*s3 + c3*s1*s2) - s5*(c1*s4 - c4*(c2*c3*s1 - s1*s2*s3));
t(3,3)=c4*s5*(c2*s3 + c3*s2) - c5*(c2*c3 - s2*s3);
t(4,3)=0;
t(1,4)=c1*a1 + d3*s1 + a3*(c1*c2*c3 - c1*s2*s3) + d4*(c1*c2*s3 + c1*c3*s2) + d5*(c4*s1 - s4*(c1*c2*c3 - c1*s2*s3)) + c1*c2*a2;
t(2,4)=a1*s1 - c1*d3 + a3*(c2*c3*s1 - s1*s2*s3) + d4*(c2*s1*s3 + c3*s1*s2) - d5*(c1*c4 + s4*(c2*c3*s1 - s1*s2*s3)) + c2*a2*s1;
t(3,4)=a2*s2 + a3*(c2*s3 + c3*s2) - d4*(c2*c3 - s2*s3) - d5*s4*(c2*s3 + c3*s2);
t(4,4)=1;

t(1,4)=t(1,4)+d6*t(1,3);
t(2,4)=t(2,4)+d6*t(2,3);
t(3,4)=t(3,4)+d6*t(3,3)+d1;
% disp(t);

p=[t(1:3,4)',rad2deg(tform2eul(t,'ZYX'))];
disp(p);
end
