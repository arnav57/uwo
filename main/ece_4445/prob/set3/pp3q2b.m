%% QUESTION 2b
% design row vector f for window/level operation of L = 74, and W = 38
% plot vector, original img, resulting img, output im should be uint8

im = imread('head.tif');

W = 38;
L = 74;

% create row vector 'f'
x = 0:255;
f = zeros(1, 256);

lo = W - L/2;
hi = W + L/2;

for i = 1:256
    if x(i) <= lo
        f(i) = 0;
    elseif x(i) >= hi
        f(i) = 255;
    else
        f(i) = 255 * (x(i) - lo) / (hi - lo);
    end
end

f = uint8(f);

% Plot the vector f
figure;
plot(x, f);
title('Window + Level Operation Vector');
xlabel('Input Intensity');
ylabel('Output Intensity');

% Plot the original image
figure;
imshow(im)

% Plot the modded img
figure;
im2 = f(double(im) + 1); % have to +1 here since double(im) can contain zeroes, but matlab indexes start at 1
imshow(im2);

