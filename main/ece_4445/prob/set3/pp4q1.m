im = imread('head.tif');
figure;
imshow(im);

%% average
f1 = fspecial('average', 20);
im1 = uint8(filter2(f1, im));
figure;
imshow(im1);

%% gaussian
f2 = fspecial('gaussian', 10, 5);
im2 = uint8(filter2(f2, im));
figure;
imshow(im2);

%% prewitt (horizontal edges)
f3 = fspecial('prewitt');
im3 = uint8(filter2(f3, im));
figure;
imshow(im3);

%% prewitt (verti0cal edges)
f4 = fspecial('prewitt')';
im4 = uint8(filter2(f4, im));
figure;
imshow(im4);
