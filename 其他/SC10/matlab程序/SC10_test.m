clear;
clc;

axis=[-80, 0, 2.4, -150];

p=SC10_fkine(axis);%正解
disp(p);

axis=SC10_ikine(p);%逆解
disp(axis);

p=SC10_fkine(axis);%正解
disp(p);
