clear;

% load adaboost training results
load TrainResults.mat;
load Features.mat;

% load the detector cascade variables
if exist('detectorCascade.mat')
    load detectorCascade.mat;
end

%
if exist('cascadeHaarFeaturesCount', 'var') == 0
    cascadeHaarFeaturesCount{1} = T;
else
    rows = size(cascadeHaarFeaturesCount, 2);
    cascadeHaarFeaturesCount{rows+1} = T;
end

%
if exist('cascadeAlphaArray', 'var') == 0
    cascadeAlphaArray{1} = alpha_t_Array;
else
    rows = size(cascadeAlphaArray, 2);
    cascadeAlphaArray{rows+1} = alpha_t_Array;
end

%
if exist('cascadePBestArray', 'var') == 0
    cascadePBestArray{1} = pBestArray;
else
    rows = size(cascadePBestArray, 2);
    cascadePBestArray{rows+1} = pBestArray;
end

%
if exist('cascadeThetaBestArray', 'var') == 0
    cascadeThetaBestArray{1} = thetaBestArray;
else
    rows = size(cascadeThetaBestArray, 2);
    cascadeThetaBestArray{rows+1} = thetaBestArray;
end

%
if (exist('haarFeatures', 'var') == 0) || (isempty(haarFeatures))
    haarFeatures = f;
end

%
if exist('cascadeStepBestFeatures', 'var') == 0
    cascadeStepBestFeatures{1} = [fNbestArray;];
else
    rows = size(cascadeStepBestFeatures, 2);
    cascadeStepBestFeatures{rows+1} = fNbestArray;
end

%
if exist('cascadeSize', 'var') == 0
    cascadeSize = 1;
else
    cascadeSize = cascadeSize + 1;
end

% save the variables into a persistent storage
save detectorCascade.mat cascadeHaarFeaturesCount cascadeAlphaArray cascadeThetaBestArray cascadePBestArray haarFeatures cascadeStepBestFeatures cascadeSize
