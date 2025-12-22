function H_OL = Khoo_model(T_p,T_c,Q_b)

clear Hrespir Hreflex H_OL

% Parameter values from Khoo textbook.
beta = 863*0.0065;  % CO2 solubility in blood, dimensionless.
V_L = 2.5;  % End-expiratory lung volume in L.
PaCO2 = 40; % Steady-state arterial CO2 partial pressure in mmHg.
PICO2 = 0;  % Partial pressure of CO2 in inspired air, in mmHg.
Q_E = 0.12; % Steady-state total ventilation in L/s.
Q_D = 0.03; % Dead-space ventilation in L/s.
G_p = 0.02; % Peripheral chemorelfex gain in (L/s)/mmHg.
G_c = 0.04;  % Central chemoreflex gain in (L/s)/mmHg.
tau_p = 20; % Peripheral chemoreflex time constant in seconds.
tau_c = 120;    % Central chemorecptor time constant in seconds.

% Respiration system
G_L = (PICO2 - PaCO2)/(Q_E - Q_D + beta*Q_b);
tau_L = V_L/(Q_E - Q_D + beta*Q_b);
Hrespir = tf(G_L,[tau_L 1]);

% Peripheral chemoreceptors and chemoreflexes
Hperipheral = tf(-1*G_p,[tau_p 1],'InputDelay',T_p);

% Central chemoreceptors and chemoreflexes
Hcentral = tf(-1*G_c,[tau_c 1],'InputDelay',T_c);

% Open-loop system
H_OL = Hrespir*(Hperipheral + Hcentral);
