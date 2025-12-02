% BPV_batch2.m

f_resp = 12/60;       % Respiratory frequency [Hz]
RI_all = 5:60;            % Inspiratory airway resistance [cmH2O/(L/s)]
RL = 1e6;           % Air leakage resistance [cmH2O/(L/s)] here its 1M so barely any leak :)
alarm = 1;         % 0 -> alarm off, 1 -> alarm on

bpm = 60*f_resp;
PV_exp = 3;     % Units = cmH2O, must use same value as BPV_sim.m
k_all = 0.01:0.01:0.99;
max_tol_autoPEEP = inf;   % Units = cmH2O

h = 162.3;
PBW = 0.76.*(h - 133) + 27.8;
TV_target = [0.008 0.009].*PBW;           % units = L

acceptable_k = zeros(length(RI_all),length(k_all));
k_max_TV = zeros(length(RI_all),length(k_all));
k_80pct_max_TV = zeros(length(RI_all),length(k_all));

for m1 = 1:length(RI_all)
    percent_done = 100*(m1 - 1)/length(RI_all)
    RI = RI_all(m1);
    tidal_vol = zeros(1,length(k_all));
    autoPEEP = zeros(1,length(k_all));

    for j1 = 1:length(k_all)
        [t,QV,PA,Vol] = BPV_sim(k_all(j1),f_resp,RI,RL,alarm);
        n1 = round(length(t)/2);
        tidal_vol(j1) = max(Vol(n1:length(t))) - min(Vol(n1:length(t)));
        autoPEEP(j1) = min(PA(n1:length(t))) - PV_exp;
    end
    
    temp1 = find(tidal_vol >= (max(tidal_vol) - 0.0001));
    for j1 = 1:length(temp1);
            k_max_TV(m1,j1) = k_all(temp1(j1));
    end
    temp1 = find(tidal_vol >= 0.8*max(tidal_vol));
    for j1 = 1:length(temp1);
            k_80pct_max_TV(m1,j1) = k_all(temp1(j1));
    end

    temp1 = find(tidal_vol >= TV_target(1));
    temp2 = find(tidal_vol <= TV_target(2));
    temp3 = intersect(temp1,temp2);
    temp4 = find(autoPEEP <= max_tol_autoPEEP);
    temp5 = intersect(temp3,temp4);
    if length(temp5 > 0)
        for j1 = 1:length(temp5);
            acceptable_k(m1,j1) = temp5(j1);
        end
    end
end

figure; hold on
for m1 = 1:length(RI_all)
    temp10 = nonzeros(k_80pct_max_TV(m1,:));
    plot(RI_all(m1),min(temp10),'bo')
    plot(RI_all(m1),max(temp10),'bo')
    temp9 = nonzeros(k_max_TV(m1,:));
    plot(RI_all(m1).*ones(1,length(temp9)),temp9,'ro')
end
xlabel('R_I [cmH_2O/(L/s)]')
ylabel('k values that maximize tidal volume')
axis([RI_all(1) max(RI_all) 0 1])

figure; hold on
for m1 = 1:length(RI_all)
    temp7 = nonzeros(acceptable_k(m1,:));
    temp8 = k_all(temp7);
    plot(RI_all(m1).*ones(1,length(temp8)),temp8,'b.')
end
xlabel('R_I [cmH_2O/(L/s)]')
ylabel('"Acceptable" k values')
axis([RI_all(1) max(RI_all) 0 1])
