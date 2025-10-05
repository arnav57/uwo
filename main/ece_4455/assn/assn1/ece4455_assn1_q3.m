clear all;

%% load in previously found C-g tau-g
C_g   = 113.397; % uF
tau_g = 9.5254;  % ms

%% load in tuned duration paper numbers
R_meas    = 84;   % Ohm
t_d1_td   = 4.5;  % ms
t_d2_td   = 2.0;  % ms
E_td      = 28.4; % J

%% load in fixed tilt paper numbers
t_d1_ft   = 10;   % ms
t_d2_ft   = 10;   % ms
tilt_d1   = 0.65; % percent
tilt_d2   = 0.65; % percent
E_ft      = 40;   % J


%% load in 2ms tau-m for 3a) 5ms tau-m for 3b)
tau_m = 2.0; % ms

% plot the response for tuned dur
[Vg_td, Vm_td, t_td] = biphasic_exp_tuned_dur(tau_m, C_g, E_td, R_meas, t_d1_td, t_d2_td, 'y');

% plot the response for fixed tilt
[Vg_ft, Vm_ft, t_ft] = biphasic_exp_fixed_tilt(tau_m, C_g, E_ft, R_meas, tilt_d1, tilt_d2, 'y');

%% measure each waveforms peak
peak_td = max(Vm_td);
peak_ft = max(Vm_ft);

%% measure each waveforms residual charge at td2
time_td2_td = (t_d1_td + t_d2_td);
time_td2_ft = (t_d1_ft + t_d2_ft);
fprintf('td2 (TD): %.1f | td2 (FT): %.1f\n', time_td2_td, time_td2_ft);

% get index of each timestamp
idx_td2_td = find( abs(t_td - time_td2_td) == min(abs(t_td - time_td2_td)));
idx_td2_ft = find( abs(t_ft - time_td2_ft) == min(abs(t_ft - time_td2_ft)));

fprintf('idx_td2 (TD): %d | idx_td2 (FT): %d\n', idx_td2_td, idx_td2_ft);

%% print peak volatges, and %age deviation
fprintf('Peak (TD): %f | Peak (FT): %f\n', peak_td, peak_ft);
peak_td = peak_td / peak_ft;
peak_ft_n = 1.00;
fprintf('Peak (TD %%max): %.2f | Peak (FT %%max): %.2f\n', 100*peak_td, 100*peak_ft_n);

% get residual
residual_td = Vm_td(idx_td2_td);
residual_ft = Vm_ft(idx_td2_ft);
fprintf('Residual Charge (TD): %f | Residual Charge (FT): %f\n', residual_td, residual_ft);



% find residual as a percentage of the max
residual_td = abs(residual_td) / peak_ft;
residual_ft = abs(residual_ft) / peak_ft;
fprintf('Residual Charge (TD %%max): %.2f | Residual Charge (FT %%max): %.2f\n', 100*residual_td, 100*residual_ft);