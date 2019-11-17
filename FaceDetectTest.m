% implement sum of variance
clear variables
load('features.mat'); 
%load('images.mat'); 
load('TrainResults.mat'); 
[imgtst, pathname] = uigetfile('*.*', 'Select image file');
%Itest=imread([pathname imgtst]);
%Itest=imcrop(Itest); % ############TAKE OUT IN GENERAL CASE 
%figure,imshow(Itest);
%if length(size(Itest)) > 2 
%    Itest=rgb2gray(Itest);
%end
%T=75;
Itest = ones(30,30);
[trow tcol]=size(Itest);
pItest = zeros(trow+1, tcol+1);   % add zero row/col
pItest(2:end, 2:end)= Itest;
pItestS=pItest.*pItest;

pIItest = cumsum(cumsum(pItest,1),2);    % II of original
pIItestS= cumsum(cumsum(pItestS,1),2);   % II of squared
clear pItest, pItestS;

%figure,imshow(Itest);
%Itest=double(Itest);

%figure,imshow(Itest,[]);
%%%%%%%%%%%%%%%%%%%%%%%% 
% TAKE repeated chunk out of image FUNCTION GOES HERE 

mindim=min(trow,tcol);
cropsize=24;
psize=24;
patchsize=24*24;
patchsizepad=25*25;
alpha_thresh = (alpha_t_Array(1:T))/2; % threshold
isfacenum=0;
for psize = 24:6:mindim %# PLAY WITH THIS ######################## 
    for prw=2:1:tcol-psize
        for pcl=2:1:trow-psize
            % mean of box - top left - bot left + top right - bot right
            meanbox=-pIItest(prw,pcl)+pIItest(prw,pcl+psize)-pIItest(prw+psize,pcl)+pIItest(prw+psize,pcl+psize)
%            meanbox=pIItest(prw,pcl) - pIItest(prw,pcl+psize)...
%                +pIItest(prw+psize,pcl) - pIItest(prw+psize,pcl+psize);
            rect = [prw pcl psize psize];
            x=pIItest([prw:prw+psize], [pcl:pcl+psize]);     % crop of II
            x=x(:)';  % vector it
            sum_det=0;
            i=T;
            for t=1:i
                fout=x*f(:,fNbestArray(t));
                if fout*pBestArray(t) < thetaBestArray(t)*pBestArray(t)
                    h(t)=1;
                else
                    %h(t)=-1;
                    h(t)=0;
                end
                sum_det=sum_det + alpha_t_Array(t) * h(t);
            end
            %if sum_det>4.6
            if sum_det>alpha_thresh
                isfacenum=isfacenum+1;
                %fprintf('IS FACE!\n'); 
                disp(sum_det);
                rectangle('Position',rect,'edgecolor','red');drawnow;
            else
                %isnotfacenum=isnotfacenum+1; 
                %fprintf('NO FACE!\n') 
            end
        end
    end
end % SIZE if