Prova di verifica c1
--------------------------------------------------------------------------
*start
--------------------------------------------------------------------------
>>> MESH <<<
nodes {
%n	x	y	z
1 0 0 0
2 3 0 0
3 3 -2 0
4 3 -2 0
5 3 -6 0
6 6 -6 0
}
elements {
%e	n1	n2	s	m   ru
1 1 2 1 1 0
2 2 3 1 1 0
3 4 5 1 1 0
4 5 6 1 1 0
}
--------------------------------------------------------------------------
>>> PROPERTIES <<<
sections {
%id A	Jv	Jw	Wv	Ww	Tv	Tw
1 1e10 2.772e7 2.772e7 2.52e5 2.52e5 0 0
}
materials {
%id E	v	a	m	YS	UTS
1 2.1e4 .3 11e-6 1 100 200
}
--------------------------------------------------------------------------
>>> CONSTRAINTS <<<
ground constraints {
%n  Kx	Ky	Kz	Krx	Kry	Krz	th	ph
1 inf inf inf inf inf 0 0 0
6 inf inf inf inf inf 0 0 0
}
internal constraints {
%m	s	Kx  Ky  Kz  Krx Kry Krz
3 4 inf inf inf inf inf 0
}
yielded constraints {
%n	x	y	z	rx  ry  rz
1 -0.01 0 0 0 0 0
}
--------------------------------------------------------------------------
*end
--------------------------------------------------------------------------
