function [Vg,Vm,t] = biphasic_exp_tuned_dur(tau_m,Cg,del_E,R_meas,dur1,dur2,show)
% Specify tau_m, dur1, and dur2 in ms.
% Specify Cg in microfarads.

% Convert to seconds
tau_m = tau_m/1000; dur1 = dur1/1000; dur2 = dur2/1000;
% Convert to farads
Cg = Cg/1e6;

RL = 1.5;
Re = R_meas - RL;
Ri = 5000;
Cm = tau_m/Ri;
tau_g = R_meas*Cg;
if del_E > 40
    del_E = 40;
    warning('Delivered energy exceeds maximum value and was reset to 40 J.')
end

% dur1 and dur2 must be integer multiples of 10 microseconds.
temp1 = round(dur1/1e-5);
dur1 = temp1*1e-5;
temp1 = round(dur2/1e-5);
dur2 = temp1*1e-5;

% Define stimulus waveform 
temp1 = exp(-1*(dur1+dur2)/tau_g);
target_strength = sqrt(2*del_E/(Cg*(1 - temp1^2)));
if target_strength > 855
    target_strength = 855;
    warning('Target strength exceeds maximum value and was reset to 855 V.')
end
target_strength2 = target_strength*exp(-dur1/tau_g);

t = 0:1e-5:(1.5*(dur1+dur2));
Vg = zeros(1,length(t));
t1 = 0:1e-5:dur1;
Vg(1:length(t1)) = target_strength*exp(-t1./tau_g);
t2 = (dur1 + 1e-5):1e-5:(dur1+dur2);
Vg(length(t1)+1:length(t1)+length(t2)) = (-1*target_strength2).*exp(-1*(t2-dur1)./tau_g);

% Define transfer functions:
% Zcell is input impedance of cell.
% Heq1 is transfer function relating input Vg to output Ig.
% Heq2 is transfer function relating input Ig to output Im.
Zcell = tf([Re*Ri Re/Cm],[(Ri+Re) 1/Cm]);
Heq1 = 1/(RL + Zcell);
Heq2 = tf([Re 0],[(Ri+Re) 1/Cm]);

% Compute membrane voltage response
Ig = lsim(Heq1,Vg,t);
Im = lsim(Heq2,Ig,t);
Vm = (1/Cm)*cumtrapz(t,Im);

if target_strength == 855
    Vs = Vg(1);
    Vf = Vg(length(t1)+length(t2));
    warning('Actual delivered energy, in J:')
    del_E = 0.5*Cg*(Vs^2 - Vf^2)
end

t = 1000.*t;    % Convert to ms

if show == 'y'
    figure
    plot(t,Vg,'r',t,Vm,'b')
    grid on
    xlabel('t [ms]')
    ylabel('Vg(t) [V] and Vm(t) [a.u.]')
end
