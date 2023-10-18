# 运动学正解推算
# @Time:2023/6/15 9:30
# @Auther:Tonghui Wang
# @File:Ganty_fkine.py
# @Software:IDLE

import sympy as sy

# 定义可能用到的符号变量
a6,d6=sy.symbols('a6 d6')
axis1,axis2,axis3,axis4,axis5=sy.symbols('axis1 axis2 axis3 axis4 axis5')

'''
|_i_|_theta_|_d_|__a__|_alpha_|_axis_l_|
| 4 |  -90  | 0 |  0  |  -90  |  axis4 |
| 5 |   90  | 0 |  0  |  -90  |  axis5 |
| 6 |  -90  |d6 |  a6 |  -90  |    0   |
'''
# 定义DH参数
theta=[-sy.pi/2, sy.pi/2, -sy.pi/2]
d=[0, 0, d6]
a=[0, 0, 0]
alpha=[-sy.pi/2, -sy.pi/2, -sy.pi/2]
# 运行轨迹时各轴相对零位的实际角位移
axis=[axis4, axis5, 0]

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

# 根据T计算[x,y,z,r,p,y]
def tform2pos(T):
    temp=sy.sqrt(T[0,0]**2+T[1,0]**2)
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
    
    return sy.Matrix([x, y, z, y, p, r])

# 计算基座与末端的T矩阵
T=sy.eye(4)
T[0,3]=axis1
T[1,3]=axis2
T[2,3]=axis3

for i in range(3):
    A=mdh_matrix(alpha[i], a[i], d[i], theta[i]+axis[i])
    sy.pprint(sy.simplify(A))
    T=T*A
    
T=sy.simplify(T)
sy.pprint(T)

'''
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
