# 运动学逆解推算
# @Time:2021/7/6 8:00
# @Auther:Tonghui Wang
# @File:ER5_800_ikine.py
# @software:IDLE

# -*- coding: UTF-8 -*-
import numpy as np
import sympy as sy

# 定义可能用到的符号变量
a0,a1,a2,a3,a4,a5=sy.symbols('a0 a1 a2 a3 a4 a5')
d1,d2,d3,d4,d5,d6=sy.symbols('d1 d2 d3 d4 d5 d6')
q1,q2,q3,q4,q5,q6=sy.symbols('q1 q2 q3 q4 q5 q6')

# 定义DH参数
theta=[0, sy.pi/2, 0, 0, 0, 0]
d=[d1, d2, -d2, d4, 0, d6]
a=[0, a1, a2, a3, 0, a5]
alpha=[0, sy.pi/2, 0, sy.pi/2, -sy.pi/2, sy.pi/2]
# 运行轨迹时各轴相对零位的实际角位移
q=[q1, q2, q3, q4, q5, q6]

# 定义A矩阵的计算函数(MDH方法)
def mdh_matrix(alpha, a, d, theta):
    matrix = sy.eye(4)
    matrix[0,0] = sy.cos(theta)
    matrix[0,1] = -sy.sin(theta)
    matrix[0,2] = 0
    matrix[0,3] = a
    matrix[1,0] = sy.sin(theta)*sy.cos(alpha)
    matrix[1,1] = sy.cos(theta)*sy.cos(alpha)
    matrix[1,2] = -sy.sin(alpha)
    matrix[1,3] = -sy.sin(alpha)*d
    matrix[2,0] = sy.sin(theta)*sy.sin(alpha)
    matrix[2,1] = sy.cos(theta)*sy.sin(alpha)
    matrix[2,2] = sy.cos(alpha)
    matrix[2,3] = sy.cos(alpha)*d
    matrix[3,0] = 0
    matrix[3,1] = 0
    matrix[3,2] = 0
    matrix[3,3] = 1
    return sy.simplify(matrix)

# 求取从基座标系到末端法兰坐标系的齐次变换矩阵
T0=sy.eye(4)
for i in range(6):
    A=mdh_matrix(alpha[i], a[i], d[i], theta[i]+q[i])
    T0=T0*A
T0=sy.simplify(T0)

# 拆分j6坐标系的平移和旋转,使坐标原点平移到j4、j5坐标中心，形成球形腕
tool_inv=sy.Matrix([[1,0,0,-a[5]],[0,1,0,0],[0,0,1,-d[5]],[0,0,0,1]])
T1=T0*tool_inv

# 球形腕坐标原点
o_w_x=T1[0,3]
o_w_y=T1[1,3]
o_w_z=T1[2,3]

# q1
q1_1=sy.atan2(o_w_x,o_w_y)
q1_2=q1_1+sy.pi

q1_1=sy.trigsimp(q1_1)
q1_2=sy.trigsimp(q1_2)
print(q1_1)
print(q1_2)

# q3
r=sy.sqrt(sy.Pow(o_w_x,2)+sy.Pow(o_w_y,2))
s=o_w_z-d[0]
r2=a[2]
r3=sy.sqrt(sy.Pow(a[3],2)+sy.Pow(d[3],2))
d=(sy.Pow(r,2)+sy.Pow(s,2)-sy.Pow(r2,2)-sy.Pow(r3,2))/(2*r2*r3)
q3_1=sy.atan2(d,sy.sqrt(1-sy.Pow(d,2)))
q3_2=sy.atan2(d,-sy.sqrt(1-sy.Pow(d,2)))

q3_1=sy.trigsimp(q3_1)
q3_2=sy.trigsimp(q3_2)
print(q3_1)
print(q3_2)

# q2
q2_1=sy.atan2(r,s)-sy.atan2(r2+r3*sy.cos(q3_1),r3*sy.sin(q3_1))
q2_2=sy.atan2(r,s)-sy.atan2(r2+r3*sy.cos(q3_2),r3*sy.sin(q3_2))

q2_1=sy.trigsimp(q2_1)
q2_2=sy.trigsimp(q2_2)
print(q2_1)
print(q2_2)

