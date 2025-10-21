function thres = myintermeans_25( im )

%% Accepts a UNIT-8 IMAGE 'im'
%% Returns a 0-1 float for gray level threshold 'thresh'

%% Calculate Histogram
D_t = 0:255;
D   = D_t(:); % need to transpose this arr as h is 256x1 and originally D is 1x256
h   = imhist(im);

%% make a initial guess for 'T' as the avg value in the img
T_current = round(mean2(im)); 

%% can do this iteratively so we can start with an obviously wrong T value
%% since inital T_current can be 0 (min value) having -1 here guarantees we dont converge right away.
T_past = -1;

%% iterate over values of T
while abs(T_current - T_past) > 0 
    % get the lower and upper ranges
    lowrange  = D <= T_current;
    highrange = D >  T_current;

    % find the components of mu_1
    low_D_dot_h = sum( D(lowrange) .* h(lowrange) );   % top part of mu_1 fraction
    mu_1 = low_D_dot_h / sum(h(lowrange)); % bot part of my-1 fraciton
    %disp(mu_1);

    % find the components of mu_2
    high_D_dot_h = sum( D(highrange) .* h(highrange) );  % top part of mu_2_fraction
    mu_2 = high_D_dot_h / sum(h(highrange)); % bot part of mu_2 fraction
    %disp(mu_2);

    % Update threshold T
    T_past    = T_current;                % the current threshold becomes the previous value in next iteration
    T_current = round((mu_1 + mu_2) / 2); % then we can update the current threshold value
end

% after loop above is done this is the final threshold value
thres = T_current / 255;


end




