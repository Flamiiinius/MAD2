set Parcels ;
set Grapes;
set Wines;

param area{p in Parcels} >=0; #area in ha of p
param cost{u in Grapes} >=0; #cost of plant 1 ha of u 
param min_comp{u in Grapes,w in Wines} >=0; #min % needed of u in w
param revenue1{w in Wines} >=0; #revenue of 1 barrels of w
param revenue2{w in Wines} >=0; #revenue of 1 barrels of w
param revenue3{w in Wines} >=0; #revenue of 1 barrels of w
param yield1{u in Grapes,p in Parcels} >=0;  # how many barrels of u produced in 1 ha of p	S1
param yield2{u in Grapes,p in Parcels} >=0;  # how many barrels of u produced in 1 ha of p	S2
param yield3{u in Grapes,p in Parcels} >=0;  # how many barrels of u produced in 1 ha of p	S3

var Q{u in Grapes,p in Parcels}>=0; #Matrix[parcel,grape] -> how many ha of u planted on p
var O{u in Grapes,p in Parcels}, binary; #if plant on that parcel, that  grape
var R{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var N{w in Wines} >=0; 				#Array[Wine] -> how many barrels of w for sale
var B{w in Wines}, binary; # its 1 if N[w] is >=5 

#money avaiable for plant grapes in our parcels 
s.t. grapesCost: sum{u in Grapes,p in Parcels} (O[u,p]*500 + Q[u,p]*cost[u] ) <= 10000; 

#each w need a minimun for u for its compositon
s.t. WineComp{w in Wines,u in Grapes}: min_comp[u,w]*N[w]  <= R[w,u] * 100;

#each wine need 100% in its composition
s.t. WineMAX{w in Wines}: sum{u in Grapes} R[w,u] == N[w];

#for each p the sum of all ha with grapes <= area p
s.t. SumParAr1{p in Parcels}: 0 <= sum{u in Grapes} Q[u,p] <= area[p];

#number of barrels of u used in wines <= number of barreds of u produced
s.t. GrapesBarrels1{u in Grapes}: sum{w in Wines} R[w,u] <= sum{p in Parcels} Q[u,p] * yield1[u,p];
s.t. GrapesBarrels2{u in Grapes}: sum{w in Wines} R[w,u] <= sum{p in Parcels} Q[u,p] * yield2[u,p];
s.t. GrapesBarrels3{u in Grapes}: sum{w in Wines} R[w,u] <= sum{p in Parcels} Q[u,p] * yield3[u,p];

#at least three brands the quantity produced must not be smaller that 5 barrels
s.t. Barrale3: sum{w in Wines} B[w] >=3;
s.t. Barrels5{w in Wines}: N[w] >=5 * B[w];

#if Q[u,p] planted then additional cost of 500�
s.t. ExtraBucks{u in Grapes,p in Parcels}: Q[u,p] <=O[u,p]*10000/cost[u]; #Not sure about this M

maximize Z: sum{w in Wines} (revenue1[w]+revenue2[w]+revenue3[w])*N[w]/3;

end;
