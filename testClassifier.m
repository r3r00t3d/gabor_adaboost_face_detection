%function weightedError = testClassifier(thresh,parity,posHist,negHist,posWts,negWts)
function weightedError = testClassifier(varargin)
theta = varargin{1};
parity = varargin{2};
posHist = varargin{3};
negHist = varargin{4};
posWts = varargin{5};
negWts = varargin{6};
weightedError = abs((theta - posHist)*posWts'*parity);
%weightedError = abs(theta - sum(posHist)/length(posWts));
% negative samples -
weightedError = weightedError + abs((theta - negHist)*negWts'*parity);
%weightedError = weightedError + abs(theta - sum(negHist)/length(negWts));

%if weightedError < 0    % try abs, not squared?
%    weightedError = -weightedError;
%end
%sprintf('theta err %d %d',theta,weightedError)
%pause
