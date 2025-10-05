clear all;

%% load in previously found C-g tau-g
C_g   = 113.397; % uF
tau_g = 9.5254;  % ms

%% load in tuned duration paper numbers
R_meas = 84;   % Ohm
t_d1   = 4.5;  % ms
t_d2   = 2.0;  % ms
E      = 28.4; % J


%% define a search range for tau_m values for optimal t-d1
tau_m_guesses = 2.3:0.0001:2.6;
root_times    = zeros(length(tau_m_guesses));

for i = 1:length(tau_m_guesses)
    % get membrane voltage response
    [Vg, Vm, t] = biphasic_exp_tuned_dur(tau_m_guesses(i), C_g, E, R_meas, t_d1, t_d2, 'n');

    % take ddt and find where its at its minimum
    % due to FP values it will never be exactly 0 so we have to consider the minimum here
    dVm  = diff(Vm);
    root = find( abs(dVm) == min(abs(dVm)), 1 );

    %% with the root index we can find the time (ms) of the zero
    precision = 1e-5; % the provided function has us time-precision
    root_time = root * precision;
    root_time = 1e3 * root_time; % convert to ms

    % print info (why is this so verbose)
    fprintf('Iteration: %d | Current tau_m: %f | Root Time: %f ms\n', i, tau_m_guesses(i), root_time)
    
    % store the root time
    root_times(i) = root_time;
end

% now find the root-time closest to t_d1 and grab the corresponding tau_m_guess

best_tau_m_index = find( abs(root_times - t_d1) == min(abs(root_times - t_d1)), 1 );
fprintf('Best tau-m index for optimal phase 1: %d\n', best_tau_m_index);

best_tau_m     = tau_m_guesses(best_tau_m_index);
best_root_time = root_times(best_tau_m_index);
fprintf('Best tau-m: %f, with root-time: %f\n', best_tau_m, best_root_time);

% plot the optimal tau_m graph 
[Vg, Vm, t] = biphasic_exp_tuned_dur(best_tau_m, C_g, E, R_meas, t_d1, t_d2, 'y');