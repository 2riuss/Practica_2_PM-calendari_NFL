param n >= 4;
	check: n mod 2 = 0;
param r >= 0;
param s >= 0;

set Divisio_nord ordered = setof {i in 1..n/2} 'Equip_' & i;
set Divisio_sud ordered = setof {j in n/2+1..n} 'Equip_' & j;
	check: Divisio_nord inter Divisio_sud within {};
set Equips ordered = Divisio_nord union Divisio_sud;
set Jornades ordered = setof {k in 1..r*(n/2-1)+s*n/2} 'Jornada_' & k;
set Dos_equips = {i in Equips, j in Equips: ord(i) < ord(j)};
set Posibles_partits = {Jornades, Dos_equips};

param funcio_objectiu{(k,i,j) in Posibles_partits} = 
	if ord(k,Jornades) >= 2 and ({i,j} within Divisio_nord or {i,j} within Divisio_sud) then 2^(ord(k,Jornades)-2)
	else 0;

var Calendari{Posibles_partits} binary;

# Funció objetiu
maximize total:
		sum {(k,i,j) in Posibles_partits} (funcio_objectiu[k,i,j]*Calendari[k,i,j]);

# Restriccions
subject to partits_jugats_equipi_equipj {(i,j) in Dos_equips}:
	sum {k in Jornades} Calendari[k,i,j] = 
		if {i,j} within Divisio_nord or {i,j} within Divisio_sud then r
		else s;

subject to un_partit_per_jornada {t in Equips, k in Jornades}:
	(sum {(i,t) in Dos_equips} Calendari[k,i,t]) + (sum {(t,j) in Dos_equips} Calendari[k,t,j]) = 1