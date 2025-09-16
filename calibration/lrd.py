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
Lux = [80,96,120,146,172,200,240,280,370,400,480,600,800,10]
R = [4249,3362,2970,2659,2028,1590,1248,1185,1016,976,1199,915,622,20000]

Lux_log=[]
R_log=[]
for i in range(0,len(Lux)):
    Lux_log.append(math.log(Lux[i]))
    R_log.append(math.log(R[i]))

a = covariance(Lux_log,R_log)/variance(Lux_log)
b = moyenne(R_log)-a*moyenne(Lux_log)
print("a = ",a)
print("b = ",b)


X = [i for i in range(1,1000)]
Y_1 = []
Y_2=[]
for i in range(0,len(X)):
    Y_1.append(math.exp(b)*X[i]**a)
    Y_2.append(20*10e3*(X[i])**-0.7)

plt.figure()
plt.scatter(Lux,R,color = 'mediumblue',marker = '+',label = "Emprischen Messwerten")
plt.plot(X,Y_1,color='cornflowerblue',label = "Modellfunktion")
plt.plot(X,Y_2,color='deepskyblue',label = "Daten des Konstrukteur")
plt.xlabel("Helligkeit (Lux)")
plt.ylabel("Widerstand ($\Omega$)")
plt.title("Eichung des Fotowiderstands ")
plt.legend(loc = 'upper right')
plt.grid()
plt.show()
