clear all;

%% load in previously found C-g tau-g
C_g   = 113.397; % uF
tau_g = 9.5254;  % ms

%% load in tuned duration paper numbers
R_meas = 84;   % Ohm
t_d1   = 4.5;  % ms
t_d2   = 2.0;  % ms
E      = 28.4; % J


%% define a search range for tau_m values for optimal t-d2
tau_m_guesses = 2.3:0.0001:2.8;
root_times    = zeros(length(tau_m_guesses));

for i = 1:length(tau_m_guesses)
    % get membrane voltage response
    [Vg, Vm, t] = biphasic_exp_tuned_dur(tau_m_guesses(i), C_g, E, R_meas, t_d1, t_d2, 'n');
    
    % for optimizing td2 we need the root of Vm to be around t_d1 + t_d2 ms
    % before we find the min we must strip the start away a bit
    % this is because Vm starts at 0
    Vm = Vm(50:end);
    root = find( abs(Vm) == min(abs(Vm)), 1 );

    % with the root index we can find the time of the zero
    precision = 1e-5;
    root_time = root * precision;
    root_time = root_time * 1e3; % convert to ms

    % print info
    fprintf('Iteration: %d | Current tau_m: %f | Root Time: %f ms\n', i, tau_m_guesses(i), root_time)
    
    % store the root time
    root_times(i) = root_time;
end

% now find the root-time closest to t_d1 + t_d2 and grab the corresponding tau_m_guess

t_d = t_d1 + t_d2;

best_tau_m_index = find( abs(root_times - t_d) == min(abs(root_times - t_d)), 1 );
fprintf('Best tau-m index for optimal phase 1: %d\n', best_tau_m_index);

best_tau_m     = tau_m_guesses(best_tau_m_index);
best_root_time = root_times(best_tau_m_index);
fprintf('Best tau-m: %f, with root-time: %f\n', best_tau_m, best_root_time);

% plot the optimal tau_m graph 
[Vg, Vm, t] = biphasic_exp_tuned_dur(best_tau_m, C_g, E, R_meas, t_d1, t_d2, 'y');