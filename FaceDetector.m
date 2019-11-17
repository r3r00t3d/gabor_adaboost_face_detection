clear variables
load('features.mat'); 
%load('images.mat'); 
load('TrainResults.mat'); 
[imgtst, pathname] = uigetfile('*.*', 'Select image file');
Itest=imread([pathname imgtst]);
Itest=imcrop(Itest); % ############TAKE OUT IN GENERAL CASE 
%figure,imshow(Itest);
if length(size(Itest)) > 2 
    Itest=rgb2gray(Itest);
end
%T=9;
figure,imshow(Itest);
Itest=double(Itest);
%Itest= normImageF(Itest);	% normalize here is wrong, but sometimes get better results!
figure,imshow(Itest,[]);
%%%%%%%%%%%%%%%%%%%%%%%% 
% TAKE repeated chunk out of image FUNCTION GOES HERE 
[row col]=size(Itest);
mindim=min(row,col);
cropsize=24;
patchi=24;
patchsize=24*24;
patchsizepad=25*25;
alpha_thresh = 2.+sum(alpha_t_Array(1:T))/2; % threshold
isfacenum = 0;
isnfacenum = 0;

% create directories to hold the testing results
if exist('test_positives') == 7
    delete test_positives\*.*
else
    mkdir test_positives
end

if exist('test_negatives') == 7
    delete test_negatives\*.*
else
    mkdir test_negatives
end

% detect
for psize = 24:6:mindim %# PLAY WITH THIS ######################## 
    for xplace=1:10:col-psize
        for yplace=1:10:row-psize
            %%%%%%%%%%%%%%%%%%%%%%% 
            [Ichunk, rect]=imcrop(Itest,[xplace yplace psize psize]); %[xmin ymin width height] 
            Ichunkoriginal=Ichunk;
            Ichunk=imresize(Ichunk,[cropsize,cropsize]);

            Ichunk=normImageF(Ichunk);	% may slow down processing...
            
            Ichunk=reshape(Ichunk,1,cropsize*cropsize);
            Ichunk= padJN(Ichunk);
            Ichunk=cumImageJN(Ichunk);
            x=Ichunk;
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
                % save the image in the test positives directory
                saveImage = uint8(Ichunkoriginal);
                imwrite(imresize(saveImage,[cropsize,cropsize]), ['test_positives\' sprintf('%d',isfacenum) '.bmp']);
                                
                %fprintf('IS FACE!\n'); 
                disp(sum_det);
                rectangle('Position',rect,'edgecolor','red');drawnow;
            else
                isnfacenum = isnfacenum + 1;
                
                % save the image in the test positives directory
                saveImage = uint8(Ichunkoriginal);
                imwrite(imresize(saveImage,[cropsize,cropsize]), ['test_negatives\' sprintf('%d',isnfacenum) '.bmp']);
                
                %isnotfacenum=isnotfacenum+1; 
                %fprintf('NO FACE!\n') 
            end
        end
    end
end % SIZE if
