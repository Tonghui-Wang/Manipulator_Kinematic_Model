# 运动学符号运算推导
# @Time:2021/11/16 17:30
# @Auther:Tonghui Wang
# @File:fkine.py
# @software:IDLE

# -*- coding: UTF-8 -*-
import sympy as sy
import numpy as np

a2,a3,a4,d1,d4,d6=sy.symbols('a2 a3 a4 d1 d4 d6')
q1,q2,q3,q4,q5,q6=sy.symbols('q1 q2 q3 q4 q5 q6')
# nx,ny,nz,ox,oy,oz,ax,ay,az,px,py,pz=sy.symbols('nx ny nz ox oy oz ax ay az px py pz')

theta=[0, sy.pi/2, 0, 0, -sy.pi/2, 0]
d=[d1, 0, 0, d4, 0, d6]
a=[0, a2, a3, a4, 0, 0]
alpha=[0, sy.pi/2, 0, sy.pi/2, -sy.pi/2, sy.pi/2]
q=[q1, q2, q3, q4, q5, q6]

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

A1=mdh_matrix(alpha[0], a[0], d[0], theta[0]+q[0])
A2=mdh_matrix(alpha[1], a[1], d[1], theta[1]+q[1])
A3=mdh_matrix(alpha[2], a[2], d[2], theta[2]+q[2])
A4=mdh_matrix(alpha[3], a[3], d[3], theta[3]+q[3])
A5=mdh_matrix(alpha[4], a[4], d[4], theta[4]+q[4])
A6=mdh_matrix(alpha[5], a[5], d[5], theta[5]+q[5])

T=A1*A2*A3*A4*A5*A6
for i in range(3):
    for j in range(4):
        T[i,j]=sy.trigsimp(T[i,j])

s1,s2,s3,s4,s5,s6,s23,s234=sy.symbols('s1 s2 s3 s4 s5 s6 s23 s234')
c1,c2,c3,c4,c5,c6,c23,c234=sy.symbols('c1 c2 c3 c4 c5 c6 c23 c234')
T=T.subs([(sy.sin(q1),s1),(sy.sin(q2),s2),(sy.sin(q3),s3),(sy.sin(q4),s4),(sy.sin(q5),s5), \
          (sy.sin(q6),s6),(sy.sin(q2+q3),s23),(sy.sin(q2+q3+q4),s234), \
          (sy.cos(q1),c1),(sy.cos(q2),c2),(sy.cos(q3),c3),(sy.cos(q4),c4),(sy.cos(q5),c5), \
          (sy.cos(q6),c6),(sy.cos(q2+q3),c23),(sy.cos(q2+q3+q4),c234)])

for i in range(3):
    for j in range(4):
        print(T[i,j])


# T=sy.Matrix([[nx,ox,ax,px], [ny,oy,ay,py], [nz,oz,az,pz], [0,0,0,1]])

# T_1=(A4**-1)*(A3**-1)*(A2**-1)*(A1**-1)*T
# T_2=A5*A6

# print(sy.trigsimp((T_1[0,3]-a2)**2+T_1[1,3]**2+T_1[2,3]**2))
# print(sy.trigsimp((T_2[0,3]-a2)**2+T_2[1,3]**2+T_2[2,3]**2))
# print(sy.trigsimp(T_1[1,0]))
# print(sy.trigsimp(T_1[1,1]))
# print(sy.trigsimp(T_2[1,0]))
# print(sy.trigsimp(T_2[1,1]))

# T_1=(A2**-1)*(A1**-1)
# for i in range(3):
#     for j in range(4):
#         print(sy.trigsimp(T_1[i,j]))
