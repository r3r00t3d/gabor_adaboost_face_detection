function makeImagesF 
global cropsize;
minfeaturesize=8;       % CHANGE THIS FOR LESS FEATURES TO TRAIN ON 
cropsize = 24;
patchi=cropsize;
fpath=which(mfilename);pathMF = fpath(1:findstr(upper(mfilename),upper(fpath))-1);
%load('FaceNonFaceData.mat');
% get features for use with integral images 
% 1st two numbers are feature size window - 3rd no is the feature min size 
% MUST CHANGE FOR DIFFERENT SIZE IMAGES 
[f, Vidx, F, Fidx, Pidx]= violaboxeszero(patchi,patchi,minfeaturesize);
save([pathMF 'features.mat'], 'f');