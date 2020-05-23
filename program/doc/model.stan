STATIC ANALYSIS STAN MODEL
This section is free to be filled
% To remark
--------------------------------------------------------------------------
*start
--------------------------------------------------------------------------
>>> MESH <<<
nodes {
%n	x	y	z
}
elements {
%e	n1	n2	s	m   ru
}
springs {
%e	n1	n2	K
}
mesh control {
%e	in
}
--------------------------------------------------------------------------
>>> PROPERTIES <<<
sections {
%id A	Jv	Jw	Wv	Ww	Tv	Tw
}
materials {
%id E	v	a	m	YS	UTS
}
notches {
%n	Kta	Ktb	Ktt
}
--------------------------------------------------------------------------
>>> CONSTRAINTS <<<
ground constraints {
%n  Kx	Ky	Kz	Krx	Kry	Krz	th	ph
}
internal constraints {
%m	s	Kx  Ky  Kz  Krx Kry Krz
}
yielded constraints {
%n	x	y	z	rx  ry  rz
}
--------------------------------------------------------------------------
>>> LOADS <<<
nodal loads {
%n	Fx	Fy	Fz	Mx	My	Mz
}
distributed loads {
%e	Pu	Pv1	Pv2	Pw1	Pw2	Mqu in
}
thermal variations {
%e	Dt_sup_2	Dt_inf_2    Dt_sup_3	Dt_inf_3
}
gravity {
%ax ay  az
}
--------------------------------------------------------------------------
*end
-------------------------------------------------------------------------