fileID= fopen('Edges2.bin','rb');
data= fread(fileID);
% data=array;
%% 
% CONV = IP - FIL + ZP(lEFT+RIGHT) / ST  + 1
imageWidth = 256;               %   No. of columns
imageHeight = 510;              %   No. of rows
numColor = 1;

newData= uint8(zeros(imageWidth*imageHeight*numColor,1));
l = 1 ;
for i = 1:imageWidth 
	for j= 1: imageHeight 
		for k = 1 :numColor
newData(l+(k-1)*(imageWidth*imageHeight)) = data(imageWidth*(j-1)*numColor+(i-1)*numColor+k);
		end
        l = l + 1 ;
	end
end
fclose(fileID);
finalData= reshape (newData, [imageHeight,imageWidth,numColor]);
figure;
imshow(uint8(finalData))
