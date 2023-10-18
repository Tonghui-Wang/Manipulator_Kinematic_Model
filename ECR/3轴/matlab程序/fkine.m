function [p]=fkine(q)

a1=375;
a2=375;

x=a2*cosd(q(1)+q(2))-a1*sind(q(1));
y=0;
z=a2*sind(q(1)+q(2))+a1*cosd(q(1));
a=-(q(1)+q(2)+q(3));

p=[x,y,z,a];
end
