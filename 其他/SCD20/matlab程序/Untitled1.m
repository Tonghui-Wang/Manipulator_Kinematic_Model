clc;
clear;

d1=500;
d4=200;
a1=200;
a2=1200;
a3=550;

L1= Link( [0, 0, 0, 0, 1], 'modified'); L1.offset=d1; L1.qlim=[0,500];
L2= Link( [0, 0, a1, 0, 0], 'modified'); L2.offset=0;
L3= Link( [0, 0, a2, 0, 0], 'modified'); L3.offset=pi;
L4= Link( [0, d4, a3, pi, 0], 'modified'); L4.offset=pi;

SCD20=SerialLink([L1 L2 L3 L4],'name','SCD20');%SerialLink 类函数
SCD20.teach([0 0 0 0]);

syms q1 q2 q3 q4;
q=[q1 q2 q3 q4];
jac=SCD20.jacob0(q);
disp(simplify(jac));
