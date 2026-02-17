% Read the image
img_org = imread('Bikesgray_512x512.jpg');  %  image file

% Convert to grayscale (optional, if RGB not needed)
% img = rgb2gray(img);

%Flip
img= fliplr(img_org); 


% Get image size
[rows, cols, channels] = size(img);

% Open a file to write
fileID = fopen('BrickGray_flp_2hexdigitsperline__00.hex', 'w');

% Loop through each pixel
for c = 1:channels
    for r = 1:rows
        for col = 1:cols
            pixelValue = img(r, col, c);
            hexStr = dec2hex(pixelValue, 2);  % 2-digit hex (00 to FF)
            fprintf(fileID, '%s\n', hexStr);  % Write to file
        end
    end
end

% Close the file
fclose(fileID);

disp('Hex file created successfully!');
