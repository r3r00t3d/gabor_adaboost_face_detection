function [F, Fidx, Pidx] = simpleboxeszero(nI,nJ);
% create set of features which are the coords of various sizes of rectangle
% in patch of image, nI, nJ in size
sidx = 0;   % serial number of feature
% allocate sparse matrix
nI = nI+1;nJ=nJ+1;              % integral image considerations
% Create matrix - increasing numbers in a column [1 2 3...; 25 26 27...;]
Pidx = reshape(1:nI*nJ,nI,nJ);  % convert 2D into 1D
% Fidx - will hold an index pointing to F. To reach it, specify:
%   a PAIR of r,c coords representing the top left/bottom right of a rectangle.
%   EACH r,c coord is converted into r*nI+J 1D form. So two Fidx entries will point to F.
Fidx = zeros(nI*nJ,nI*nJ);
% F - each col is vector -  AT the coords of corners, has values of coeffs
F = sparse([],[],[],nI*nJ,nI*nJ,ceil(nI*nJ/2));
for rs = 1:nI       % size of rect - row
    for cs = 1:nJ       % and col
        % translate rects of size rs&cs across ALL positions in patch
        for ctl = 1: nJ-cs    % coords of top left col
            for rtl = 1: nI-rs    % & row
                sidx=sidx+1;
                cbr = ctl + cs;     % bottom right col
                rbr = rtl + rs;     % and row
                %sprintf('TL %d %d BR %d %d Pidx %d %d', rtl,ctl,rbr,cbr,Pidx(rtl,ctl),Pidx(rbr,cbr))
                Fidx(Pidx(rtl,ctl),Pidx(rbr,cbr)) = sidx;
                % coeffs to +/-
                F(Pidx(rtl,ctl),sidx)=1;    % top left
                F(Pidx(rbr,ctl),sidx)=-1;   % bottom left
                F(Pidx(rtl,cbr),sidx)=-1;   % and right
                F(Pidx(rbr,cbr),sidx)=1;   % and right
            end
        end
    end
end
% rect size translates
% 1x1 = 1,1 -> 24,24    2x1 = 1,1 -> 23,24
% 1x2 = 1,1 -> 24,23    2x2 = 1,1 -> 23,23
%