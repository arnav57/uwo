function H_OL = Francis_model(G_F,delta,Q_dot)

global Vdot_A_bar beta V_L C_bar

clear Hrespir Hreflex H_OL

% Transfer function for respiration system
G_respir = -1*C_bar/(Vdot_A_bar + beta*Q_dot);
tau_respir = V_L/(Vdot_A_bar + beta*Q_dot);
Hrespir = tf(G_respir,[tau_respir 1]);

% Transfer function for chemoreceptors and chemoreflexes
Hreflex = tf(-1*G_F,1,'InputDelay',delta);

% Open-loop transfer function
H_OL = Hrespir*Hreflex;
