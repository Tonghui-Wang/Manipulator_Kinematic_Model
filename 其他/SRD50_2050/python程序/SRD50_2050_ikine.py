# 运动学逆解推算
# @Time:2021/7/6 8:00
# @Auther:Tonghui Wang
# @File:SRD50_2050_ikine.py
# @software:IDLE

import sympy as sy
import numpy as np

# 定义A矩阵的计算函数(MDH方法)
def mdh_matrix(theta, d, a, alpha):
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
    return matrix

# 正解函数
def fkine(q):
    '''
    |_i_|_theta_|_d_|_a_|_alpha_|_angle_|
    | 1 |   0   |d1 | 0 |   0   |   q1  |
    | 2 |  -90  | 0 |a1 |   90  |   q2  |
    | 3 |   0   | 0 |a2 |   0   |   q3  |
    | 4 |   0   |d4 |a3 |   90  |   q4  |
    | 5 |  -90  | 0 | 0 |  -90  |   q5  |
    | 6 |   0   |d6 | 0 |   90  |   q6  |
    '''
    # 定义DH参数
    a1,a2,a3=145,870,170
    d1,d4,d6=530,1039,225

    theta=[0, sy.pi/2, 0, 0, -sy.pi/2, 0]
    d=[d1, 0, 0, d4, 0, d6]
    a=[0, a1, a2, a3, 0, 0]
    alpha=[0, sy.pi/2, 0, sy.pi/2, -sy.pi/2, sy.pi/2]

    T=sy.eye(4)
    for i in range(6):
        A=mdh_matrix(theta[i]+q[i], d[i], a[i], alpha[i])
        T=T*A
    return T

def eul2tform(eul):
    eul=sy.Matrix(eul)/sy.pi*180
    a,b,b=eul[0],eul[1],eul[2]
    
    T=sy.eye(4)
    T[0,0]=sy.cos(a)*sy.cos(b)
    T[0,1]=sy.cos(a)*sy.sin(b)*sy.sin(c)-sy.sin(a)*sy.cos(c)
    T[0,2]=sy.cos(a)*sy.sin(b)*sy.cos(c)+sy.sin(a)*sy.sin(c)
    T[0,3]=0
    T[1,0]=sy.sin(a)*sy.cos(b)
    T[1,1]=sy.sin(a)*sy.sin(b)*sy.sin(c)+sy.cos(a)*sy.cos(c)
    T[1,2]=sy.sin(a)*sy.sin(b)*sy.cos(c)-sy.cos(a)*sy.sin(c)
    T[1,3]=0
    T[2,0]=-sy.sin(b)
    T[2,1]=sy.cos(b)*sy.sin(c)
    T[2,2]=sy.cos(b)*sy.cos(c)
    T[2,3]=0
    T[3,0]=0
    T[3,1]=0
    T[3,2]=0
    T[3,3]=1
    return T

# 根据齐次矩阵计算欧拉角
def tform2eul(tform):
    temp=(tform[0,0]**2+tform[1,0]**2)**0.5
    if temp<1e-6:
        r=sy.atan2(-tform[1,2],tform[1,1])
        p=sy.atan2(-tform[2,0],temp)
        y=0
    else:
        r=sy.atan2(tform[2,1],tform[2,2])
        p=sy.atan2(-tform[2,0],temp)
        y=sy.atan2(tform[1,0],tform[0,0])

    x,y,z=tform[0,3],tform[1,3],tform[2,3]
    r=r/sy.pi*180
    p=p/sy.pi*180
    y=y/sy.pi*180
    
    return sy.Matrix([x, y, z, r, p, y])

# 逆解函数
def ikine(pose):
    a1,a2,a3=145,870,170
    d1,d4,d6=530,1039,225

    d=[d1, 0, 0, d4, 0, d6]
    a=[0, a1, a2, a3, 0, 0]

    T=eul2tform(pose[4:6]);
    T[0:3,3]=pose[0:3]-T[0:3,2]*d[5];

    T11=T[0,0];
    T12=T[0,1];
    T13=T[0,2];
    T14=T[0,3];
    T21=T[1,0];
    T22=T[1,1];
    T23=T[1,2];
    T24=T[1,3];
    T31=T[2,0];
    T32=T[2,1];
    T33=T[2,2];
    T34=T[2,3];
    T41=T[3,0];
    T42=T[3,1];
    T43=T[3,2];
    T44=T[3,3];

    # q1
    q1=atan2(T24,T14);

    # q2
    r=(T14**2+T24**2)**0.5-a[1];
    s=T34-d[0];
    r2=a[2];
    r3=(a[3]**2+d[3]**2)**0.5;
    c2=(r2**2+r**2+s**2-r3**2)/(2*r2*(r**2+s**2)**0.5);
    q2=atan2((1-c2**2)**0.5,c2)+atan2(s,r)-pi/2;

    # q3
    c3=(r2**2+r3**2-r**2-s**2)/(2*r2*r3);
    q3=atan2((1-c3**2)**0.5,c3)+atan2(d(4),a(4))-pi;
    
    # q4
    q23=q2+q3;
    q4=atan2(T23*cos(q1)-T13*sin(q1), \
        cos(q1)*sin(q23)*T13+sin(q1)*sin(q23)*T23-cos(q23)*T33);

    # q5
    q5=atan2(cos(q23)*(cos(q1)*T13+sin(q1)*T23)+sin(q23)*T33, \
        sqrt(1-(cos(q23)*(cos(q1)*T13+sin(q1)*T23)+sin(q23)*T33)^2));

    # q6
    q6=atan2(-cos(q1)*cos(q23)*T12-sin(q1)*cos(q23)*T22+sin(q23)*T32, \
        cos(q1)*cos(q23)*T11+sin(q1)*cos(q23)*T21+sin(q23)*T31);

    q=[q1,q2,q3,q4,q5,q6]/sy.pi*180;
    return q

'''
s1,s2,s3,s4,s5,s6=sy.symbols('s1 s2 s3 s4 s5 s6')
c1,c2,c3,c4,c5,c6=sy.symbols('c1 c2 c3 c4 c5 c6')
T=T.subs([(sy.sin(q1),s1),(sy.sin(q2),s2),(sy.sin(q3),s3), \
          (sy.sin(q4),s4),(sy.sin(q5),s5),(sy.sin(q6),s6), \
          (sy.cos(q1),c1),(sy.cos(q2),c2),(sy.cos(q3),c3), \
          (sy.cos(q4),c4),(sy.cos(q5),c5),(sy.cos(q6),c6)])
'''

q=[10,20,-3,48,-36,68]

T=fkine(q)

o=ikine(T)
