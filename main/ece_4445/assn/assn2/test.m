im = imread('rice.png');
thresh    = myintermeans_25(im);
ai_thresh = AIintermeans_25(im);

fprintf("Human Coded Algo -> %.5f\n" , thresh);
fprintf("AI Coded Algo    -> %.5f\n" , ai_thresh);

%% show original image and image from my code
%T = round(thresh * 255);
%im_bw = im > T;
%imshowpair(im, im_bw, 'montage');

%% show original image and image from the AI's code
%T = round(ai_thresh * 255);
%im_bw = im > T;
%imshowpair(im, im_bw, 'montage');

