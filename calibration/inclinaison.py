import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import math

#Methode des moindres carres

#Moyenne
def moyenne(L:list):
    somme = 0
    for i in range(0,len(L)):
        somme += L[i]
    return(somme/len(L))

#Variance
def variance(L:list):
    v = 0
    for i in range(0,len(L)):
        v += ((L[i]-moyenne(L))**2)/len(L)
    return(v)

#Covariance
def covariance(L1:list, L2:list):
    if len(L1)!=len(L2):
        print("Impossible")
    else:
        C = 0
        for i in range(0,len(L1)):
            C+=(L1[i]-moyenne(L1))*(L2[i]-moyenne(L2))
        return(C/len(L1))

# Etalonnage capteur

#1. Mesures expérimentales
Ic = [0,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85]
U = [5.5,5.58,5.6,5.63,5.65,5.68,5.7,5.73,5.76,5.78,5.8,5.82,5.84,5.85,5.87,5.88,5.88]

a = covariance(Ic,U)/variance(Ic)
b = moyenne(U)-a*moyenne(Ic)
print("a = ",a)
print("b = ",b)

X = [i for i in range(1,100)]
Y_1 = []
for i in range(0,len(X)):
    Y_1.append(X[i]*a+b)

#Tracé courbe
plt.figure()
plt.scatter(Ic,U,color = 'blue',marker = '+',label = "Points expérimentaux")
plt.plot(X,Y_1,color='skyblue',label = "Courbe de tendance")
plt.xlabel("Luminosité en Lux")
plt.ylabel("Tension en V")
plt.ylim(0,9)
plt.legend(loc = 'upper right')
plt.grid()
plt.show()