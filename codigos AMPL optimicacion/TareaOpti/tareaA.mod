reset;

# ------------------- CONJUNTOS -------------------
set G;      # Plantas generadoras
set C;      # Ciudades
set T;      # Bloques horarios (1..24)

# ------------------- PARÁMETROS -------------------
param X;                     # Semilla (tu dígito verificador)
param Delta{C, T} >= 0;      # Demanda base
param Omega{G, T} >= 0;      # Capacidad máxima de generación
param Gamma{G} >= 0;         # Costo de generación [USD/MWh]
param Theta{G, C} >= 0;      # Costo por pérdidas de transmisión
param Phi{G, C} >= 0;        # Capacidad máxima de transmisión

# ------------------- VARIABLES -------------------
var Gen{G, T} >= 0;                  # Energía generada por planta g en hora t
var Trans{G, C, T} >= 0;             # Energía transmitida de g a ciudad c en hora t

# ------------------- FUNCIÓN OBJETIVO -------------------
minimize CostoTotal:
    sum{g in G, t in T} Gamma[g] * Gen[g,t] +
    sum{g in G, c in C, t in T} Theta[g,c] * Trans[g,c,t];

# ------------------- RESTRICCIONES -------------------

# 1. Satisfacción de demanda
subject to Demanda {c in C, t in T}:
    sum{g in G} Trans[g,c,t] = Delta[c,t] * (1 + X/100);

# 2. Capacidad de generación
subject to CapacidadGeneracion {g in G, t in T}:
    Gen[g,t] <= Omega[g,t];

# 3. Capacidad de transmisión
subject to CapacidadTransmision {g in G, c in C, t in T}:
    Trans[g,c,t] <= Phi[g,c];

# 4. Balance por planta (lo generado = lo transmitido)
subject to BalancePlanta {g in G, t in T}:
    Gen[g,t] = sum{c in C} Trans[g,c,t];
