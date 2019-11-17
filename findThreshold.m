function [threshold, parity, wtdError]= findClassifier(featval, posFeatureWeights, negFeatureWeights)
% Uses V&J algorithm in IJCV 2004
[allfeats afidx]= sort(featval);    % sort all feature values
maxidxPos=length(posFeatureWeights);

% weights with indices <=length(posFeatureWeights) are from POSITIVE examples
allWeights = [posFeatureWeights negFeatureWeights];
Tp=sum(posFeatureWeights);Tn=sum(negFeatureWeights);
afl = length(allfeats);
e=zeros(1,afl); e(1)=min(Tp,Tn);
SpA=0;SnA=0;    %1st entry is zero

% Standard way as per algorithm description
%for i=2:afl    % for each feature value i+1, until end!
%    % BELOW this feature -
%    % find indices of weights of POSITIVE examples
%    idxs=afidx(1:i-1)<=length(posFeatureWeights);    % 1 -> indices in POSITIVE examples
%    idx = [idxs' -1*ones(1,afl-i+1)];     % maintain length of idx vector! Pad with dummy
%    Sp=sum(allWeights(afidx(find(idx==1)))); % 
%    % find indices of weights of NEGATIVE examples
%    Sn=sum(allWeights(afidx(find(idx==0))));        %  0 -> indices in NEGATIVE examples
%    e(i) = min(Sp+(Tn-Sn),Sn+(Tp-Sp)); % error
%    SnA = [SnA Sn];SpA=[SpA Sp];
%end

% alternative vectorised calculation
afidxs=afidx(1:end);    % all weights
Ppos=afidxs<=length(posFeatureWeights); % 1 in vector indicates POSITIVE example
Npos=afidxs>length(posFeatureWeights);  % ditto for NEGATIVE examples

Pwts=Ppos.*allWeights(afidxs)';         % multiply, ready for adding
Nwts=Npos.*allWeights(afidxs)';

Snn = cumsum([0 Nwts(1:end-1)']);    % cumulative sum from end of vector
Spp = cumsum([0 Pwts(1:end-1)']);    % e.g. sum of positive wts FROM 1:end, 2:end, etc

Poserr = Spp + Tn - Snn;
Negerr = Snn + Tp - Spp;
earray = min(Poserr,Negerr);              % minimum error between two
%[earray parray]=min([Poserr; Negerr],[],1);
[wtdError idx]=min(earray);

if idx ==1
    threshold = featval(afidx(idx));    % can't go to previous!
else
    threshold = (featval(afidx(idx))+featval(afidx(idx-1)))/2;  % take average
end

%[wtdError1 idx1]=min(e);       % for slower method - check e is NOT end-1!
%threshold1 = featval(afidx(idx1));

%%if threshold ~= threshold1   % compare, using slower method
%if abs(wtdError - wtdError1) > 1e-10
%    disp('Uh oh ... vectorise problem');
%    idx=idx;    
%    pause;
%end

%parity = 1;
%if threshold > 0
%    parity= -1;
%end

if Poserr(idx)<Negerr(idx)
    parity = -1;
else
    parity = 1;
end
%if threshold > 0
%    parity= -1;
%end
%pause
% dump out arrays for debugging
% dbgfmt='%4.2f,%3.0f,%0.5f,%0.5f,%0.5f,%0.5f,%0.5f,%0.5f\r\n'
% fid=fopen('i:dbg.csv','w')
% for j=1:1400
%fprintf(fid,dbgfmt,allfeats(j),afidx(j)<maxidxPos,allWeights(afidx(j)),Spp(j),Snn(j),Poserr(j),Negerr(j),earray(j))
% end