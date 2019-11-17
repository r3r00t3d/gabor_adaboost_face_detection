function I= cumImageJN(preI) 
% takes a 1x2^N face 
% interprets it as a NxN face 
% gets a cumsum image 
% returns it with original 1x100 or 1x121 dimensions 
% 
numPix= max(size(preI));
side= numPix ^ .5 ; 

% creates a NxN image
preI= reshape(preI,side,side);

% create a cumulative sum on dimension 1 and afterwards on dim 2
preI= cumsum(cumsum(preI,1),2);

% convert it into a vector
I= reshape(preI,1,numPix);
