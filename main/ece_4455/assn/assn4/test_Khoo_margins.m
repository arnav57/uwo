function test_Khoo_margins(T_p,T_c,Q_b)

% Lower and upper frequency bounds for stability analysis, in Hz:
f_min = 0.001;
f_max = 10;

a_min = log10(f_min);
a_max = log10(f_max);
w = (2*pi).*logspace(a_min,a_max,1e5);

% Compute open-loop transfer function for each subject and use it to evaluate
% gain margin and time-delay margin.
H_OL = Khoo_model(T_p,T_c,Q_b);        
Hw = squeeze(freqresp(H_OL,w));
GM = evaluate_gain_margin(Hw)
TDM = evaluate_delay_margin(Hw,w)   % Units = seconds

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
subplot(211),semilogx(w,abs(Hw),'b')
axis([min(w) max(w) 0 1.1*max(abs(Hw))])
grid on
xlabel('w [rad/s]')
ylabel('|H(w)|')

% Create unwrapped Bode phase plot in degrees. 
phase_deg_unwrap = (360/(2*pi)).*unwrap(angle(Hw));
subplot(212),semilogx(w,phase_deg_unwrap,'b')
axis([min(w) max(w) -1000 0])
grid on
xlabel('w [rad/s]')
ylabel('<H(w) [deg]')
