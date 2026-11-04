Beam with internal pin
--------------------------------------------------------------------------
*start
--------------------------------------------------------------------------
>>> MESH <<<
nodes {
%n	x	y	z
1 	0	0	0
2 	.5	0	0 %master
3	1	0 	0
4 	.5	0	0 %slave
}
elements {
%e	n1	n2	s	m   ru
1 	1	2	1	1 	0
2 	4	3	1	1 	0
}
--------------------------------------------------------------------------
>>> PROPERTIES <<<
sections {
%id A	Jv	Jw	Wv	Ww	Tv	Tw
1 pi*50^2/4 pi*50^4/64 pi*50^4/64 pi*50^3/32 pi*50^3/32 0 0
}
materials {
%id E	v	a	m	YS	UTS
1 2e5 .3 11e-6 1 100 200
}
--------------------------------------------------------------------------
>>> CONSTRAINTS <<<
ground constraints {
%n  Kx	Ky	Kz	Krx	Kry	Krz	th	ph
1 inf inf inf inf inf inf 0 0
3 inf inf inf inf inf inf 0 0
}
internal constraints {
%m	s	Kx  Ky  Kz  Krx Kry Krz
2  4 inf inf inf inf 0    inf
}
--------------------------------------------------------------------------
>>> LOADS <<<
nodal loads {
%n	Fx	Fy	Fz	Mx	My	Mz
2 0 0 1 0 0 0
}
--------------------------------------------------------------------------
*end
--------------------------------------------------------------------------