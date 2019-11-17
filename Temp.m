clear;

% load adaboost training results
load TrainResults.mat;
load Features.mat;

% load the detector cascade variables
if exist('detectorCascade.mat')
    load detectorCascade.mat;
end

%
rows = size(cascadeHaarFeaturesCount, 2);
cascadeHaarFeaturesCount{rows} = T;

%
rows = size(cascadeAlphaArray, 2);
cascadeAlphaArray{rows} = alpha_t_Array;

%
rows = size(cascadePBestArray, 2);
cascadePBestArray{rows} = pBestArray;

%
rows = size(cascadeThetaBestArray, 2);
cascadeThetaBestArray{rows} = thetaBestArray;

%
haarFeatures = f;

%
rows = size(cascadeStepBestFeatures, 2);
cascadeStepBestFeatures{rows} = fNbestArray;

% save the variables into a persistent storage
save detectorCascade.mat cascadeHaarFeaturesCount cascadeAlphaArray cascadeThetaBestArray cascadePBestArray haarFeatures cascadeStepBestFeatures cascadeSize
