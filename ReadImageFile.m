%----------------------------------------------
% Read in image files from list and normalize
% Create Integral Image versions of images
%   These take a short time and is independent of 
%   the number of and type of features
%----------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Read in files from list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FaceData=[];
global cropsize
fpath=which(mfilename);pathMF = fpath(1:findstr(upper(mfilename),upper(fpath))-1);
%[fname,pname] = uigetfile([fpath 'list_img.txt'] ,'Select text file with image names');
[fname,pname] = uigetfile([pathMF 'list_img.txt'] ,'Select text file with image names');

FID = fopen([pname,fname]);
line_string = fgetl(FID);
if ~strcmp(line_string,'FACES'); % 1st line has this?
    return;
end

while (~feof(FID))
    line_string=fgetl(FID);
    if (line_string == -1)
        break; %-1 if eof
    else
        if strcmp(line_string,'NONFACES');  % watch for nonfaces
            break;
        end
        Imr=imread(line_string);
        Imr=Imr(:)';
        FaceData=[FaceData ; Imr]; %each row is a face
    end
end
FaceData=double(FaceData); %Max=255 Min=0
sprintf('#faces %d',size(FaceData,1))
%read in Non faces
NonFaceData=[];
while (~feof(FID))
    line_string=fgetl(FID);
    if (line_string == -1)
        break; %-1 if eof
    else
        Imr=imread(line_string);
        Imr=Imr(:)';
        NonFaceData=[NonFaceData ; Imr];
    end
end
NonFaceData=double(NonFaceData); %Max=255 Min=0
sprintf('#nonfaces %d',size(NonFaceData,1))
%%%%%%%%%%%%%%%% NORMALIZE THE IMAGES %%%%%%%%%%%%%%%%
for i=1:size(FaceData,1)
    faceraw=reshape(FaceData(i,:),cropsize,cropsize);
    faceraw=normImageF(faceraw);
    faceraw=reshape(faceraw,1,cropsize*cropsize);
    FaceData(i,:)=faceraw;
end
for i=1:size(NonFaceData,1)
    NonFaceraw=reshape(NonFaceData(i,:),cropsize,cropsize);
    NonFaceraw=normImageF(NonFaceraw);
    NonFaceraw=reshape(NonFaceraw,1,cropsize*cropsize);
    NonFaceData(i,:)=NonFaceraw;
end

save([pathMF 'FaceNonFaceData.mat'],'FaceData','NonFaceData');% Normalized and ready
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Create Integral Image equivalents of file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

patchi=cropsize;                    % for this case, make same...TL 20/4/2k5
patchsize=cropsize*cropsize;
patchsizepad=(cropsize+1)*(cropsize+1);
numFaces = size(FaceData,1);        % get number of faces
numNonFaces = size(NonFaceData,1);  % & nonfaces

faces= zeros(numFaces,patchsize);
nonfaces= zeros(numNonFaces,patchsize);
%facesPad= zeros(numFaces,patchsizepad);
cumFaces= zeros(numFaces,patchsizepad);
nonfacesPad= zeros(numFaces,patchsizepad);
cumNonFace= zeros(numFaces,patchsizepad); 

for ind= 1:numFaces
    face= FaceData(ind,:);  % keep original
    padFace= padJN(face);
    faces(ind,:)= face;
    %facesPad(ind,:)= padFace;
    cumFaces(ind,:)= cumImageJN(padFace);   % since we are using II, must pad
end
clear FaceData;
for ind= 1:numNonFaces
    NonFace= NonFaceData(ind,:);
    NonFacePad= padJN(NonFace);
    nonfaces(ind,:)= NonFace;
    %nonfacesPad(ind,:)= NonFacePad;
    cumNonFaces(ind,:)= cumImageJN(NonFacePad);    % since we are using II, must pad
end 
% xN is total number of faces and of non-faces.
xN=numNonFaces+numFaces;
save([pathMF 'images.mat'], 'faces', 'cumFaces', 'nonfaces', 'cumNonFaces');
fclose(FID);
clear faces cumFaces nonfaces cumNonFaces FaceData NonFaceData
%imshow(reshape(NoiseData(1,:),24,24))