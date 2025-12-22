function test_Francis_margins(G_F,delta)

global Vdot_A_bar beta V_L C_bar

% Lower and upper frequency bounds for stability analysis, in cycles/min:
f_min = 60*0.001;
f_max = 60*10;

a_min = log10(f_min);
a_max = log10(f_max);
w = (2*pi).*logspace(a_min,a_max,1e5);

% Other patient parameters from Francis et al. pp. 2216 and 2218 except where noted.

% Steady-state alveolar ventilation in L/min.  Measured but not reported by Francis,
% so calculated from Q_E and Q_D values in Khoo textbook.
Vdot_A_bar = 60*(0.12 - 0.09);

beta = 0.05*100;    % CO2 solubiity in blood, dimensionless.
V_L = 3.5;          % End-expiratory lung volume in L.
C_bar = 0.048;      % Steady-state alveolar CO2 mole fraction, dimensionless.
Q_dot = 0.06*82;    % Cardiac output in L/min computed assuming 82 kg body moass.

% Compute open-loop transfer function for each subject and use it to evaluate
% gain margin and time-delay margin.
H_OL = Francis_model(G_F,delta,Q_dot);        
Hw = squeeze(freqresp(H_OL,w));
GM = evaluate_gain_margin(Hw)
TDM = evaluate_delay_margin(Hw,w)   % Units = minutes

% Create Nyquist plot with red circle at critical point.
figure
plot(real(Hw),imag(Hw),'b')
hold on
plot(-1,0,'ro')
axis([-1.5 1.5 -1.5 1.5])
axis square
grid on

% Create Bode magnitude plot in linear units (i.e., not dB). 
figure
subplot(211),semilogx(w./60,abs(Hw),'b')
axis([min(w)/60 max(w)/60 0 1.1*max(abs(Hw))])
grid on
xlabel('w [rad/s]')
ylabel('|H(w)|')

% Create unwrapped Bode phase plot in degrees. 
phase_deg_unwrap = (360/(2*pi)).*unwrap(angle(Hw));
subplot(212),semilogx(w./60,phase_deg_unwrap,'b')
axis([min(w)/60 max(w)/60 -1000 0])
grid on
xlabel('w [rad/s]')
ylabel('<H(w) [deg]')
