% BPV_batch.m

f_resp = 12/60;       % Respiratory frequency [Hz]
RI = 5;            % Inspiratory airway resistance [cmH2O/(L/s)]
RL = 110;           % Air leakage resistance [cmH2O/(L/s)]
alarm = 1;         % 0 -> alarm off, 1 -> alarm on
bpm = 60*f_resp;
PV_exp = 3;     % Units = cmH2O, must use same value as BPV_sim.m
k_all = 0.01:0.01:0.99;
tidal_vol = zeros(1,length(k_all));
autoPEEP = zeros(1,length(k_all));

for j1 = 1:length(k_all)
    k = k_all(j1);
    [t,QV,PA,Vol] = BPV_sim(k,f_resp,RI,RL,alarm);
    n1 = round(length(t)/2);
    tidal_vol(j1) = max(Vol(n1:length(t))) - min(Vol(n1:length(t)));
    autoPEEP(j1) = min(PA(n1:length(t))) - PV_exp;
end

figure
plot(k_all,1000.*tidal_vol)
xlabel('k')
ylabel('Tidal Volume [mL]')

figure
plot(k_all,autoPEEP)
xlabel('k')
ylabel('Auto-PEEP [cmH2O]')
