function [t,QV,PA,Vol] = BPV_sim(k,f_resp,RI,RL,alarm)
% Linear model of bilevel pressure ventilator performance.
% Based on A.B. Adams, P.L. Bliss, and J. Hotchkiss, Respir. Care 45:390-400, 2000.
% Added patient effort term following 

cycles = 20;        % Number of respiratory cycles computed

RE = RI;            % Expiratory airway resistance [cmH2O/(L/s)]
C = 0.1;            % Patient lung compliance [L/cmH2O] (same for normal and COPD)
RV = 10;            % Ventilator expiratory valve resistance [cmH2O/(L/s)]
PV_insp = 15;       % Inspiratory pressure applied during pressure-controlled mode [cmH2O]
PV_exp = 3;         % Expiratory applied pressure (PEEP) [cmH2O]
Qmax = 2;           % Maximum ventilator output flow [L/s]
dt = (1/f_resp)/1e4;         % Simulation time step [s]
insp_frac = 1/3;      % Inspiratory fraction, 0 to 1, relevant only if alarm is on.
max_t_insp = insp_frac*(1/f_resp);    % Relevant only if alarm is on

t = 0:dt:(cycles/f_resp);   % Simulation time, a vector [s]
Pao = zeros(1,length(t));   % Pressure at airway opening [cmH2O]
PA = zeros(1,length(t));    % Alveolar pressure [cmH2O]
QV = zeros(1,length(t));    % Net flow from ventilator [L/s]
QA = zeros(1,length(t));    % Alveolar flow [L/s]
QL = zeros(1,length(t));    % Leakage flow [L/s]
Vol = zeros(1,length(t));   % Lung volume [L]

% Initial condition: End-expiratory lung volume assuming zero auto-PEEP.
Vol(1) = PV_exp*C;
Vol(2) = Vol(1);
PA(1) = PV_exp;

index = 1;              % Initialize time sample counter
for c1 = 1:cycles       % Loop on number of respiratory cycles
    
% At the beginning of the respiratory cycle, compute a QV_star assuming normal
% inspiration.  Note that the pressure across the lung compliance at the end
% of the last expiratory period in this calculation.
    QV_star = (PV_insp-PA(index))/RI + PV_insp/RL;
    
% Set Q_peak, the initial flow rate during inspiration (which is used to determine 
% the inspiratory flow cutoff), and the current value of QV to the smaller of QV_star 
% and Qmax.

% During inspiration, t0 is the time the ventilator entered flow-limited mode and
% t1 is the time the ventilator entered normal inspiration.  PA0 is the 
% alveolar pressure when the ventilator entered flow-limited mode and PA1 is the
% alveolar pressure when the ventilator switched to normal inspiration.
    if QV_star > Qmax
        Q_peak = Qmax;
        t0 = t(index);
        PA0 = PA(index);
    else
        Q_peak = QV_star;
        t1 = t(index);
        PA1 = PA(index);
    end
    QV(index) = Q_peak;
 
% Determine maximum time by which current inspiration must end.
    if alarm == 0
        t_end_insp = c1/f_resp;
    elseif alarm == 1
        t_end_insp = t(index) + max_t_insp;
    else
        error('alarm must be set to logic 0 or logic 1.')
    end
    
% The following while loop computes the system performance during inspiration.
% QV is tested against the flow threshold defined by k and the current time is 
% tested against the maximum time available for inspiration.               
    while (QV(index)/Q_peak > k) & (t(index) < t_end_insp)
        index = index + 1;

% The current value of QV_star is used to determine whether the ventilator is in
% flow-limited or normal inspiration during the next time step.
        if QV_star > Qmax                   % Flow-limited inspiration
            PA(index) = Vol(index)/C;
            Pao(index) = (RL*(RI*Qmax + PA(index)))/(RL + RI);
            QA(index) = (Pao(index)-PA(index))/RI;
            QL(index) = Pao(index)/RL;
            QV(index) = QA(index) + QL(index);
            Vol(index+1) = Vol(index) + QA(index)*dt;

% At the end of each time step in flow-limited mode, PA1 and t1 are reset to the 
% current values of PA and t in case the ventilator switches into normal
% inspiration in the next time step.
            PA1 = PA(index);
            t1 = t(index);
            
        else                                % Normal inspiration
            PA(index) = Vol(index)/C;
            Pao(index) = PV_insp;
            QA(index) = (PV_insp-PA(index))/RI;
            QL(index) = PV_insp/RL;
            QV(index) = QA(index) + QL(index);
            Vol(index+1) = Vol(index) + QA(index)*dt;
        end
        
% The above if-else blocks compute a single time step in either flow-limited or 
% normal inspiration mode.  At the end of the time step, the value of QV_star is
% updated for use in the next time step.
        QV_star = (PV_insp-PA(index))/RI + PV_insp/RL;
        
    end             % end of inspiration while loop, ready for next time step
    
% During expiration, t0 is the time the ventilator switched from inspiration to 
% expiration and PA0 is the alveolar pressure at t = t0.
    PA0 = PA(index);
    t0 = t(index);

% The following while loop computes the system performance during expiration.
% There is only one exit condition, the time remaining in the respiratory period.
% Note that flows are treated as signed quantities.
    while t(index) < c1/f_resp
        index = index + 1;
        PA(index) = Vol(index)/C;
        Pao(index) = PV_exp;
        QA(index) = (PV_exp-PA(index))/RI;
        QL(index) = PV_exp/RL;
        QV(index) = QA(index) + QL(index) + PV_exp/RV;
        Vol(index+1) = Vol(index) + QA(index)*dt;
    end
    
end                 % End of for loop on respiratory cycles

% Delete extra volume sample from end of last time step.
Vol = Vol(1:length(t));

%% The k-value is a threshold for when 