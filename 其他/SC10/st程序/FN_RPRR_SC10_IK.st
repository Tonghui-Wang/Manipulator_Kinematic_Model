FUNCTION FN_RPRR_SC10_IK : AxisAngle
VAR_INPUT
	cCoordPoint		: CoordPoint;	//当前空间位置姿态
	InCurAxisAngle	: AxisAngle;	//上一次关节角度
	a1,a3		: LREAL;		//DH参数
	//d1,d3		: LREAL;		d1+d3=1100是定值，直接将1100代入计算了
END_VAR
VAR
	tmp:LREAL:=0;
	stmp,ctmp:LREAL:=0;
END_VAR

//////////////////////////////////////////////////////////////////////

cCoordPoint.A:=cCoordPoint.A*deg2rad;
tmp:=SQRT(EXPT(cCoordPoint.X, 2) + EXPT(cCoordPoint.Y, 2));

//求轴1
ctmp:=(EXPT(a1,2)+EXPT(tmp,2)-EXPT(a3,2))/(2*a1*tmp);
stmp:=SQRT(1-EXPT(ctmp,2));
FN_RPRR_SC10_IK.lrAxis1:=NW_atan2(stmp, ctmp)+NW_atan2(cCoordPoint.Y, cCoordPoint.X);

//求轴2
FN_RPRR_SC10_IK.lrAxis2:=cCoordPoint.Z-1100;

//求轴3
ctmp:=(EXPT(a1,2)+EXPT(a3,2)-EXPT(tmp,2))/(2*a1*a3);
stmp:=SQRT(1-EXPT(ctmp,2));
FN_RPRR_SC10_IK.lrAxis3:=NW_atan2(stmp, ctmp);

//转向判断
IF FN_RPRR_SC10_IK.lrAxis3*InCurAxisAngle.lrAxis3<0 THEN	//仅用于判断符号，不用换算单位
	FN_RPRR_SC10_IK.lrAxis3:=-FN_RPRR_SC10_IK.lrAxis3;
	FN_RPRR_SC10_IK.lrAxis1:=FN_RPRR_SC10_IK.lrAxis3-2*NW_atan2(stmp, ctmp);
END_IF

//求轴4
FN_RPRR_SC10_IK.lrAxis4:=FN_RPRR_SC10_IK.lrAxis1+FN_RPRR_SC10_IK.lrAxis3-cCoordPoint.A;
FN_RPRR_SC10_IK.lrAxis4:=NW_atan2(SIN(FN_RPRR_SC10_IK.lrAxis4), COS(FN_RPRR_SC10_IK.lrAxis4));
IF (FN_RPRR_SC10_IK.lrAxis4 - InCurAxisAngle.lrAxis4*Deg2Rad) > PI THEN
	FN_RPRR_SC10_IK.lrAxis4:=FN_RPRR_SC10_IK.lrAxis4 - PI2;
ELSIF (FN_RPRR_SC10_IK.lrAxis4 - InCurAxisAngle.lrAxis4*Deg2Rad) < -PI THEN
	FN_RPRR_SC10_IK.lrAxis4:=FN_RPRR_SC10_IK.lrAxis4 + PI2;
END_IF

//机器人本体各轴位移
FN_RPRR_SC10_IK.lrAxis1:=FN_RPRR_SC10_IK.lrAxis1*Rad2Deg;
//FN_RPRR_SC10_IK.lrAxis2:=FN_RPRR_SC10_IK.lrAxis2;
FN_RPRR_SC10_IK.lrAxis3:=FN_RPRR_SC10_IK.lrAxis3*Rad2Deg;
FN_RPRR_SC10_IK.lrAxis4:=FN_RPRR_SC10_IK.lrAxis4*Rad2Deg;
FN_RPRR_SC10_IK.lrAxis5:=0;
FN_RPRR_SC10_IK.lrAxis6:=0;

//附加轴各轴位移
FN_RPRR_SC10_IK.lrAxis7 := cCoordPoint.Aux[0];
FN_RPRR_SC10_IK.lrAxis8 := cCoordPoint.Aux[1];
FN_RPRR_SC10_IK.lrAxis9 := cCoordPoint.Aux[2];
