% Function to mix two images together using upper and lower contents of the
% frequency space. 
% 
% This does not work well with the given square and triangle. Use two
% faces. 
% 
% This was inspired by the following paper but implemented without it: 
% http://cvcl.mit.edu/publications/OlivaTorralb_Hybrid_Siggraph06.pdf
%
% The low and high pass filters are not really good. 
%
% Of course, it would be absolutely awesome if the images could be matched
% first, so that low frequency components would lie on top of each other. 
% But for now, do the alignment first by hand.

function main
clear all; close all;
square = imread('square.png');
square = rgb2gray(square);

triangle = imread('triangle.png');
triangle = rgb2gray(triangle);

n = 0.02;
L = lowFreq(triangle, n);
% figure;
% imshow(L, []);

H = highFreq(square, n);
% figure;% figure;
% imshow(H, []);

S = H + L;
S = abs(S);
m = 1 / (max(S(:)) - min(S(:)));
b = - min(S(:)) / (max(S(:)) - min(S(:)));
S = m * S + b;

figure;
imshow(S);
imwrite(S, 'result.png');

function R = lowFreq(img, n)
% returns high frequencies only
% n must be less than 1. the smaller n is, the more freq. are included.
% matched to lowFreq() function.
n = 1-n;
F = fft2(img);
% High freq are in the middle, take rectangle there.
s = size(img);
uX = round(0.5 * s(1)*(1 + n)); % upper in X direction
lX = round(0.5 * s(1)*(1 - n)); % lower in Y direction
uY = round(0.5 * s(2)*(1 + n));
lY = round(0.5 * s(2)*(1 - n));
F(lX:uX, lY:uY) = 0;
G = F;
R = ifft2(G);

function R = highFreq(img, n)
% returns high frequencies only
% n must be less than 1. the smaller n is, the more freq. are included.
% matched to lowFreq() function.
F = fft2(img);
F = fftshift(F);
% High freq are in the middle, take rectangle there.
s = size(img);
uX = round(0.5 * s(1)*(1 + n)); % upper in X direction
lX = round(0.5 * s(1)*(1 - n)); % lower in Y direction
uY = round(0.5 * s(2)*(1 + n));
lY = round(0.5 * s(2)*(1 - n));
F(lX:uX, lY:uY) = 0;
G = F;
G = ifftshift(G);
R = ifft2(G);

