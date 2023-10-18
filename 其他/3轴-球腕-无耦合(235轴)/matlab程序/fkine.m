function [p]=fkine(q)

a1=100;
a2=100;
a3=100;
d1=100;
d4=100;
d6=100;

s2=sind(q(2));
s23=sind(q(2)+q(3));
s235=sind(q(2)+q(3)+q(5));
c2=cosd(q(2));
c23=cosd(q(2)+q(3));
c235=cosd(q(2)+q(3)+q(5));

nx=c235;
ox=0;
ax=s235;
px=a1 - a2*s2 - a3*s23 + d4*c23 + d6*s235;
ny=0;
oy=-1;
ay=0;
py=0;
nz=s235;
oz=0;
az=-235;
pz=d1 + a2*c2 + a3*c23 + d4*s23 - d6*c235;

T=[nx,ox,ax,px;
    ny,oy,ay,py;
    nz,oz,az,pz;
    0,0,0,1];

p=[T(1:3,4)',rad2deg(tform2eul(T,'ZYX'))];
end
