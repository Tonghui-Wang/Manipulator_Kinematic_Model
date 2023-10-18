clear;
clc;

% q=[0, 0, 0, 0];
% p=SCD20_fkine(q);%正解
% disp(p);
% q=SCD20_ikine(p);%逆解
% disp(q);

qlast(1,:)=[0,0,0,0];%初始角位移
p=SCD20_fkine(qlast(1,:));%初始姿态
j=1;
for i=-1000:1:0;
    p1(j,:)=p+[0,i,0,0,0,0];%期望位姿
    q(j,:)=SCD20_ikinesel(p1(j,:),qlast(j,:));%期望位姿的对应逆解,关节位移
    qlast(j+1,:)=q(j,:);%更新上一循环角位移，以备下一循环选解计算使用
    p2(j,:)=SCD20_fkine(q(j,:));%根据逆解跑的实际位姿
    j=j+1;
end

for i=1:size(q,1)-1
    v(i,:)=q(i+1,:)-q(i,:);%关节速度
end

figure(1);
x=[1:size(q,1)]';
plot(x,q(:,1), x,q(:,2), x,q(:,3), x,q(:,4));
legend('j1_p','j2_p','j3_p', 'j4_p');
title('关节位移曲线');
hold on;

figure(2);
x=[1:size(v,1)]';
plot(x,v(:,1), x,v(:,2), x,v(:,3), x,v(:,4));
legend('j1_v','j2_v','j3_v', 'j4_v');
title('关节速度曲线');
hold on;

figure(3);
x=[1:size(p1,1)]';
plot(x,p1(:,1)-p2(:,1), x,p1(:,2)-p2(:,2), x,p1(:,3)-p2(:,3), x,p1(:,4)-p2(:,4));
legend('X_e','Y_e','Z_e', 'A_e');
title('位移误差曲线');
hold on;
