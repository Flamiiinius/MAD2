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
var R1{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var R2{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var R3{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var N1{w in Wines} >=0; 				#Array[Wine] -> how many barrels of w for sale
var B1{w in Wines}, binary; # its 1 if N[w] is >=5 var R1{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var N2{w in Wines} >=0; 				#Array[Wine] -> how many barrels of w for sale
var B2{w in Wines}, binary; # its 1 if N[w] is >=5 var R1{w in Wines,u in Grapes}>=0; 	#Matrix[wine,grape] ->  number of barrels of u in W
var N3{w in Wines} >=0; 				#Array[Wine] -> how many barrels of w for sale
var B3{w in Wines}, binary; # its 1 if N[w] is >=5;
var S1 >=0; #profit for each scenario
var S2 >=0;
var S3 >=0;

#money avaiable for plant grapes in our parcels 
s.t. grapesCost: sum{u in Grapes,p in Parcels} (O[u,p]*500 + Q[u,p]*cost[u] ) <= 10000; 

#if Q[u,p] planted then additional cost of 500
s.t. ExtraBucks{u in Grapes,p in Parcels}: Q[u,p] <=O[u,p]*10000/cost[u]; #M could be more reduce

#for each p the sum of all ha with grapes <= area p
s.t. SumParAr1{p in Parcels}: 0 <= sum{u in Grapes} Q[u,p] <= area[p];

#each w need a minimun for u for its compositon
s.t. WineComp1{w in Wines,u in Grapes}: min_comp[u,w]*N1[w]  <= R1[w,u] * 100;
s.t. WineComp2{w in Wines,u in Grapes}: min_comp[u,w]*N2[w]  <= R2[w,u] * 100;
s.t. WineComp3{w in Wines,u in Grapes}: min_comp[u,w]*N3[w]  <= R3[w,u] * 100;

#each wine need 100% in its composition
s.t. WineMAX1{w in Wines}: sum{u in Grapes} R1[w,u] == N1[w];
s.t. WineMAX2{w in Wines}: sum{u in Grapes} R2[w,u] == N2[w];
s.t. WineMAX3{w in Wines}: sum{u in Grapes} R3[w,u] == N3[w];

#number of barrels of u used in wines <= number of barreds of u produced
s.t. GrapesBarrels1{u in Grapes}: sum{w in Wines} R1[w,u] <= sum{p in Parcels} Q[u,p] * yield1[u,p];
s.t. GrapesBarrels2{u in Grapes}: sum{w in Wines} R2[w,u] <= sum{p in Parcels} Q[u,p] * yield2[u,p];
s.t. GrapesBarrels3{u in Grapes}: sum{w in Wines} R3[w,u] <= sum{p in Parcels} Q[u,p] * yield3[u,p];

#at least three brands the quantity produced must not be smaller that 5 barrels
s.t. Barrale3_1: sum{w in Wines} B1[w] >=3;
s.t. Barrels5_1{w in Wines}: N1[w] >=5 * B1[w];

s.t. Barrale3_2: sum{w in Wines} B2[w] >=3;
s.t. Barrels5_2{w in Wines}: N2[w] >=5 * B2[w];
s.t. Barrale3_3: sum{w in Wines} B3[w] >=3;
s.t. Barrels5_3{w in Wines}: N3[w] >=5 * B3[w];

#profit for each scenario
s.t. Profit1: S1==sum{w in Wines} N1[w]*revenue1[w];
s.t. Profit2: S2==sum{w in Wines} N2[w]*revenue2[w];
s.t. Profit3: S3==sum{w in Wines} N3[w]*revenue2[w];

maximize Z: (S1+S2+S3)*1/3; # Prob not good

end;
