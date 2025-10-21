function thres = AIintermeans_25(im)
% Calculates normalized gray level threshold using Ridler-Calvard algorithm

% Compute histogram
h = imhist(im);

% Initial threshold guess
T = round(mean2(im));
prevT = Inf;

while abs(T - prevT) > 0
    % Compute weighted sums and total weights for both regions
    lowerSum = sum((0:T) .* h(1:T+1)');
    lowerWeight = sum(h(1:T+1));
    
    upperSum = sum((T+1:255) .* h(T+2:256)');
    upperWeight = sum(h(T+2:256));
    
    % Compute means
    if lowerWeight == 0
        mean1 = 0;
    else
        mean1 = lowerSum / lowerWeight;
    end
    
    if upperWeight == 0
        meanU = 0;
    else
        meanU = upperSum / upperWeight;
    end
    
    % Update threshold
    prevT = T;
    T = round((mean1 + meanU) / 2);
end

% Normalize threshold to [0, 1]
thres = T / 255;
end