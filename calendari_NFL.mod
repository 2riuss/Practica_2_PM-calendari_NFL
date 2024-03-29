param n >= 4;
	check: n mod 2 = 0;
param r >= 0;
param s >= 0;

set Divisio_nord ordered = setof {i in 1..n/2} 'Equip_' & i;
set Divisio_sud ordered = setof {j in n/2+1..n} 'Equip_' & j;
	check: Divisio_nord inter Divisio_sud within {};
set Equips ordered = Divisio_nord union Divisio_sud;
set Jornades ordered = setof {k in 1..r*(n/2-1)+s*n/2} 'Jornada_' & k;
set Partits = {i in Equips, j in Equips: ord(i) < ord(j)};
set Partits_Jornades = {Partits, Jornades};

param preferencia{(i,j,k) in Partits_Jornades} = 
	if ord(k,Jornades) >= 2 and ({i,j} within Divisio_nord or {i,j} within Divisio_sud) then 2^(ord(k,Jornades)-2)
	else 0;

var Calendari_Optim{Partits_Jornades} binary;

# Funcio objetiu
maximize funcio_objectiu:
		sum {(i,j,k) in Partits_Jornades} (preferencia[i,j,k]*Calendari_Optim[i,j,k]);

# Restriccions
subject to partits_jugats_equipi_equipj {(i,j) in Partits}:
	sum {k in Jornades} Calendari_Optim[i,j,k] = 
		if {i,j} within Divisio_nord or {i,j} within Divisio_sud then r
		else s;

subject to un_partit_per_jornada {t in Equips, k in Jornades}:
	(sum {(i,t) in Partits} Calendari_Optim[i,t,k]) + (sum {(t,j) in Partits} Calendari_Optim[t,j,k]) = 1