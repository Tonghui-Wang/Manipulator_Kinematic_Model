FUNCTION FN_RPRR_SC10_FK : CoordPoint
VAR_INPUT
	sActAngle	: AxisAngle;	//待正解的四轴各轴弧度
	a1,a3		: LREAL;		//对应DH参数值
	//d1,d3		: LREAL;	d1+d3=1100是定值，直接将1100代入计算了
END_VAR

///////////////////////////////////////////////////////////

sActAngle.lrAxis1:=sActAngle.lrAxis1*Deg2Rad;
sActAngle.lrAxis3:=sActAngle.lrAxis3*Deg2Rad;

//TCP位姿
FN_RPRR_SC10_FK.X:=a1*COS(sActAngle.lrAxis1)-a3*COS(sActAngle.lrAxis1+sActAngle.lrAxis3);
FN_RPRR_SC10_FK.Y:=a1*SIN(sActAngle.lrAxis1)-a3*SIN(sActAngle.lrAxis1+sActAngle.lrAxis3);
FN_RPRR_SC10_FK.Z:=sActAngle.lrAxis2+1100;
FN_RPRR_SC10_FK.A:=(sActAngle.lrAxis1+sActAngle.lrAxis3)*Rad2Deg-sActAngle.lrAxis4;
FN_RPRR_SC10_FK.B:=0;
FN_RPRR_SC10_FK.C:=0;

//附加轴位姿
FN_RPRR_SC10_FK.Aux[0] := sActAngle.lrAxis7;
FN_RPRR_SC10_FK.Aux[1] := sActAngle.lrAxis8;
FN_RPRR_SC10_FK.Aux[2] := sActAngle.lrAxis9;
