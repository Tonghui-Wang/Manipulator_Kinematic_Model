%QR5
%% DH参数
clear;
clc
%actAng=[0 0 0 0]; %各关节当前角度，°
% MDH
Rad2Deg=180/pi;
Deg2Rad=pi/180;
a0=0; a1=0; a2=424; a3=406; a4=0; a5=0; %连杆参数 m
d1=107.4; d2=136.6; d3=0; d4=-10.5; d5=-116; d6=96.2;
%a0-5
a(1) = 0; a(2) = a1; a(3) = a2; a(4) = a3; a(5) = a4; a(6) = 0;
%d0-5
d(1) = d1; d(2) = d2; d(3) = d3; d(4) = d4; d(5) = d5; d(6) = d6;
%% Forward Kinematic
ang=[0 0 0 0 0 0];
ang=ang*Deg2Rad;%转为弧度

%DH参数赋值
% DHalpha[0] =0;       
% DHalpha[1] =pi/2; 
% DHalpha[2] =0;        
% DHalpha[3] =0; 
% DHalpha[4] =pi/2;        
% DHalpha[5] =-pi/2; 
% alpha(1) = 0; %alpha0-5
% alpha(2) = pi/2;
% alpha(3) = 0;
% alpha(4) = 0;%pi/2;
% alpha(5) = -pi/2;
% alpha(6) = pi/2;
alpha=[0 pi/2 0 0 -pi/2 pi/2];

theta(1) = ang(1);
theta(2) = ang(2);
theta(3) = ang(3);
theta(4) = ang(4);
theta(5) = ang(5);
theta(6) = ang(6);

%计算连杆变换矩阵
TMatrix=eye(4);
% TMatrix(1,1) = 1;TMatrix(2,2) = 1;TMatrix(3,3) = 1;TMatrix(4,4) = 1;
for ii=1:6
	Ttemp = FN_DHTranMatrix(alpha(ii),a(ii),d(ii),theta(ii));
	TMatrix = TMatrix*Ttemp;%FN_MatMult4x4(TMatrix,Ttemp);
end
%末端姿态矩阵
Rq=TMatrix;
%计算欧拉角
%EularAngle = Rotation2RPY(Rot);
beta = atan2(-Rq(3,1),sqrt(power(Rq(1,1),2)+power(Rq(2,1),2)));
if abs(beta)<1e-6
    beta=0;
end
if abs(beta-pi/2)<1e-6
	alpha = 0;
	gamma = atan2(Rq(1,2),Rq(2,2));
elseif abs(beta+pi/2)<1e-6
	alpha = 0;
	gamma = -atan2(Rq(1,2),Rq(2,2));
else
	alpha = atan2(Rq(2,1)/cos(beta),Rq(1,1)/cos(beta));
	gamma = atan2(Rq(3,2)/cos(beta),Rq(3,3)/cos(beta)); 
end
EularAngle(1)=alpha;
EularAngle(2)=beta;
EularAngle(3)=gamma;

X= TMatrix(1,4);%*1000;
Y= TMatrix(2,4);%*1000;
Z= TMatrix(3,4);%*1000;
A=EularAngle(1)*Rad2Deg;
B=EularAngle(2)*Rad2Deg;
C=EularAngle(3)*Rad2Deg;

%% Inverse Kinematic
X=200.0;Y=0.0;Z=0.0;A=0.0;B=0;C=0;

sActAngle=[0 0 0 0 0 0];

a=A*Deg2Rad;
b=B*Deg2Rad;
g=C*Deg2Rad;

%Alpha = A*Deg2Rad;
%Beta =  B*Deg2Rad;
%Gamma = C*Deg2Rad;
%Rot = RPY2Rotation(Alpha,Beta,Gamma);
Rot(1,1) = cos(a)*cos(b);
Rot(1,2) = cos(a)*sin(b)*sin(g) - cos(g)*sin(a);
Rot(1,3) = sin(a)*sin(g) + cos(a)*cos(g)*sin(b);
Rot(2,1) = cos(b)*sin(a);
Rot(2,2) = cos(a)*cos(g) + sin(a)*sin(b)*sin(g);
Rot(2,3) = cos(g)*sin(a)*sin(b) - cos(a)*sin(g);
Rot(3,1) = -sin(b);
Rot(3,2) = cos(b)*sin(g);
Rot(3,3) = cos(b)*cos(g);

%X=X/1000.0;
%Y=Y/1000.0;
%Z=Z/1000.0;
	
sActAngle(1)=sActAngle(1)*Deg2Rad;
sActAngle(2)=sActAngle(2)*Deg2Rad;
sActAngle(3)=sActAngle(3)*Deg2Rad;
sActAngle(4)=sActAngle(4)*Deg2Rad;
sActAngle(5)=sActAngle(5)*Deg2Rad;
sActAngle(6)=sActAngle(6)*Deg2Rad;
	
