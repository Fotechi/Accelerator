data=uint8(data);

o_width = 256;                 % example value – set yours
o_width_new = 255;                 % without zp

N       =256*510 ;             % total iterations As zp in one dirction -
%right of image
%N       =255*510 ;             % total iterations

% Pre-allocate output matrix: rows = ceil(N/o_width),
 columns = 512;
rows = 512;
Data  = zeros(rows,columns , 'uint8');

for i = 0:N-1
    if (mod(i , o_width)~=0)
row = floor(i / o_width) + 1+1;                 % (i/o_width)+1 in Verilog
col = 2*mod(i , o_width)+ 1+1 ;              % ((2*i+1)%o_width)+1 for MATLAB 1-based indexing
% ----- put your 8-bit value here -----
% for example:
Data(row, col) = uint8( data(i+1) );
    end
end

%% 
% Read the image
img_org = imread('Bikesgray_512x512.jpg');  %  image file
%% 
psnrpk=psnr(img_org,Data)

[ss,sm]=ssim(img_org,Data);

ss
imshow(sm,[])
%% 
