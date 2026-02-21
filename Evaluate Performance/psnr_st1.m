data=uint8(data);

o_width = 510;                 % example value – set yours

N       =510*510 ;             % total iterations

% Pre-allocate output matrix: rows = ceil(N/o_width),
 columns = 512;
rows = 512;
Data  = zeros(rows,columns , 'uint8');

for i = 0:N-1
row = floor(i / o_width) + 1+1;                 % (i/o_width)+1 in Verilog
col = mod(i , o_width) + 1+1;              % ((j+i)%o_width)+1 for MATLAB 1-based indexing
% ----- put your 8-bit value here -----
% for example:
Data(row, col) = uint8( data(i+1) );
end

%% 
% Read the image
img_org = imread('Bikesgray_512x512.jpg');  %  image file
%% 
psnrpk=psnr(img_org,Data)

[ss,sm]=ssim(img_org,Data);

ss
imshow(sm,[])