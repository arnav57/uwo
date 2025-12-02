%%%% ECE 4455 Assignment 2 Question 2

% Choosing a K value that corresponds to a Starling curve intersecting the
% resting (blue) plot of Qlvad vs Plved plot.

% first run LVAD_batch with correct params and extract the following var
% 'Qlvad_Starling'
clearvars;

cond = 'F';
lvad = 'y';
LVAD_batch;

% choose a K value and plot it in yellow against the other plot (from
% LVAD_batch.m)
%   K = 0.465;
%   Qlvad_Starling = K .* (0.0003.*(Plved_cont.^3) -0.0276.*(Plved_cont.^2) + 0.9315.*Plved_cont - 0.0928);
%   plot(Plved_cont,Qlvad_Starling,'yellow');

% knee in the curve is at (x,y) = (18.7604, 4.5)
% search for a value of K that intersects with this point (or gets the
% closest to it)

K_guesses = 0.42:0.001:0.48;
y_values_at_knee = zeros(1, length(K_guesses));

x_knee = 18.7604;
y_knee = 4.5;

for i = 1:length(K_guesses)
    K = K_guesses(i);   
    Qlvad_Starling = K .* (0.0003.*(Plved_cont.^3) -0.0276.*(Plved_cont.^2) + 0.9315.*Plved_cont - 0.0928);
    
    % find index closes to x_knee
    [~, idx] = min(abs(Plved_cont - x_knee));

    % store the corresponding point on controller curve at this K value
    curr_knee_val = Qlvad_Starling(idx);
    y_values_at_knee(i) = curr_knee_val;

    fprintf("Iteration %d/%d (%.2f%%) | K = %.4f | Knee Value = %.4f\n", i, length(K_guesses), 100 * i/length(K_guesses), K, curr_knee_val);
end

% Calculate the difference between the knee value and the corresponding Qlvad_Starling values
differences = abs(y_values_at_knee - y_knee);

% Find the K value that minimizes the difference
[~, best_idx] = min(differences);
best_K = K_guesses(best_idx);

fprintf('Best K value found: %.4f\n', best_K);

% Plot this K value in yellow on top of the plot from LVAD_batch.m
K = best_K;
Qlvad_Starling = K .* (0.0003.*(Plved_cont.^3) -0.0276.*(Plved_cont.^2) + 0.9315.*Plved_cont - 0.0928);
plot(Plved_cont,Qlvad_Starling, 'yellow');
title(sprintf("Starling (Controller) Curve for intersection with Resting Knee Point, K = %.4f in yellow", K));

%% What this "best K" value means
% - Will make the LVAD work together with the heart, not completely
%   override it.
