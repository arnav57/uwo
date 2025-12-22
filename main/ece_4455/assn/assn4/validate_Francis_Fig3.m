function validate_Francis_Fig3(min_fract_HF,randomize)

global Vdot_A_bar beta V_L C_bar

% Seed random number generator
if randomize == 0
    seed = input('Enter the last 5 digits of your student number: ');
    rng(seed)
elseif randomize == 1
    rng('shuffle')
else
    error('randomize must be set to 0 or 1.')
end

% Create N_subjects in each patient category from Fig. 3.
N_subjects = 100;

% Lower and upper frequency bounds for stability analysis, in cycles/min:
f_min = 60*0.001;
f_max = 60*10;

a_min = log10(f_min);
a_max = log10(f_max);
w = (2*pi).*logspace(a_min,a_max,1e5);

% Patient parameters from Francis et al. pp. 2216 and 2218 except where noted.

% Steady-state alveolar ventilation in L/min.  Measured but not reported by Francis,
% so calculated from Q_E and Q_D values in Khoo textbook.
Vdot_A_bar = 60*(0.12 - 0.09);

beta = 0.05*100;    % CO2 solubiity in blood, dimensionless.
V_L = 3.5;          % End-expiratory lung volume in L.
C_bar = 0.048;      % Steady-state alveolar CO2 mole fraction, dimensionless.

% Mean and standard deviation of chemoreflex "sensitivity", in (L/min)/atm, for
% control, stable CHF , and unstable CHF patients, respectively.
% Standard deviations are double the values given in the article to obtain
% approximately continuous coverage of a 2-D region in Francis's X, Y plane.
mu_GF = [526 620 1749];
sigma_GF = 2*[104 103 235];

% Mean and standard deviation of chemoreceptor delay, in min, specified in the
% same format as the sensitivity data.
mu_d = [0.30 0.40 0.53];
sigma_d = 2*[0.04 0.06 0.06];

% Healthy-subject cardiac output in L/min, computed assuming body mass = 82 kg,
% which is the mass of the avergae 60 year-old male.
Q_dot_h = 0.06*82;

% Create subject-specific values of sensitivity, delay, cardiac output, and
% Francis's X and Y parameters.
G_F = zeros(3,N_subjects);
delta = zeros(3,N_subjects);
Q_dot = zeros(3,N_subjects);
X = zeros(3,N_subjects);
Y = zeros(3,N_subjects);

for i1 = 1:3
    G_F(i1,:) = sigma_GF(i1).*randn(1,N_subjects) + mu_GF(i1);
    
    % Reset negative G_Fs (if any) to mean value for that type of subject.
    temp1 = find(G_F(i1,:) <= 0);
    if length(temp1) > 0
        G_F(i1,temp1) = mu_GF(i1).*ones(1,length(temp1));
    end

    delta(i1,:) = sigma_d(i1).*randn(1,N_subjects) + mu_d(i1);
    
    % Reset negative deltas (if any) to mean value for that type of subject.
    temp2 = find(delta(i1,:) <= 0);
    if length(temp2) > 0
        delta(i1,temp2) = mu_d(i1).*ones(1,length(temp2));
    end
    
    if i1 == 1
        Q_dot(i1,:) = Q_dot_h.*ones(1,N_subjects);
    else
        Q_dot(i1,:) = Q_dot_h.*(min_fract_HF + (1-min_fract_HF).*rand(1,N_subjects));
    end
    
    X(i1,:) = (Vdot_A_bar + beta.*Q_dot_h).*(delta(i1,:)./V_L);
    Y(i1,:) = C_bar*G_F(i1,:).*(delta(i1,:)./V_L);
    
    clear temp1 temp2 temp3
end

% Initialize matrices of stability flags (0 = unstable or marginally stable, 1 = stable)
% and gain margins.
stability = ones(3,N_subjects);
GM = ones(3,N_subjects);

% Compute open-loop transfer function for each subject and use it to evaluate
% stability and gain margin.
for i1 = 1:3
    for j1 = 1:N_subjects
        H_OL = Francis_model(G_F(i1,j1),delta(i1,j1),Q_dot(i1,j1));        
        Hw = squeeze(freqresp(H_OL,w));
        GM(i1,j1) = evaluate_gain_margin(Hw);
        if GM(i1,j1) <= 1
           stability(i1,j1) = 0;
        end 
    end
end

% Re-arrange X, Y, and stability data into 1-D vectors for statistical analysis.
% stab1D_char contains text for legend of Fig. 3-style scatter plot.
X1D = reshape(X,3*N_subjects,1);
Y1D = reshape(Y,3*N_subjects,1);
stab1D = reshape(stability,3*N_subjects,1);
stab1D_char = char(88.*ones(3*N_subjects,8));
for i1 = 1:length(stab1D)
    if stab1D(i1) == 0
        stab1D_char(i1,:) = 'unstable';
    else
        stab1D_char(i1,:) = 'stable  ';
    end
end

% Create scatter plot and overlay initial guess of linear classifier.
figure
gscatter(X1D,Y1D,stab1D_char,'br','ox')
hold on
Xs = 0:0.01:7;
plot(Xs,0.9.*Xs + pi/2,'k')
%legend('classifier') -> comment out as said on dec 8 lec
xlabel('X')
ylabel('Y')
axis([0 7 0 30])
grid on

% Prompt user to refine slope and Y-axis intercept of linear classifier.
OK = 0;
while OK == 0
    m = input('Enter new value for slope: ');
    b = input('Enter new value for Y-axis intercept: ');
    close; figure
    gscatter(X1D,Y1D,stab1D_char,'br','ox')
    hold on
    plot(Xs,m.*Xs + b,'k')
    xlabel('X')
    ylabel('Y')
    axis([0 7 0 30])
    grid on

    % Compute and output number of unstable subjects and true-positive fraction
    % of refined linear classifier.
    clear temp1
    temp1 = find(stab1D == 0);
    TP = 0;
    for i1 = 1:length(temp1)
        if Y1D(temp1(i1)) >= m*X1D(temp1(i1)) + b
            TP = TP + 1;
        end
    end
    N_unstable = length(temp1);
    TPF = TP/N_unstable

    % Compute and output number of stable subjects and true-negative fraction
    % of refined linear classifier.
    clear temp2
    temp2 = find(stab1D == 1);
    TN = 0;
    for i1 = 1:length(temp2)
        if Y1D(temp2(i1)) < m*X1D(temp2(i1)) + b
            TN = TN + 1;
        end
    end
    N_stable = length(temp2);
    TNF = TN/N_stable

    OK = input('Enter 1 to accept this boundary or 0 to try again: ');
end
