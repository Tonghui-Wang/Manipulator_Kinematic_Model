clear;
clc;

q1=[1.562, -56.6, 33.402, -174.652];
% q2=[20,0,0,190];

% pt1=fkine(q1);
% pt2=fkine(q2);
pt1=[480.012, -142.302, 320.013, 174.661];
pt2=[480.012, -142.302, 402.887, 174.661];

trans1= eul2tform([deg2rad(pt1(4)),0,0]);
trans1(1:3,4)=pt1(1:3);
trans2= eul2tform([deg2rad(pt2(4)),0,0]);
trans2(1:3,4)=pt2(1:3);
tpts = [0, 4];
tvec = 0:0.05:5;

[s, sd, sdd] = cubicpolytraj([0, 1], tpts, tvec);
[pt, v, a]=transformtraj(trans1, trans2, tpts, tvec, 'TimeScaling', [s; sd; sdd]);
% translations = tform2trvec(pt);
% rotations = tform2quat(pt);
% plotTransforms(translations,rotations);
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
p=[tform2trvec(pt),rad2deg(tform2eul(pt))];
p=p(:,1:4);

n=size(p,1);
q=zeros(n,4);
qlast=q1;
for i=1:n
    q(i,:)=ikinesel(p(i,:),qlast);
    disp(q(i,:));
    qlast=q(i,:);
end

figure(1);
x=[1:n]';
plot(x,q(:,1), x,q(:,2), x,q(:,3), x,q(:,4));
legend('j1_p','j2_p','j3_p', 'j4_p');
title('关节位移曲线');
hold on;