r11=T[0,0]
r12=T[0,1]
r13=T[0,2]
r21=T[1,0]
r22=T[1,1]
r22=T[1,2]
r31=T[2,0]
r32=T[2,1]
r33=T[2,2]

# q5
q5_1=sy.atan2(sy.sin(q1_1)*r13-sy.cos(q1_1)*r23, sy.sqrt(1-sy.Pow(sy.sin(q1_1)*r13-sy.cos(q1_1)*r23,2)))
q5_2=sy.atan2(sy.sin(q1_1)*r13-sy.cos(q1_1)*r23, -sy.sqrt(1-sy.Pow(sy.sin(q1_1)*r13-sy.cos(q1_1)*r23,2)))

q5_1=sy.trigsimp(q5_1)
q5_2=sy.trigsimp(q5_2)
print(q5_1)
print(q5_2)

# q4
q4_1=sy.atan2(sy.cos(q1_1)*sy.cos(q2_1+q3_1)*r13+sy.sin(q1_1)*sy.cos(q2_1+q3_1)*r23+sy.sin(q2_1+q3_1)*r33, \
              -sy.cos(q1_1)*sy.sin(q2_1+q3_1)*r13-sy.sin(q1_1)*sy.sin(q2_1+q3_1)*r23+sy.cos(q2_1+q3_1)*r33)
q4_2=sy.atan2(sy.cos(q1_2)*sy.cos(q2_1+q3_1)*r13+sy.sin(q1_2)*sy.cos(q2_1+q3_1)*r23+sy.sin(q2_1+q3_1)*r33, \
              -sy.cos(q1_2)*sy.sin(q2_1+q3_1)*r13-sy.sin(q1_2)*sy.sin(q2_1+q3_1)*r23+sy.cos(q2_1+q3_1)*r33)
q4_3=sy.atan2(sy.cos(q1_1)*sy.cos(q2_2+q3_2)*r13+sy.sin(q1_1)*sy.cos(q2_2+q3_2)*r23+sy.sin(q2_2+q3_2)*r33, \
              -sy.cos(q1_1)*sy.sin(q2_2+q3_2)*r13-sy.sin(q1_1)*sy.sin(q2_2+q3_2)*r23+sy.cos(q2_2+q3_2)*r33)
q4_4=sy.atan2(sy.cos(q1_2)*sy.cos(q2_2+q3_2)*r13+sy.sin(q1_2)*sy.cos(q2_2+q3_2)*r23+sy.sin(q2_2+q3_2)*r33, \
              -sy.cos(q1_2)*sy.sin(q2_2+q3_2)*r13-sy.sin(q1_2)*sy.sin(q2_2+q3_2)*r23+sy.cos(q2_2+q3_2)*r33)

q4_1=sy.trigsimp(q4_1)
q4_2=sy.trigsimp(q4_2)
q4_3=sy.trigsimp(q4_3)
q4_4=sy.trigsimp(q4_4)
print(q4_1)
print(q4_2)
print(q4_3)
print(q4_4)

# q6
q6_1=sy.atan2(-sy.sin(q1_1)*r11+sy.cos(q1_1)*r21, sy.sin(q1_1)*r12-sy.cos(q1_1)*r22)
q6_2=sy.atan2(-sy.sin(q1_2)*r11+sy.cos(q1_2)*r21, sy.sin(q1_2)*r12-sy.cos(q1_2)*r22)

q6_1=sy.trigsimp(q6_1)
q6_2=sy.trigsimp(q6_2)
print(q6_1)
print(q6_2)


'''
# 根据T计算[x,y,z,r,p,y]
def tform2pos(T):
    temp=(T[0,0]**2+T[1,0]**2)**0.5
    if temp<1e-6:
        r=sy.atan2(-T[1,2],T[1,1])
        p=sy.atan2(-T[2,0],temp)
        y=0
    else:
        r=sy.atan2(T[2,1],T[2,2])
        p=sy.atan2(-T[2,0],temp)
        y=sy.atan2(T[1,0],T[0,0])

    x=T[0,3]
    y=T[1,3]
    z=T[2,3]
    r=r/sy.pi*180
    p=p/sy.pi*180
    y=y/sy.pi*180
    
    return sy.Matrix([x, y, z, r, p, y])

##eul=tform2pos(T)
##print(eul)
'''
