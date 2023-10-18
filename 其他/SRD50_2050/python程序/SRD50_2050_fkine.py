# 运动学正解推算
# @Time:2021/7/5 17:30
# @Auther:Tonghui Wang
# @File:SRD50_2050_fkine.py
# @software:IDLE

import sympy as sy
import numpy as np

# 定义可能用到的符号变量
a1,a2,a3,a4,a5,a6=sy.symbols('a1 a2 a3 a4 a5 a6')
d1,d2,d3,d4,d5,d6=sy.symbols('d1 d2 d3 d4 d5 d6')
q1,q2,q3,q4,q5,q6=sy.symbols('q1 q2 q3 q4 q5 q6')

'''
|_i_|_theta_|_d_|_a_|_alpha_|_angle_|
| 1 |   0   |d1 | 0 |   0   |   q1  |
| 2 |   90  | 0 |a1 |   90  |   q2  |
| 3 |   0   | 0 |a2 |   0   |   q3  |
| 4 |   0   |d4 |a3 |   90  |   q4  |
| 5 |  -90  | 0 | 0 |  -90  |   q5  |
| 6 |   0   |d6 | 0 |   90  |   q6  |
'''
# 定义DH参数
theta=[0, sy.pi/2, 0, 0, -sy.pi/2, 0]
d=[d1, 0, 0, d4, 0, d6]
a=[0, a1, a2, a3, 0, 0]
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
    return matrix

# 计算基座与末端的T矩阵
num=6
T=sy.eye(4)

for i in range(num):
    T=T*mdh_matrix(alpha[i], a[i], d[i], theta[i]+q[i])
T=sy.simplify(T)
sy.pprint(T)
print('_'*20)

# 带入DH参数，并设置角位移为[0,0,0,0,0,0]
temp=T.subs([(a1,145),(a2,870),(a3,170),(d1,530),(d4,1039),(d6,225), \
             (q1,0),(q2,0),(q3,0),(q4,0),(q5,0),(q6,0)])
sy.pprint(temp)
print('_'*20)

# 带入DH参数，并设置角位移为[-45,0,0,0,0,90]
temp=T.subs([(a1,145),(a2,870),(a3,170),(d1,530),(d4,1039),(d6,225), \
             (q1,-np.pi/4),(q2,0),(q3,0),(q4,0),(q5,0),(q6,np.pi/2)])
sy.pprint(temp)
print('_'*20)

# 带入DH参数，并设置角位移为[0,180,-90,45,30,0]
temp=T.subs([(a1,145),(a2,870),(a3,170),(d1,530),(d4,1039),(d6,225), \
             (q1,0),(q2,np.pi),(q3,-np.pi/2),(q4,np.pi/4),(q5,np.pi/6),(q6,0)])
sy.pprint(temp)
print('_'*20)

# 带入DH参数，并设置角位移为[-10,18,-60,45,80,-90]
temp=T.subs([(a1,145),(a2,870),(a3,170),(d1,530),(d4,1039),(d6,225), \
             (q1,-np.pi/18),(q2,np.pi/10),(q3,-np.pi/3),(q4,np.pi/4),(q5,np.pi/9*4),(q6,-np.pi/2)])
sy.pprint(temp)
print('_'*20)

'''
s1,s2,s3,s4,s5,s6=sy.symbols('s1 s2 s3 s4 s5 s6')
c1,c2,c3,c4,c5,c6=sy.symbols('c1 c2 c3 c4 c5 c6')
T=sy.expand_trig(T)
T=T.subs([(sy.sin(q1),s1),(sy.sin(q2),s2),(sy.sin(q3),s3), \
          (sy.sin(q4),s4),(sy.sin(q5),s5),(sy.sin(q6),s6), \
          (sy.cos(q1),c1),(sy.cos(q2),c2),(sy.cos(q3),c3), \
          (sy.cos(q4),c4),(sy.cos(q5),c5),(sy.cos(q6),c6)])
T=sy.simplify(T)
'''

'''
# 借助机器人工具箱进行可视化仿真
import roboticstoolbox as rtb
import numpy as np

l1=rtb.RevoluteMDH(d=530,a=0,alpha=0)
l2=rtb.RevoluteMDH(d=0,a=145,alpha=np.pi/2)
l3=rtb.RevoluteMDH(d=0,a=870,alpha=0)
l4=rtb.RevoluteMDH(d=1039,a=170,alpha=np.pi/2)
l5=rtb.RevoluteMDH(d=0,a=0,alpha=-np.pi/2)
l6=rtb.RevoluteMDH(d=225,a=0,alpha=np.pi/2)
robot=rtb.DHRobot([l1,l2,l3,l4,l5,l6])

qz=[0,np.pi/2,0,0,-np.pi/2,0]
##T=robot.fkine(qz)
##print(T)

robot.teach(qz)
'''

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
'''
