FUNCTION FN_PRRR_FK_SCD : CoordPoint
VAR_INPUT
	sActAngle	: AxisAngle;	//待正解的四轴各轴弧度
	a2,a3,a4 	: LREAL;		//DH参数值-a
	d1,d4		: LREAL;		//DH参数值-d
END_VAR
VAR
	s2,c2,c23,s23 : LREAL;
END_VAR


///////////////////////////////////////////////////////////

sActAngle.lrAxis2 := sActAngle.lrAxis2*Deg2Rad;
sActAngle.lrAxis3 := sActAngle.lrAxis3*Deg2Rad;
sActAngle.lrAxis4 := sActAngle.lrAxis4*Deg2Rad;

//展开计算---减小计算量
s2 := SIN(sActAngle.lrAxis2);
c2 := COS(sActAngle.lrAxis2);
s23 := SIN(sActAngle.lrAxis2+sActAngle.lrAxis3);
c23 := COS(sActAngle.lrAxis2+sActAngle.lrAxis3);

FN_PRRR_FK_SCD.X := a2 + a3*c2 - a4*c23;
FN_PRRR_FK_SCD.Y := a3*s2 + a4*s23;
FN_PRRR_FK_SCD.Z := sActAngle.lrAxis1 + d1 - d4;
FN_PRRR_FK_SCD.A := (sActAngle.lrAxis2+sActAngle.lrAxis3-sActAngle.lrAxis4)*rad2deg;
FN_PRRR_FK_SCD.B := 0;
FN_PRRR_FK_SCD.C := 0;
FN_PRRR_FK_SCD.Aux[0] := sActAngle.lrAxis7;
FN_PRRR_FK_SCD.Aux[1] := sActAngle.lrAxis8;
FN_PRRR_FK_SCD.Aux[2] := sActAngle.lrAxis9;
