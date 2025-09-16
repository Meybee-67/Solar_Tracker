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
R = [1376,1256,1200,1188,1120,1058,5810,18000,27600,43500,92100,322,3460,1451.4]
U = [5.95,6.08,6.14,6.18,6.25,6.41,4.62,3.47,2.94,2.26,1.58,4.94,4.8,5.8]

Lux = []
for i in range(0,len(R)):
    Lux.append((R[i]/math.exp(11.72))**(1/-0.79))


Lux_log=[]
U_log=[]
for i in range(0,len(Lux)):
    Lux_log.append(math.log(Lux[i]))
    U_log.append(math.log(U[i]))

a = covariance(Lux_log,U_log)/variance(Lux_log)
b = moyenne(U_log)-a*moyenne(Lux_log)
print("a = ",a)
print("b = ",b)


X = [i for i in range(1,1000)]
Y_1 = []
for i in range(0,len(X)):
    Y_1.append(math.exp(b)*X[i]**a)

#Tracé courbe
plt.figure()
plt.scatter(Lux,U,color = 'blue',marker = '+',label = "Points expérimentaux")
plt.plot(X,Y_1,color='skyblue',label = "Courbe de tendance")
plt.xlabel("Luminosité en Lux")
plt.ylabel("Tension en V")
plt.xlim(-1,500)
plt.ylim(-1,9)
plt.legend(loc = 'upper right')
plt.grid()
plt.show()