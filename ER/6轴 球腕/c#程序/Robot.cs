using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace test
{
    class Robot
    {
        public Robot()
        {
            //DH参数
            double a1 = 142;
            double a2 = 680;
            double a3 = 110;
            double d1 = 332;
            double d4 = 630;
            double d6 = 103;
        }

        //正运动学
        //q表示各关节角位移，单位°
        public double[] Fkine(double[] q)
        {
            //角度转弧度
            q = q * Math.PI / 360;

            //符号简化
            double s1 = Math.Sin(q[0]);
            double s2 = Math.Sin(q[1]);
            double s23 = Math.Sin(q[1] + q[2]);
            double s4 = Math.Sin(q[3]);
            double s5 = Math.Sin(q[4]);
            double s6 = Math.Sin(q[5]);
            double c1 = Math.Cos(q[0]);
            double c2 = Math.Cos(q[1]);
            double c23 = Math.Cos(q[1] + q[2]);
            double c4 = Math.Cos(q[3]);
            double c5 = Math.Cos(q[4]);
            double c6 = Math.Cos(q[5]);

            //位姿矩阵计算
            double[,] tform = new double[4, 4];
            tform[0, 0] = c6 * (c1 * c23 * c5 + s5 * (-c1 * c4 * s23 + s1 * s4)) + s6 * (c1 * s23 * s4 + c4 * s1);
            tform[0, 1] = c6 * (c1 * s23 * s4 + c4 * s1) - s6 * (c1 * c23 * c5 + s5 * (-c1 * c4 * s23 + s1 * s4));
            tform[0, 2] = c1 * c23 * s5 - c5 * (-c1 * c4 * s23 + s1 * s4);
            tform[0, 3] = c1 * (a1 - a2 * s2 - a3 * s23 + c23 * d4) - d6 * (-c1 * c23 * s5 + c5 * (-c1 * c4 * s23 + s1 * s4));
            tform[1, 0] = -c6 * (-c23 * c5 * s1 + s5 * (c1 * s4 + c4 * s1 * s23)) + s6 * (-c1 * c4 + s1 * s23 * s4);
            tform[1, 1] = c6 * (-c1 * c4 + s1 * s23 * s4) + s6 * (-c23 * c5 * s1 + s5 * (c1 * s4 + c4 * s1 * s23));
            tform[1, 2] = c23 * s1 * s5 + c5 * (c1 * s4 + c4 * s1 * s23);
            tform[1, 3] = d6 * (c23 * s1 * s5 + c5 * (c1 * s4 + c4 * s1 * s23)) + s1 * (a1 - a2 * s2 - a3 * s23 + c23 * d4);
            tform[2, 0] = -c23 * s4 * s6 + c6 * (c23 * c4 * s5 + c5 * s23);
            tform[2, 1] = -c23 * c6 * s4 - s6 * (c23 * c4 * s5 + c5 * s23);
            tform[2, 2] = -c23 * c4 * c5 + s23 * s5;
            tform[2, 3] = a2 * c2 + a3 * c23 + d1 + d4 * s23 + d6 * (-c23 * c4 * c5 + s23 * s5);
            tform[3, 0] = 0;
            tform[3, 1] = 0;
            tform[3, 2] = 0;
            tform[3, 3] = 1;

            //TCP位姿描述
            return Tform2Pit(tform);
        }

        //逆运动学
        //pit表示末端位姿[x,y,z,a,b,c]，xyz单位为mm，abc单位为°
        //flag表示选解标志位
        private double[] Ikine(double[] pit, int[] flag)
        {
            //位姿矩阵计算
            double[,] tform = Pit2Tform(pit);
            //关节角位移声明
            double[] q = new double[6];

            //J1
            q[0] = Math.Atan2(tform[1, 3], tform[0, 3]);
            double s1 = Math.Sin(q[0]);
            double c1 = Math.Cos(q[0]);

            //J3
            double tmp1 = (Math.Pow(Math.Sqrt(tform[0, 3] * tform[0, 3] + tform[1, 3] * tform[1, 3]) - a1, 2) + Math.Pow(tform[2, 3] - d1, 2) - a2 * a2 - a3 * a3 - d4 * d4) / (2 * a2);
            q[2] = Math.Atan2(-a3, d4) - Math.Atan2(-tmp1, Math.Sqrt(a3 * a3 + d4 * d4 - tmp1 * tmp1) * flag[1]);

            //J2
            tmp1 = (a1 - Math.Sqrt(tform[0, 3] * tform[0, 3] + tform[1, 3] * tform[1, 3])) * a3 + (tform[2, 3] - d1) * d4;
            double tmp2 = (a1 - Math.Sqrt(tform[0, 3] * tform[0, 3] + tform[1, 3] * tform[1, 3])) * d4 - (tform[2, 3] - d1) * a3;
            double tmp3 = (a2 * a2 - a3 * a3 - d4 * d4 - Math.Pow(a1 - Math.Sqrt(tform[0, 3] * tform[0, 3] + tform[1, 3] * tform[1, 3]), 2) - Math.Pow(tform[2, 3] - d1, 2)) / 2;
            double q23 = Math.atan2(tmp2, tmp1) - Math.atan2(tmp3, Math.Sqrt(tmp1 * tmp1 + tmp2 * tmp2 - tmp3 * tmp3) * flag[0]);
            q[1] = q23 - q[2];
            double s23 = Math.Sin(q23);
            double c23 = Math.Cos(q23);

            //J4
            q[3] = Math.atan2(tform[1, 2] * c1 - tform[0, 2] * s1, (tform[0, 2] * c1 + tform[1, 2] * s1) * s23 - atform[2, 2] * c23);

            //J5
            tmp1 = (tform[0, 2] * c1 + tform[1, 2] * s1) * c23 + atform[2, 2] * s23;
            q[4] = Math.Atan2(tmp1, Math.Sqrt(1 - tmp1 * tmp1) * flag[2]);

            //J6
            q[5] = Math.Atan2(-tform[2, 1] * s23 - (tform[0, 1] * c1 + tform[1, 1] * s1) * c23, tform[2, 0] * s23 + (tform[0, 0] * c1 + tform[1, 0] * s1) * c23);

            //弧度转角度
            q = q * 360 / Math.PI;
            //关节角位移输出
            return q;
        }

        //逆解选解
        //pit表示待求解得末端位姿[x,y,z,a,b,c]
        //qlast表示上一周期的关节角位移，用于与本次计算的角位移作比较
        public double[] Ikinesel(double[] pit, double[] qlast)
        {
            //最大偏差初值
            double error = 10000;
            //选取的最优逆解角位移
            double qsel = new double[6];

            //-1和1
            for (int i = -1; i < 1; i = i + 2)
            {
                //-1和1
                for (int j = -1; j < 1; j = j + 2)
                {
                    //-1和1
                    for (int k = -1; k < 1; k = k + 2)
                    {
                        //选解标志位
                        int[] flag = new int[3] { i, j, k };
                        //逆解求解
                        double[] q = Ikine(pit, flag);

                        //本次计算逆解与上一周期逆解的偏差
                        double sum = 0;
                        for (int m = 0; m < 6; m++)
                        {
                            sum += Math.Abs(q[m] - qlast[m]);
                        }

                        //本次偏差小于最大偏差时，动态更新最大偏差和最优逆解
                        if (sum < error)
                        {
                            error = sum;
                            qsel = q;
                        }
                    }
                }
            }

            //最优逆解角位移输出
            return qsel;
        }

        //位姿转换：矩阵形式->[x,y,z,a,b,c]
        private double[] Tform2Pit(double[,] tform)
        {
            double[] pit = new double[6];

            pit[4] = Math.Sqrt(Math.Pow(tform[0, 0], 2) + Math.Pow(tform[1, 0], 2));
            if (pit[4] < 1e-6)
            {
                pit[3] = Math.Atan2(-tform[1, 2], tform[1, 1]);
                pit[4] = Math.Atan2(-tform[2, 0], tform);
                pit[5] = 0;
            }
            else
            {
                pit[3] = Math.Atan2(tform[2, 1], tform[2, 2]);
                pit[4] = Math.Atan2(-tform[2, 0], pit[4]);
                pit[5] = Math.Atan2(tform[1, 0], tform[0, 0]);
            }

            pit[0] = tform[0, 3];
            pit[1] = tform[1, 3];
            pit[2] = tform[2, 3];
            pit[3] = pit[3] * 360 / Math.PI;
            pit[4] = pit[4] * 360 / Math.PI;
            pit[5] = pit[5] * 360 / Math.PI;

            return pit;
        }

        //位姿转换：[x,y,z,a,b,c]->矩阵形式
        private double[,] Pit2Tform(double[] pit)
        {
            double sa = Math.Sin(pit[3] * Math.PI / 360);
            double sb = Math.Sin(pit[4] * Math.PI / 360);
            double sc = Math.Sin(pit[5] * Math.PI / 360);
            double ca = Math.Cos(pit[3] * Math.PI / 360);
            double cb = Math.Cos(pit[4] * Math.PI / 360);
            double cc = Math.Cos(pit[5] * Math.PI / 360);

            double[,] tform = new double[4, 4];
            tform[0, 0] = cc * cb;
            tform[0, 1] = cc * sb * sa - ca * sc;
            tform[0, 2] = sc * sa + cc * ca * sb;
            tform[0, 3] = pit[0] - d6 * tform[2, 0];
            tform[1, 0] = cb * sc;
            tform[1, 1] = cc * ca + sc * sb * sa;
            tform[1, 2] = ca * sc * sb - cc * sa;
            tform[1, 3] = pit[1] - d6 * tform[2, 1];
            tform[2, 0] = -sb;
            tform[2, 1] = cb * sa;
            tform[2, 2] = cb * ca;
            tform[2, 3] = pit[2] - d6 * tform[2, 2];
            tform[3, 0] = 0;
            tform[3, 1] = 0;
            tform[3, 2] = 0;
            tform[3, 3] = 1;

            return tform;
        }

        //单例模式控制
        private static Robot instance;
        private static object _lock = new object();
        public static Robot GetInstance()
        {
            if (instance == null)
            {
                lock (_lock)
                {
                    if (instance == null)
                    {
                        instance = new Robot();
                    }
                }
            }
            return instance;
        }
    }
}