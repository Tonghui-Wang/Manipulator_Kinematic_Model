function [axisp]=couple(motorpp)

global pluse ratio lead motorvel zerop pluseequ plusemax;

for i=1:4
    if i==3 %第3轴 升降运动
        ratio3=pluseequ(3) * 360 / pluse(3);%计算关节3电机至丝杠螺母侧同步轮的减速比
        ratio4=pluseequ(4) * 360 / pluse(4);%计算关节4电机至花键螺母侧同步轮的减速比
        motorp3=(motorpp(3)-zerop(3)) * 360 / pluse(3);%由电机3脉冲计算到电机3转角
        motorp4=(motorpp(4)-zerop(4)) * 360 / pluse(4);%由电机4脉冲计算到电机4转角
        axisp(i)=motorp3/ratio3 + motorp4 /ratio4 * lead(3) / 360;%由电机转角组耦到关节3转角
    elseif i==4 %第4轴 旋转运动
        ratio4=pluseequ(4) * 360 / pluse(4);%计算关节4电机至花键螺母侧同步轮的减速比
        motorp4=(motorpp(4)-zerop(4)) * 360 / pluse(4);%由电机4脉冲计算到电机4转角
        axisp(i)=motorp4 / ratio4;%由电机转角组耦到关节4转角
    else
        axisp(i)=(motorpp(i)-zerop(i))/pluseequ(i);
    end
end

end
