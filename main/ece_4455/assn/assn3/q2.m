%%%%% use BPV_sim for COPD patient
%   k = 0.38
%   f_resp = 12 per min
% params from slide 6 are below
%   p_insp = 15 cm water
%   PEEP = 3 cm water
%   R_valve = 10 cm water s per L
%   C = 0.1 L per cm water
%   Healthy Subject:
%       R_i = R_e = 5 cm water s per L
%   COPD Subject:
%       R_i = R_e = 20 cm water s per L
%   Q_sat = 2 L per s
%   Large Leak R_leak = 110 cm water s per L

k_val = 0.38;
f_resp_val = 12/60; % 12 breaths per min = 0.2 breaths per sec
R_i = 20;
R_leak = 110;
alarm = 0;

[t, QV, PA, Vol] =  BPV_sim(k_val, f_resp_val, R_i, R_leak, alarm);

% plot Q_vent over t
figure;
plot(t, QV);
xlabel('Time [s]')
ylabel('Ventilator Output Flow [L/s]')
title('Ventilator Output Flow vs Time')
grid on;

% plot alv pressure over t
figure;
plot(t, PA);
xlabel('Time [s]')
ylabel('Alveolar Pressure [cm-water]')
title('Alveolar Pressure vs Time')
grid on;

% plot alv volume over t
figure;
plot(t, Vol);
xlabel('Time (s)');
ylabel('Volume (L)');
title('Alveolar Volume vs Time for COPD Patient');
grid on;