clear;
clc;

% q=[0, 0, 0, 0, 0, 0];

% p=fkine(q);%正解
% disp(p);

% q=ikine(p);%逆解
% disp(q);

qlast(1,:)=[17.008	-7.219	-15.843	-66.934	107.417	0.0];%初始角位移
p=fkine(qlast(1,:));%初始位姿
j=1;
for i=1:1:100;
    p1(j,:)=p+[0,0,0,0,0,-i];%期望位姿
    q(j,:)=ikinesel(p1(j,:),qlast(j,:));%期望位姿的对应逆解,关节位移
    qlast(j+1,:)=q(j,:);%更新上一循环角位移，以备下一循环选解计算使用
    p2(j,:)=fkine(q(j,:));%根据逆解跑的实际位姿
    j=j+1;
end

for i=1:size(q,1)-1
    v(i,:)=q(i+1,:)-q(i,:);%关节速度
end

figure(1);
x=[1:size(q,1)]';
plot(x,q(:,1), x,q(:,2), x,q(:,3), x,q(:,4), x,q(:,5), x,q(:,6));
legend('j1_p','j2_p','j3_p', 'j4_p', 'j5_p', 'j6_p');
title('关节位移曲线');
hold on;

figure(2);
x=[1:size(v,1)]';
plot(x,v(:,1), x,v(:,2), x,v(:,3), x,v(:,4), x,v(:,5), x,v(:,6));
legend('j1_v','j2_v','j3_v', 'j4_v', 'j5_v', 'j6_v');
title('关节速度曲线');
hold on;

figure(3);
x=[1:size(p1,1)]';
plot(x,p1(:,1)-p2(:,1), x,p1(:,2)-p2(:,2), x,p1(:,3)-p2(:,3), x,p1(:,4)-p2(:,4), x,p1(:,5)-p2(:,5), x,p1(:,6)-p2(:,6));
legend('X_e','Y_e','Z_e', 'A_e', 'B_e', 'C_e');
title('位移误差曲线');
hold on;
