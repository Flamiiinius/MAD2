from pyscipopt import Model, quicksum

#Initialize model
model = Model("Wine blending")

#SET's
#Wines
#Grapes
#Parcels

#Parameters
#cost
#revenue1,2,3
#yield1,2,3
#area

Inventory = {"Alfrocheiro":60, "Baga":60, "Castelao":30}
Grapes = Inventory.keys()

Profit = {"Dry":15, "Medium":18, "Sweet":30}
Wines = Profit.keys()

Use = {
    ("Alfrocheiro","Dry"):2,
    ("Alfrocheiro","Medium"):1,
    ("Alfrocheiro","Sweet"):1,
    ("Baga","Dry"):1,
    ("Baga","Medium"):2,
    ("Baga","Sweet"):1,
    ("Castelao","Dry"):0,
    ("Castelao","Medium"):0,
    ("Castelao","Sweet"):1
    }

# Create variables
x = {}
for j in Wines:
    x[j] = model.addVar(vtype="C", name="x(%s)"%j)

# Create constraints
c = {}
for i in Grapes:
    c[i] = model.addCons(quicksum(Use[i,j]*x[j] for j in Wines) <= Inventory[i], name="Use(%s)"%i)

# Objective
model.setObjective(quicksum(Profit[j]*x[j] for j in Wines), "maximize")

model.optimize()

if model.getStatus() == "optimal":
    print("Optimal value:", model.getObjVal())

    for j in x:
        print(x[j].name, "=", model.getVal(x[j]))
    for i in c:
        print("dual of", c[i].name, ":", model.getDualsolLinear(c[i]))
else:
    print("Problem could not be solved to optimality")
