clear;

% load the detector cascade variables
if exist('detectorCascade.mat')
    load detectorCascade.mat;
end

%
cascadeHaarFeaturesCount = cell(1);
cascadeHaarFeaturesCount{1} = [];

%
cascadeAlphaArray = cell(1);
cascadeAlphaArray{1} = [];

%
cascadeThetaBestArray = cell(1);
cascadeThetaBestArray{1} = [];

%
cascadePBestArray = cell(1);
cascadePBestArray{1} = [];

%
haarFeatures = [];

%
cascadeStepBestFeatures = cell(1);
cascadeStepBestFeatures{1} = [];

%
cascadeSize = 0;

% save the variables into a persistent storage
save detectorCascade.mat cascadeHaarFeaturesCount cascadeAlphaArray cascadeThetaBestArray cascadePBestArray haarFeatures cascadeStepBestFeatures cascadeSize
