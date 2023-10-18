FUNCTION FN_PRRR_IK_SCD : AxisAngle
VAR_INPUT
	cCoordPoint		: CoordPoint;	//当前空间位置姿态
	InCurAxisAngle	: AxisAngle;	//上一次关节角度
	a2,a3,a4 		: LREAL;		//DH参数值-a
	d1,d4			: LREAL;		//DH参数值-d
END_VAR
VAR_OUTPUT
	errID		: INT;  //无解错误码为47
END_VAR
VAR
	px,py,pz,pa	: LREAL;
	tmp1,tmp2	: LREAL;
	theta1,theta2,theta3,theta4 : LREAL;
END_VAR

//////////////////////////////////////////////////////////////////////

errID:=0;

px := cCoordPoint.X-a2;
py := cCoordPoint.Y;
pz := cCoordPoint.Z-d1+d4;
pa := cCoordPoint.A*Deg2Rad;

//求关节转角1
theta1 := pz;

IF a3<EPS8 THEN
	a3:=1.0; //TODO: 此处应该报错？
	errID:=60;
END_IF
IF a4<EPS8 THEN
	a4:=1.0; //TODO: 此处应该报错？
	errID:=60;
END_IF

//求关节转角2
tmp1:=(a3*a3+px*px+py*py-a4*a4)/(2*a3*SQRT(px*px+py*py));
tmp1:=LIMIT(-1.0,tmp1,1.0);
theta2:=NW_atan2(py,px)+ACOS(tmp1);

//求关节转角3
tmp1:=(a3*a3+a4*a4-px*px-py*py)/(2*a3*a4);
tmp1:=LIMIT(-1.0,tmp1,1.0);
tmp2:=ACOS(tmp1);
IF ABS(InCurAxisAngle.lrAxis3*Deg2Rad-tmp2) <= ABS(InCurAxisAngle.lrAxis3*Deg2Rad+tmp2) THEN
	theta3:=tmp2;
ELSE
	theta3:=-tmp2;
END_IF

theta4:=theta2+theta3-pa;
theta4:=NW_atan2(SIN(theta4), COS(theta4));
IF (theta4 - InCurAxisAngle.lrAxis4*Deg2Rad) > PI THEN
	theta4:=theta4 - PI2;
ELSIF (theta4 - InCurAxisAngle.lrAxis4*Deg2Rad) < -PI THEN
	theta4:=theta4 + PI2;
END_IF

FN_PRRR_IK_SCD.lrAxis1 := theta1;
FN_PRRR_IK_SCD.lrAxis2 := theta2*Rad2Deg;
FN_PRRR_IK_SCD.lrAxis3 := theta3*Rad2Deg;
FN_PRRR_IK_SCD.lrAxis4 := theta4*Rad2Deg;
FN_PRRR_IK_SCD.lrAxis5 := 0;
FN_PRRR_IK_SCD.lrAxis6 := 0;
FN_PRRR_IK_SCD.lrAxis7 := cCoordPoint.Aux[0];
FN_PRRR_IK_SCD.lrAxis8 := cCoordPoint.Aux[1];
FN_PRRR_IK_SCD.lrAxis9 := cCoordPoint.Aux[2];