px = X - Rot(1,3) * d(6);
py = Y - Rot(2,3) * d(6);
pz = Z - Rot(3,3) * d(6) - d(1);
%Config如何获得？？？
Config=linspace(0,0,3);
if Config(1)==0
    n1=1;			
else
    n1=-1;			
end	

if Config(2)==0
    n2=1;
else
    n2=-1;
end

if Config(3)==0
    n5=1;
else
    n5=-1;
end	

space=px*px+py*py-d4*d4;
if space<0.00001 %超出工作空间
    return;
else		
    RR=sqrt(px*px+py*py-d4*d4);
    theta1=atan2(py,px)-atan2(-d4,n1*RR);		
    if (sActAngle(1)-theta1)<0
        sign=-1;
    else
        sign=1;
    end
    coe=floor(abs(sActAngle(1)-theta1)/pi);
    theta1=theta1+coe*sign*pi;
    temup=theta1+sign*pi;
    if abs(sActAngle(1)-temup)<abs(sActAngle(1)-theta1)
        theta1=temup;
    end

    %theta5
    MM=((-sin(theta1))*Rot(1,1)+cos(theta1)*Rot(2,1))*((-sin(theta1))*Rot(1,1)+cos(theta1)*Rot(2,1))+((-sin(theta1))*Rot(1,2)+cos(theta1)*Rot(2,2))*((-sin(theta1))*Rot(1,2)+cos(theta1)*Rot(2,2));	
    FF=n5*sqrt(MM);
    KK=sin(theta1)*Rot(1,3)-cos(theta1)*Rot(2,3);
    theta5=atan2(FF,KK);
    if (sActAngle(5)-theta5)<0 
        sign=-1;
    else
        sign=1;
    end
    coe=floor(abs(sActAngle(5)-theta5)/pi);
    theta5=theta5+coe*sign*pi;
    temup=theta5+sign*pi;
    if abs(sActAngle(5)-temup)<abs(sActAngle(5)-theta5)
        theta5=temup;
    end

    if abs(sin(theta5))<0.1 %奇异点
        return;
    else
        %theta6
        AA=(-1*Rot(1,2)*sin(theta1)+Rot(2,2)*cos(theta1))/sin(theta5);
        BB=-1*(-1*Rot(1,1)*sin(theta1)+Rot(2,1)*cos(theta1))/sin(theta5);
        theta6=atan2(AA,BB);

        if (sActAngle(6)-theta6)<0
            sign=-1;
        else
            sign=1;
        end
        coe=floor(abs(sActAngle(6)-theta6)/pi);
        theta6=theta6+coe*sign*pi;
        temup=theta6+sign*pi;
        if abs(sActAngle(6)-temup)<abs(sActAngle(6)-theta6)
            theta6=temup;
        end

        %theta2
        TT=-Rot(3,3)/FF;
        HH=-(cos(theta1)*Rot(1,3)+sin(theta1)*Rot(2,3))/FF;
        sum234=atan2(TT,HH);
        B1=cos(theta1)*px+sin(theta1)*py-d5*sin(sum234);
        B2=pz+d5*cos(sum234);
        A=-2*B2*a2;
        B=2*B1*a2;
        C=B1*B1+B2*B2+a2*a2-a3*a3;
        if (A*A+B*B-C*C)>=0
            D=sqrt(A*A+B*B-C*C);	
            theta2=atan2(B,A)-atan2(C,n2*D);
        end

        if (sActAngle(2)-theta2)<0
            sign=-1;
        else
            sign=1;
        end
        coe=floor(abs(sActAngle(2)-theta2)/pi);
        theta2=theta2+coe*sign*pi;
        temup=theta2+sign*pi;
        if abs(sActAngle(2)-temup)<abs(sActAngle(2)-theta2)
            theta2=temup;
        end	

        %theta3
        S23=(B2-a2*sin(theta2))/a3;
        C23=(B1-a2*cos(theta2))/a3;
        sum23=atan2(S23,C23);
        theta3=sum23-theta2;

        if (sActAngle(3)-theta3)<0
            sign=-1;
        else
            sign=1;
        end
        coe=floor(abs(sActAngle(3)-theta3)/pi);
        theta3=theta3+coe*sign*pi;
        temup=theta3+sign*pi;
        if abs(sActAngle(3)-temup)<abs(sActAngle(3)-theta3)
            theta3=temup;
        end	

        %theta4			
        theta4=sum234-sum23;

        if (sActAngle(4)-theta4)<0
            sign=-1;
        else
            sign=1;
        end
        coe=floor(abs(sActAngle(4)-theta4)/pi);
        theta4=theta4+coe*sign*pi;
        temup=theta4+sign*pi;
        if abs(sActAngle(4)-temup)<abs(sActAngle(4)-theta4)
            theta4=temup;
        end						
    end
end
%单位转换
lrAxis1=theta1*Rad2Deg;
lrAxis2=theta2*Rad2Deg;
lrAxis3=theta3*Rad2Deg;
lrAxis4=theta4*Rad2Deg;
lrAxis5=theta5*Rad2Deg;
lrAxis6=theta6*Rad2Deg;	
