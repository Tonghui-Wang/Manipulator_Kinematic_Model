# -*- coding: UTF-8 -*-
# import numpy as np
from re import A
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
| 3 |  -90  | 0 |a2 |   0   |   q3  |
| 4 |   90  |d4 |a3 |   0   |   q4  |
| 5 |   90  |d5 | 0 |   90  |   q5  |
| 6 |  -90  |d6 | 0 |  -90  |   q6  |
'''
# 定义DH参数
theta=[0, sy.pi/2, -sy.pi/2, sy.pi/2, sy.pi/2, -sy.pi/2]
d=[d1, 0, 0, d4, d5, d6]
a=[0, a1, a2, a3, 0, 0]
alpha=[0, sy.pi/2, 0, 0, sy.pi/2, -sy.pi/2]

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

# 求取从基座标系到末端法兰坐标系的齐次变换矩阵
T=np.mat(np.eye(4))
for i in range(6):
    A=mdh_matrix(alpha[i], a[i], d[i], theta[i]+q[i])
    T=sy.simplify(T*A)

s1,s2,s23,s234,s5,s6=sy.symbols('s1 s2 s23 s234 s5 s6')
c1,c2,c23,c234,c5,c6=sy.symbols('c1 c2 c23 c234 c5 c6')
T=T.subs([(sy.sin(q1),s1),(sy.sin(q2),s2),(sy.sin(q2+q3),s23),(sy.sin(q5),s5), \
          (sy.sin(q6),s6),(sy.sin(q2+q3+q4),s234), \
          (sy.cos(q1),c1),(sy.cos(q2),c2),(sy.cos(q2+q3),c23),(sy.cos(q5),c5), \
          (sy.cos(q6),c6),(sy.cos(q2+q3+q4),c234)])

print(T[0,0])
print(T[0,1])
print(T[0,2])
print(T[0,3])
print(T[1,0])
print(T[1,1])
print(T[1,2])
print(T[1,3])
print(T[2,0])
print(T[2,1])
print(T[2,2])
print(T[2,3])

# A1=mdh_matrix(alpha[0], a[0], d[0], theta[0]+q[0])
# A2=mdh_matrix(alpha[1], a[1], d[1], theta[1]+q[1])
# A3=mdh_matrix(alpha[2], a[2], d[2], theta[2]+q[2])
# A4=mdh_matrix(alpha[3], a[3], d[3], theta[3]+q[3])
# A5=mdh_matrix(alpha[4], a[4], d[4], theta[4]+q[4])
# A6=mdh_matrix(alpha[5], a[5], d[5], theta[5]+q[5])

# nx,ny,nz,ox,oy,oz=sy.symbols('nx ny nz ox oy oz')
# ax,ay,az,px,py,pz=sy.symbols('ax ay az px py pz')
# T=sy.eye(4)
# T[0,0]=nx
# T[1,0]=ny
# T[2,0]=nz
# T[0,1]=ox
# T[1,1]=oy
# T[2,1]=oz
# T[0,2]=ax
# T[1,2]=ay
# T[2,2]=az
# T[0,3]=px
# T[1,3]=py
# T[2,3]=pz

# T_1=sy.simplify(A1**-1*T*A6**-1)
# T_2=sy.simplify(A2*A3*A4*A5)
# s1,s2,s23,s234,s5,s6=sy.symbols('s1 s2 s23 s234 s5 s6')
# c1,c2,c23,c234,c5,c6=sy.symbols('c1 c2 c23 c234 c5 c6')
# T_1=T_1.subs([(sy.sin(q1),s1),(sy.sin(q2),s2),(sy.sin(q2+q3),s23),(sy.sin(q5),s5), \
#             (sy.sin(q6),s6),(sy.sin(q2+q3+q4),s234), \
#             (sy.cos(q1),c1),(sy.cos(q2),c2),(sy.cos(q2+q3),c23),(sy.cos(q5),c5), \
#             (sy.cos(q6),c6),(sy.cos(q2+q3+q4),c234)])
# T_2=T_2.subs([(sy.sin(q1),s1),(sy.sin(q2),s2),(sy.sin(q2+q3),s23),(sy.sin(q5),s5), \
#             (sy.sin(q6),s6),(sy.sin(q2+q3+q4),s234), \
#             (sy.cos(q1),c1),(sy.cos(q2),c2),(sy.cos(q2+q3),c23),(sy.cos(q5),c5), \
#             (sy.cos(q6),c6),(sy.cos(q2+q3+q4),c234)])

# for i in range(3):
#     for j in range(4):
#         print(T_1[i,j],T_2[i,j],sep=" = ")
    # print(T_1[i,3],T_2[i,3],sep=" = ")



'''
o_w=T06[0:3,3]-d6*T06[0:3,2]
o_w_x=o_w[0]
o_w_y=o_w[1]
o_w_z=o_w[2]

