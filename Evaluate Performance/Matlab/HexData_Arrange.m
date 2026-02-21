%% Read hex data on 1 line as one string element %s or hex %x             
%fid = fopen('output.txt','r');              % open file
fid= fopen('Edges2.hex','r');
% fid= fopen('LenaGray.hex','r');

%For output after Th comparison
 values = textscan(fid,'%xu8','Delimiter','\n'); % read line by line
%For G_mag squared sum
% values = textscan(fid,'%xu32','Delimiter','\n'); % read line by line
fclose(fid);

data = values{1};  % cell array of all elements (each line as one element)
