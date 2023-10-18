function [motorpp]=decouple(axisp)

global pluse ratio lead motorvel zerop pluseequ plusemax;

for i=1:4
    %若涉及丝杆花键轴的运动
    if i==3 %第3轴 升降运动
        ratio3=pluseequ(i) * 360 / pluse(i);%计算关节3电机至丝杠螺母侧同步轮的减速比
        motorp=(axisp(3)-axisp(4)*lead(3)/360)*ratio3;%由关节转角解耦到电机转角
        motorpp(i)=motorp * pluse(i) / 360 + zerop(i);%由电机转角计算到电机脉冲数
    elseif i==4 %第4轴 旋转运动
        ratio4=pluseequ(i) * 360 /pluse(i);%计算关节4电机至花键螺母侧同步轮的减速比
        motorp=axisp(4)*ratio4;%由关节转角解耦到电机转角
        motorpp(i)=motorp * pluse(i) / 360 + zerop(i);%由电机转角计算到电机脉冲数
    else
        motorpp(i)=axisp(i) * pluseequ(i) + zerop(i);
    end
end

end
