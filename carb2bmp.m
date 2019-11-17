function tobmp(sourceFile, imgSize)
% converts Carbonetto formatted images - an image takes up imgSize^2 bytes
% Usage: cd to dir containing sourceFile.
% run function e.g. tobmp('faces.pat' 24) 
% make sure this function is in the path!
fid = fopen(sourceFile);

% Start from position 0 and find out how many images are in the
% file.
fseek(fid, 0, 'eof');
numImages = ftell(fid) / (imgSize * imgSize);
fseek(fid, 0, 'bof');

%  faces = zeros(imgSize, imgSize, numImages);
for i = 1:numImages,
    [A count] = fread(fid, [imgSize imgSize], 'uint8');
    imwrite(uint8(A'),[sprintf('%04.0f',i) '.bmp'],'bmp');
    %faces(:,:,i) = A';
end
fclose(fid);
