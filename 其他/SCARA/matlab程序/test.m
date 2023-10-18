clear;
clc;

global pluse ratio lead motorvel zerop pluseequ plusemax;

init();

s1=[391.667358398438, 73.4867401123047, 27.5298461914062, -3];
s2=[391.667358398438, 73.4867401123047, -30, -8];
qlast(1,:)=[0,0,0,0];%初始角位移

error=false;
k=29;

j=1;
for i=0:1:k
    p1(j,:)=s1 + (s2-s1)*i/k;%期望位姿
    q(j,:)=ikine(p1(j,:),qlast(j,:));%期望位姿的对应逆解,关节位移
    qlast(j+1,:)=q(j,:);%更新上一循环角位移，以备下一循环选解计算使用
    p2(j,:)=fkine(q(j,:));%根据逆解跑的实际位姿
    
    motorpluse_a(j,:)=q(j,:).*pluseequ+zerop;
    motorpluse_b(j,:)=decouple(q(j,:));
    
    if j>1
        for m=1:3
            if abs(motorpluse_b(j,m)-motorpluse_b(j-1,m))>plusemax(m)
                error=true;
                break;
            end
        end
    end
    
    if error
        break;
    end
    
    j=j+1;
end

% for i=1:size(q,1)-1
%     v(i,:)=q(i+1,:)-q(i,:);%关节速度
% end

% figure(1);
% x=[1:size(q,1)]';
% plot(x,q(:,1), x,q(:,2), x,q(:,3), x,q(:,4));
% legend('j1_p','j2_p','j3_p', 'j4_p');
% title('关节位移曲线');
% hold on;
% 
% figure(2);
% x=[1:size(v,1)]';
% plot(x,v(:,1), x,v(:,2), x,v(:,3), x,v(:,4));
% legend('j1_v','j2_v','j3_v', 'j4_v');
% title('关节速度曲线');
% hold on;
% 
% figure(3);
% x=[1:size(p1,1)]';
% plot(x,p1(:,1)-p2(:,1), x,p1(:,2)-p2(:,2), x,p1(:,3)-p2(:,3), x,p1(:,4)-p2(:,4));
% legend('X_e','Y_e','Z_e', 'A_e');
% title('位移误差曲线');
% hold on;

figure(4);
x=[1:size(motorpluse_a,1)]';
plot(x,motorpluse_a(:,3), x,motorpluse_a(:,4), ...
     x,motorpluse_b(:,3), x,motorpluse_b(:,4));
legend('a3', 'a4', 'b3', 'b4');
title('脉冲曲线');
hold on;
