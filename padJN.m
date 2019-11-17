function I= padJN(preI) 
% takes a face image in as a column vector 
% and returns it as a vector where it's been padded 
% with an extra left column and top row as zeros 
length= max(size(preI));
side= length.^.5 ;
preI= reshape(preI,side,side) ;
bigI= zeros(side+1, side+1) ;
bigI(2:end, 2:end)= preI ;
I= reshape(bigI, 1, (side+1)^2) ;