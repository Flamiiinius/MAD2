set Parcels ;
set Grapes;
set Wines;

param area{p in Parcels} >=0; #area in ha of p
param revenue1{w in Wines} >=0; #revenue of 1 barrels of w
param revenue2{w in Wines} >=0; #revenue of 1 barrels of w
param revenue3{w in Wines} >=0; #revenue of 1 barrels of w
param cost{u in Grapes} >=0; #cost of plant 1 ha of u 
param yield1{u in Grapes,p in Parcels} >=0;  # how many barrels of u produced in 1 ha of p	S1
param yield2{u in Grapes,p in Parcels} >=0;  # how many barrels of u produced in 1 ha of p	S2
param yield3{u in Grapes,p in Parcels} >=0;  # how many barrels of u produced in 1 ha of p	S3
param min_comp{u in Grapes,w in Wines} >=0; #min % needed of u in w
param ppg1{u in Grapes,p in Parcels} := 500 * yield1[u,p] / cost[u]; # area planted in p of u with 500€
param ppg2{u in Grapes,p in Parcels} := 500 * yield2[u,p] / cost[u]; # area planted in p of u with 500€
param ppg3{u in Grapes,p in Parcels} := yield3[u,p] * 500 / cost[u]; # area planted in p of u with 500€

var O1{u in Grapes,p in Parcels}, binary; #if plant on that parcel, that  grape
var O2{u in Grapes,p in Parcels}, binary; #if plant on that parcel, that  grape
var O3{u in Grapes,p in Parcels}, binary; #if plant on that parcel, that  grape
var R1{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var R2{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var R3{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var N1{w in Wines} >=0; 				#Array[Wine] -> how many barrels of w for sale
var N2{w in Wines} >=0; 				#Array[Wine] -> how many barrels of w for sale
var N3{w in Wines} >=0; 				#Array[Wine] -> how many barrels of w for sale
var B1{w in Wines}, binary; # its 1 if N[w] is >=5 
var B2{w in Wines}, binary; # its 1 if N[w] is >=5 
var B3{w in Wines}, binary; # its 1 if N[w] is >=5 

#money avaiable for plant grapes in our parcels 	10k€, each O[u,p] its 500€
s.t. grapesCost1:  0<= sum{u in Grapes,p in Parcels} O1[u,p] <= 20; 
s.t. grapesCost2:  0<= sum{u in Grapes,p in Parcels} O2[u,p] <= 20; 
s.t. grapesCost3:  0<= sum{u in Grapes,p in Parcels} O3[u,p] <= 20; 

#each w need a minimun for u for its compositon
s.t. WineComp1{w in Wines,u in Grapes}: min_comp[u,w]*N1[w]  <= R1[w,u] * 100;
s.t. WineComp2{w in Wines,u in Grapes}: min_comp[u,w]*N2[w]  <= R2[w,u] * 100;
s.t. WineComp3{w in Wines,u in Grapes}: min_comp[u,w]*N3[w]  <= R3[w,u] * 100;

#each wine need 100% in its composition
s.t. WineMAX1{w in Wines}: sum{u in Grapes} R1[w,u] == N1[w];
s.t. WineMAX2{w in Wines}: sum{u in Grapes} R2[w,u] == N2[w];
s.t. WineMAX3{w in Wines}: sum{u in Grapes} R3[w,u] == N3[w];

#for each p the sum of all ha with grapes <= area p
s.t. SumParAr1{p in Parcels}: 0 <= sum{u in Grapes} O1[u,p]*ppg1[u,p] <= area[p];
s.t. SumParAr2{p in Parcels}: 0 <= sum{u in Grapes} O2[u,p]*ppg2[u,p] <= area[p];
s.t. SumParAr3{p in Parcels}: 0 <= sum{u in Grapes} O3[u,p]*ppg3[u,p] <= area[p];

#number of barrels of u used in wines <= number of barreds of u produced
s.t. GrapesBarrels1{u in Grapes}: sum{w in Wines} R1[w,u] <= sum{p in Parcels} O1[u,p]*ppg1[u,p];
s.t. GrapesBarrels2{u in Grapes}: sum{w in Wines} R2[w,u] <= sum{p in Parcels} O2[u,p]*ppg2[u,p];
s.t. GrapesBarrels3{u in Grapes}: sum{w in Wines} R3[w,u] <= sum{p in Parcels} O3[u,p]*ppg3[u,p];

#at least three brands the quantity produced must not be smaller that 5 barrels
s.t. Barrale3a: sum{w in Wines} B1[w] >=3;
s.t. Barrale3b: sum{w in Wines} B2[w] >=3;
s.t. Barrale3c: sum{w in Wines} B3[w] >=3;
s.t. Barrels5a{w in Wines}: N1[w] >=5 * B1[w];
s.t. Barrels5b{w in Wines}: N2[w] >=5 * B2[w];
s.t. Barrels5c{w in Wines}: N3[w] >=5 * B3[w];

maximize Z: (sum{w in Wines} revenue1[w]*N1[w] + sum{w in Wines}  revenue2[w]*N2[w] + sum{w in Wines}  revenue3[w]*N3[w])/3;

solve;
end;
