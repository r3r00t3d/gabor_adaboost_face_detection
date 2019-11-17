function boxen = DisplayFeature(nI,nJ,F, varargin)
% Display feature B within an image of size nIxnJ 
% 
%if (nI~=nJ)
% warning('nI and nJ should be equal');
% return;
%end
nI = nI+1; nJ = nJ + 1;
L = tril(ones(nI,nI));
A = zeros(nI*nJ);
% Create matrix of size (nI*nJ) square. A giant tril, each element is
% a matrix of nI x nJ - which is also a tril. Working - see below
for iv = 1:nJ
    for jv = 1:iv;
        A((nI*(iv-1)+1):nI*iv,(nI*(jv-1)+1):nI*jv) = L;
    end;
end; 
wts = F'*A;
Sb = reshape(wts,[nI,nJ]);
% 1st row and col are missing, "add" them back
 %[r c]=find (S~=0);      % find 1st nonzero element, top/left
 %S(r(1)-1,:)=S(r(1),:);  % reproduce the row "up" by 1
 %S(:,c(1)-1)=S(:,c(1));  % and col "left" by 1
%boxen = S(2:end,2:end);
S=Sb(2:end,2:end);      % trim padding
boxen = S;
if nargin == 4
    ind = find(boxen==0);
    boxen = boxen + varargin{1};
end
%h=get(get(gca,'Parent'));   % look for any existing axes
%set(gca,'Position',get(gca,'Position'));
imshow(0.5*(S+1));
%imshow(boxen,...
% [min(min(avgf)), max(max(avgf))],... 
%'notruesize'); 
%drawnow;
% Each col of A represents an image with the leftmost col being 0's.
% A(:,1) has NONE-i.e. all 1's. Dot product - A(:,1)*F should = 0, by definition of F.
% A(:,2)-1 top row=0; A(:,3)-top 2 rows=0 etc
% A(:,nI+1:2*nI) has 1 left col and so on.
% So for EACH A(:,r+nI...r+2*nI) range, a ROW of 0's will increase.
% This generates a series of rectangles that shrink from TL to BR. 
% So when the FEATURE rectangle is multiplied with A, it is scanned from TL to BR.
% Due to the nature of scanning, dot product is 0 - when the rect:
%  i) Fully covers the feature
% ii) Left edge is in line with feature's.
%  +-------------------+
%  !  1========-1      ! From the example here we see that the 2 and -1 at
%  !  |         |      ! the lower right will produce (2-1)=1 as the rect
%  !  |         |      ! moves from left to right (as per above). 
%  ! -2x[xxxxxxx2......!
%  !  |x[xxxxxxx]......! 
%  !  |x[xxxxxxx]......!
%  !  1=[xxxxxx-1......!
%  !    [..............!
%  !    [..............!
%  +-------------------+
