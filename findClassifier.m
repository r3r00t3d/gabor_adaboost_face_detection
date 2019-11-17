function [threshold, parity, wtdError]= findClassifier(posFeatures, negFeatures, posFeaturesWeights, negFeaturesWeights)
% guess whether polarity is 1 (threshold above faces)
% or -1 (threshold below faces)
% probably these should be weighted appropriately
wtdPosFeatures= posFeatures*posFeaturesWeights';
wtdNegFeatures= negFeatures*negFeaturesWeights';
wtdPosMean= wtdPosFeatures / sum(posFeaturesWeights); 
wtdNegMean= wtdNegFeatures / sum(negFeaturesWeights); 
%weightedPosMean= sum(posHist)/length(posHistWeights);
%weightedNegMean= sum(negHist)/length(negHistWeights);
thresh_tst= (wtdPosMean + wtdNegMean)/2; % /2??
%threshold=thresh_tst;
%weightedPosMean= weightedPosHist / sum(posHistWeights);
%weightedNegMean= weightedNegHist / sum(negHistWeights);
if wtdPosMean <= wtdNegMean
    parity= 1;
elseif wtdPosMean > wtdNegMean
    parity= -1;
else
    disp('Problem in findClassifier.m');
end
wtdError=1; %???
opts=optimset('TolX',1e-03,'TolFun',1e-02);    % stop early?
%[threshold, weightedError]= fminsearch(@testClassifier, guessCutoff, opts, parity, posHist, negHist, posHistWeights, negHistWeights);
[threshold, wtdError]= fminsearch(@testClassifier, thresh_tst, [], parity, posFeatures, negFeatures, posFeaturesWeights, negFeaturesWeights);
%sprintf('final %d init %d wtderr %d ',threshold,thresh_tst,wtdError)
%pause