% makes a list of face and nonface file names
fpath=which(mfilename);pathMF = fpath(1:findstr(upper(mfilename),upper(fpath))-1);
randNFace = 1;      % randomly choose nonface file names 0/1
numFace=500     %default

fildir=which(mfilename);    % get our name and path
fildir = fildir(1:findstr(fildir,mfilename)-1); % strip out name
filename = 'list_img.txt';
psep = '\';

numFaces=input('Number of face files?');
if isempty(numFaces) return;end;

%fotodir = uigetdir([],'Select face directory');     % get dir of faces
fotodir = uigetdir('Select face directory','.');     % get dir of faces
d = dir(fotodir);           % what's inside
numimg =max(size({d.name}));   % just take this number first
outputfile = fopen([pathMF filename],'w'); % same dir as m file
count = 0;
fprintf(outputfile,'%s', 'FACES',char(13), char(10));   % start of face files
for i = 1:numimg
    % if DIR OR not have bmp in WHOLE file name
    if d(i).isdir | isempty(findstr(upper(d(i).name),'BMP'))
    else
        count = count + 1;
        imgname = fprintf(outputfile,'%s', fotodir,psep,d(i).name,char(13), char(10));
        if count == numFaces;
            break;
        end;   % only want so many 
    end
end
numFaces = count;   % actual files used
fprintf(outputfile,'%s', 'NONFACES',char(13), char(10));    % start of nonface names

numNonFaces=500     %default
numNonFaces=input('Number of non-face files?');
if isempty(numNonFaces) return;end;
% get dir of faces - default same as faces
%fotodir = uigetdir(fotodir,'Select non-face directory');
fotodir = uigetdir('Select non-face directory',fotodir);
d = dir([fotodir '\*.bmp']);    % get BMP files only
numimg =max(size({d.name}));   % just take this number first
count = 0;
ri=randperm(numimg);
for i = 1:numimg
    % if d(i).isdir | isempty(findstr(upper(d(i).name),'BMP')) % if DIR OR not have bmp in WHOLE file name
    count = count + 1;
    if randNFace
        nFile = d(ri(i)).name;
    else
        nFile = d(i).name;
    end
    %imgname = fprintf(outputfile,'%s', fotodir,psep,d(i).name,char(13), char(10));
    imgname = fprintf(outputfile,'%s', fotodir,psep,nFile,char(13), char(10));
    if count == numNonFaces;
        break;
    end;   % only want so many 
end
numNonFaces = count;   % actual files used
fclose(outputfile);
