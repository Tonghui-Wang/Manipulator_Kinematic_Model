clear;
clc;

%假定的末端坐标
px=-10;
py=-10;

d2=0;%当偏置为0时,检查两种模型的计算是否一致

%考虑偏置的模型
temp=sqrt(px^2+py^2-d2^2);
q1=atan2(temp-d2,-temp-d2) - ...
    atan2(px+py,-sqrt((temp-d2)^2 + (-temp-d2)^2 - (px+py)^2));

if q1>pi
    q1=q1-2*pi;
elseif q1<-pi
    q1=q1+2*pi;
end

disp(rad2deg(q1));

%不考虑偏置的模型
q1=atan2(py,px);

if q1>pi
    q1=q1-2*pi;
elseif q1<-pi
    q1=q1+2*pi;
end

disp(rad2deg(q1));
