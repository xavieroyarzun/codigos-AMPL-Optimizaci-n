# =============================================
# MODELO AVANZADO - PARTE B
# =============================================

set G;
set C;
set T := 1..24;

# Parámetros
param X;
param Delta{C, T} >= 0;
param Omega2{G, T} >= 0;
param Gamma{G} >= 0;
param Theta{G, C} >= 0;
param Phi{G, C} >= 0;

param Alpha{G} >= 0;  #Umbral m´ınimo de generaci´on (Solar: 0, E´olica: 0, T´ermica: 150)
param Beta{G} >= 0;   #Costo de encendido (Solar: 10, E´olica: 10, T´ermica: 800)
param Epsilon{C} >= 0;#Capacidad de bater´ıas (Santiago: 1000, Concepci´on: 600)
param Zeta{C} >= 0;   #Costo de almacenamiento

# Variables
var Gen{G, T} >= 0;      # Energía generada por planta g en hora t
var Trans{G, C, T} >= 0; # Energía transmitida de g a ciudad c en hora t
var Ealm{C, T} >= 0;     # Energ´ıa almacenada en bater´ıas al final de t
var On{G, T} binary;     # Estado de encendido de la planta g en periodo t
var Startup{G, T} binary;# Indicador de encendido en el periodo t

# Función objetivo
minimize CostoTotal:
    sum{g in G, t in T} Gamma[g] * Gen[g,t]
  + sum{g in G, c in C, t in T} Theta[g,c] * Trans[g,c,t]
  + sum{c in C, t in T} Zeta[c] * Ealm[c,t]
  + sum{g in G, t in T} Beta[g] * Startup[g,t];

# Restricciones

subject to CapacidadGen {g in G, t in T}:
    Gen[g,t] <= Omega2[g,t] * On[g,t];

subject to UmbralMinimo {g in G, t in T}:
    Gen[g,t] >= Alpha[g] * On[g,t];

subject to BalancePlanta {g in G, t in T}:
    Gen[g,t] = sum{c in C} Trans[g,c,t];

subject to CapTrans {g in G, c in C, t in T}:
    Trans[g,c,t] <= Phi[g,c];

subject to CapBaterias {c in C, t in T}:
    Ealm[c,t] <= Epsilon[c];

subject to BateriaInicial {c in C}:
    Ealm[c,1] = 0;

subject to TiempoMinimo {g in G, t in T: t <= 22}:
    sum{k in t..t+2} On[g,k] >= 3 * Startup[g,t];

subject to NoEncenderFinal {g in G, t in {23,24}}:
    Startup[g,t] = 0;

subject to BalanceDemandaInicial {c in C}:
    sum {g in G} Trans[g,c,1] = Delta[c,1] * (1 + X/100);
    
subject to BalanceDemanda {c in C, t in 2..24}:
    sum {g in G} Trans[g,c,t] + Ealm[c,t-1] - Ealm[c,t]= Delta[c,t] * (1 + X/100);
    
    
subject to StartupInicial {g in G}:
    Startup[g,1] >= On[g,1];

subject to DefinirStartup {g in G, t in 2..24}:
    Startup[g,t] >= On[g,t] - On[g,t-1];   
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    