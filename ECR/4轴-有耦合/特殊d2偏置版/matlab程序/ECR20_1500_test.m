clear;
clc;

q=[-110 -10 10 10];
p=ECR20_1500_fkine(q);%正解

q1=ECR20_1500_ikine(p);%逆解
p1=ECR20_1500_fkine(q1);

q2=ECR20_1500_ikine1(p);%逆解
p2=ECR20_1500_fkine(q2);

disp(q);
disp(q1);
disp(q2);

disp(p);
disp(p1);
disp(p2);