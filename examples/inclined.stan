STATIC ANALYSIS STAN MODEL
This section is free to be filled
% To remark
--------------------------------------------------------------------------
*start
--------------------------------------------------------------------------
>>> MESH <<<
nodes {
%n	x	y	z
1 0 0 0
2 0 0 -1000
3 -500/sqrt(2) 0 -1000-500/sqrt(2)
4 1000/sqrt(2) 0 1000*(1/sqrt(2)-1)
5 0 0 -1000
}
elements {
%e	n1	n2	s	m   ru
1 1 2 1 1 0
2 3 5 1 1 0
3 5 4 1 1 0
}
--------------------------------------------------------------------------
>>> PROPERTIES <<<
sections {
%id A	Jv	Jw	Wv	Ww	Tv	Tw
1 1e2 1e4 1e4 1e3 1e3 0 0
}
materials {
%id E	v	a	m	YS	UTS
1 2e5 .3 11e-6 1 300 400
}
notches {
%n	Kta	Ktb	Ktt
}
--------------------------------------------------------------------------
>>> CONSTRAINTS <<<
ground constraints {
%n  Kx	Ky	Kz	Krx	Kry	Krz	th	ph
1 inf inf inf inf inf inf 0 0
4 0 inf inf inf 0 0 0 45
}
internal constraints {
%m	s	Kx  Ky  Kz  Krx Kry Krz
2 5 inf inf inf inf 0 inf
}
yielded constraints {
%n	x	y	z	rx  ry  rz
}
--------------------------------------------------------------------------
>>> LOADS <<<
nodal loads {
%n	Fx	Fy	Fz	Mx	My	Mz
3 20/sqrt(2) 0 -20/sqrt(2) 0 0 0
}
--------------------------------------------------------------------------
*end
-------------------------------------------------------------------------
