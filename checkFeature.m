function good = checkFeature(F,nI,nJ) 
% verify goodness of a feature 
good = 1;
nI = nI + 1;
nJ = nJ + 1;
[rows,cols] = size(F);
if ~((rows == nI) & (cols == nJ))
    if (cols == 1)
        F = reshape(F,[nI,nJ]);
    end
end
[i j c] = find(F);
% If all zeros, thats bad
if length(c) == 0;
    good = 0;
    return
end
img = zeros(nI,nJ);% A patch sized image 
img(2:end,2:end) = 1;   % borders zero ???
img = cumsum(cumsum(img,1),2);
img = reshape(img,[1,nI*nJ]);
big_img = zeros(nI*2,nJ*2);% A larger sized image 
%-big_img(2:end,2:end) = 1;
big_img(1:end,1:end) = 1;
big_img = cumsum(cumsum(big_img,1),2);
% big_img = reshape(big_img,[1,(nI*2)*(nJ*2)]);
% make sure feature does the same thing for images of different sizes. 
v1 = img * F(:);            % dot product
img = reshape(img,[nI,nJ]); % to 2d image
v11 = 0;
for corner = 1:length(c)    % for all FEATURE corners multiply with image
    v11 = v11 + c(corner) * img(i(corner), j(corner));
end
v2 = 0;
for corner = 1:length(c)    % in larger image - for all FEATURE corners multiply with image
    v2 = v2 + c(corner) * big_img(i(corner) + floor(nI/2), j(corner) + floor(nJ/2));
end
disp(sprintf('Integral Image calculation : %d %d %d', v1,v11,v2));
if v1 ~= v2
    good = 0;
end
return
for i = 1:ci.numClassifiers 
    showWeights(ci,i);
    disp(sprintf('Feature %d goodness: %d',i,checkFeature(ci.F(:,i),24,24) )) 
    pause(1) 
end