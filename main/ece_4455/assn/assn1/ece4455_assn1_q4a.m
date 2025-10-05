%% load in previously found C-g tau-g
C_g   = 113.397; % uF
tau_g = 9.5254;  % ms

%% load in tuned duration paper numbers
R_meas    = 84;   % Ohm
t_d1_td   = 4.5;  % ms
t_d2_td   = 2.0;  % ms
E_td      = 28.4; % J

tau_m = 2.7270; % ms

[Vg_td, Vm_td, t_td] = biphasic_exp_tuned_dur(2.7270, 113.397, 28.4, 84, 4.5, 2.0, 'y');

%% q 4b

[Vg_ft, Vm_ft, t_ft] = biphasic_exp_fixed_tilt(2.7270, 113.397, 30, 84, 0.3765, 0.1893, 'y');

% Analyze the results from the tuned duration and fixed tilt experiments
figure;
subplot(2,1,1);       % first subplot
hold on;               % keep all plots on the same axes

% Plot all four curves
plot(t_td, Vg_td, 'b', 'LineWidth', 1.5);
plot(t_td, Vm_td, 'r', 'LineWidth', 1.5);
plot(t_ft, Vg_ft, 'g', 'LineWidth', 1.5);
plot(t_ft, Vm_ft, 'y', 'LineWidth', 1.5);

% Labels and title
xlabel('Time (ms)');
ylabel('Voltage (V)');
title('Tuned Duration vs Fixed Tilt Results');

% Legend for all four lines
legend('Vg (TD)', 'Vm (TD)', 'Vg (FT)', 'Vm (FT)');

hold off;