# q1
q1_1=sy.trigsimp(sy.atan2(o_w_y, o_w_x))
q1_2=sy.trigsimp(q1_1+sy.pi)

print(q1_1)
print(q1_2)

# q3
r=sy.sqrt(sy.Pow(o_w_x,2)+sy.Pow(o_w_y,2))
s=o_w_z-d[0]
r2=a[2]
r3=d[3]
d=(sy.Pow(r,2)+sy.Pow(s,2)-sy.Pow(r2,2)-sy.Pow(r3,2))/(2*r2*r3)
q3_1=sy.trigsimp(sy.atan2(d, sy.sqrt(1-sy.Pow(d,2))))
q3_2=sy.trigsimp(sy.atan2(d,-sy.sqrt(1-sy.Pow(d,2))))

print(q3_1)
print(q3_2)

r11=T3[0,0]
r12=T3[0,1]
r13=T3[0,2]
r21=T3[1,0]
r22=T3[1,1]
r23=T3[1,2]
r31=T3[2,0]
r32=T3[2,1]
r33=T3[2,2]

# q2
q2_1=sy.trigsimp(sy.atan2(r,s)-sy.atan2(r2+r3*sy.cos(q3_1),r3*sy.sin(q3_1)))
q2_2=sy.trigsimp(sy.atan2(r,s)-sy.atan2(r2+r3*sy.cos(q3_2),r3*sy.sin(q3_2)))

# q5
q5_1=sy.atan2(sy.sin(q1_1)*r13-sy.cos(q1_1)*r23, sy.sqrt(1-sy.Pow(sy.sin(q1_1)*r13-sy.cos(q1_1)*r23,2)))
q5_2=sy.atan2(sy.sin(q1_1)*r13-sy.cos(q1_1)*r23, -sy.sqrt(1-sy.Pow(sy.sin(q1_1)*r13-sy.cos(q1_1)*r23,2)))

q5_1=sy.trigsimp(q5_1)
q5_2=sy.trigsimp(q5_2)
print(q5_1)
print(q5_2)

# q4
q4_1=sy.atan2(sy.cos(q1_1)*sy.cos(q2_1+q3_1)*r13+sy.sin(q1_1)*sy.cos(q2_1+q3_1)*r23+sy.sin(q2_1+q3_1)*r33, -sy.cos(q1_1)*sy.sin(q2_1+q3_1)*r13-sy.sin(q1_1)*sy.sin(q2_1+q3_1)*r23+sy.cos(q2_1+q3_1)*r33)
q4_2=sy.atan2(sy.cos(q1_2)*sy.cos(q2_1+q3_1)*r13+sy.sin(q1_2)*sy.cos(q2_1+q3_1)*r23+sy.sin(q2_1+q3_1)*r33, -sy.cos(q1_2)*sy.sin(q2_1+q3_1)*r13-sy.sin(q1_2)*sy.sin(q2_1+q3_1)*r23+sy.cos(q2_1+q3_1)*r33)
q4_3=sy.atan2(sy.cos(q1_1)*sy.cos(q2_2+q3_2)*r13+sy.sin(q1_1)*sy.cos(q2_2+q3_2)*r23+sy.sin(q2_2+q3_2)*r33, -sy.cos(q1_1)*sy.sin(q2_2+q3_2)*r13-sy.sin(q1_1)*sy.sin(q2_2+q3_2)*r23+sy.cos(q2_2+q3_2)*r33)
q4_4=sy.atan2(sy.cos(q1_2)*sy.cos(q2_2+q3_2)*r13+sy.sin(q1_2)*sy.cos(q2_2+q3_2)*r23+sy.sin(q2_2+q3_2)*r33, -sy.cos(q1_2)*sy.sin(q2_2+q3_2)*r13-sy.sin(q1_2)*sy.sin(q2_2+q3_2)*r23+sy.cos(q2_2+q3_2)*r33)

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
