%%%% ECE 4455 Assignment 2 Question 1

% Note: Comment out the initializations of the variables 'cond','lvad', and
% 'Qlvad_Lmin from LVAD_batch.m and LVAD_model.m provided from class for
% this script to work properly, we assign those variables here
% you will also need to type in 'figure;' before the plot command in
% LVAD_model.m script for this to work properly.

clear;

% First we generate the plots from LVAD_batch.m with the following
cond = 'F';
lvad = 'y';
LVAD_batch;

clear;
% then we need to pick two points to the right of the knee in Fig. 1
% here we run stuff for the first value we choose
cond       = 'F';
act        = 'R';
lvad       = 'y';
Qlvad_Lmin = 6.5; % L/min
LVAD_model;

% we can plot Plv vs t and Pa vs t in Fig 4
figure(4);
hold on;
plot(t, Plv);
plot(t, Pa);
legend("LV Pressure", "Arterial Pressure");
xlabel('Time (s)');
ylabel('Plv (mmHg)');
title(sprintf('LV and Arterial Pressure vs Time for Qlvad = %.2f L/min', Qlvad_Lmin));
hold off;
clearvars;

% plot plv and pa vs t in fig 6
cond       = 'F';
act        = 'R';
lvad       = 'y';
Qlvad_Lmin = 8.5; % L/min
LVAD_model;

% we can plot Plv vs t and Pa vs t in Fig 6
figure(6);
hold on;
plot(t, Plv);
plot(t, Pa);
legend("LV Pressure", "Arterial Pressure");
xlabel('Time (s)');
ylabel('Plv (mmHg)');
title(sprintf('LV and Arterial Pressure vs Time for Qlvad = %.2f L/min', Qlvad_Lmin));
hold off;

clearvars;
% Now we run it again for a pateitn with no LVAD (skull emoji)

cond       = 'F';
act        = 'R';
lvad       = 'n';
LVAD_model;

% we can plot Plv vs t and Pa vs t in Fig 6
figure(8);
hold on;
plot(t, Plv);
plot(t, Pa);
legend("LV Pressure", "Arterial Pressure");
xlabel('Time (s)');
ylabel('Plv (mmHg)');
title('LV and Arterial Pressure vs Time for Resting Heart Failure Patient w.o LVAD');
hold off;

%% Why LVAD Overrides Heart Function
% 1 - When LVAD set to RHS of knee point, the PV curve of LV shows that the
%     heart doesnt get enough blood volume to have an effective contraction
%     due to the LVAD essentially draining the LV volume.
% 2 - Due to this reduced volume in LV, the contraction is less effective,
%     leading to a weaker pump essentially.
% 3 - This means that the LVAD is basically doing most of the work this can
%     be seen due to the arterial pressure being essentially constant for a
%     patient using an LVAD past the knee point, the arteries essentially
%     get a constant supply of blood, causing the two element windkessel to
%     have a fully stored compliance (lots of pressure)
% 4 - In a non LVAD patient, the arterial pressure is seen to be periodic
%     and follows the LV pressure, this is because the LV flow is coming
%     from the pulsatile nature of the heart, and the Artierial pressure
%     drops off due to the windkessel like nature of the compliance.