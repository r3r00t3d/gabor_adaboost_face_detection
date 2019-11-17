clear variables

% load the detector cascade variables
load detectorCascade.mat;

% load image file
[imageFilename, pathName] = uigetfile('*.*', 'Select image file');
[testImage testImageMap] = imread([pathName imageFilename]);

testImage = imcrop(testImage); % ############TAKE OUT IN GENERAL CASE 
%figure,imshow(Itest);

% check if image has a colormap
if ~isempty(testImageMap)
    testImage = ind2gray(testImage, testImageMap);
end
    
% convert the image from RGB to rgb
if length(size(testImage)) > 2 
    testImage = rgb2gray(testImage);
end

% Show the detection image
figure,imshow(testImage);
testImage = double(testImage);
figure,imshow(testImage, []);
drawnow

[row col]=size(testImage);
mindim=min(row,col);
cropsize=24;
patchi=24;
patchsize=24*24;
patchsizepad=25*25;

detectedFaces = 0;
detectedNonFaces = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subwindow extraction starting from 24x24 to
% mindim x mindim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for psize = 24:3:mindim
    
    % xplace and yplace are the subewindow coordinates
    for xplace=1:5:col-psize
        for yplace=1:5:row-psize
            
            % extract a subwindow and resize it to [cropsize, cropsize]
            [imageSubwindow, subwindowRect] = imcrop(testImage, [xplace yplace psize psize]); 
            imageSubwindow = imresize(imageSubwindow, [cropsize,cropsize]);
            originalSubWindow = imageSubwindow;
            
            % normalize the image intensities
            imageSubwindow = normImageF(imageSubwindow);	% may slow down processing...
            
            % create a integral image and transform it to one row
            imageSubwindow = reshape(imageSubwindow, 1, cropsize*cropsize);
            imageSubwindow = padJN(imageSubwindow);
            imageSubwindow = cumImageJN(imageSubwindow);
            
            x = imageSubwindow;
            
            %disp('subwindow:');
            %disp(subwindowRect);
            
            
            % go through detection cascade
            for cascadeStepIndex=1:cascadeSize
                
                %disp(sprintf('    cascade: %d',cascadeStepIndex));
                
                % get the number of features used in this cascade step
                i = cascadeHaarFeaturesCount{cascadeStepIndex};
                                
                % calculate the current cascade step detector threshold
                cascadeStepThresh = 2. + sum(cascadeAlphaArray{cascadeStepIndex}(1:i))/2;

                %disp(sprintf('    cascade step thresh: %f', cascadeStepThresh));
                
                % calculate the cascade step sum for the current subwindow
                cascadeStepSum=0;
                for t=1:i

                    fout = x * haarFeatures(:, cascadeStepBestFeatures{cascadeStepIndex}(t));

                    if fout*cascadePBestArray{cascadeStepIndex}(t) < cascadeThetaBestArray{cascadeStepIndex}(t)*cascadePBestArray{cascadeStepIndex}(t)
                        cascadeStepSum = cascadeStepSum + cascadeAlphaArray{cascadeStepIndex}(t);
                    end
                end
                
                %disp(sprintf('    cascade step sum: %f', cascadeStepSum));

                % check the cascade step threshold value
                if cascadeStepSum < cascadeStepThresh
                    detectedNonFaces = detectedNonFaces + 1;

                    % save the image in the test negatives directory
                    %saveImage = uint8(originalSubWindow);
                    %imwrite(imresize(saveImage,[cropsize,cropsize]), ['test_negatives\' sprintf('%d',detectedNonFaces) '.bmp']);

                    % this is not a face so reject this subwindow
                    break;
                end;
                
                %disp('    possible face');
                
                if cascadeStepIndex == cascadeSize
                    % if this is the last cascade step and it says it is a face
                    % WE FOUND A "FACE"
                    detectedFaces = detectedFaces + 1;
                    
                    % save the image in the test positives directory
                    saveImage = uint8(originalSubWindow);
                    imwrite(imresize(saveImage,[cropsize,cropsize]), ['test_positives\' sprintf('%d',detectedFaces) '.bmp']);

                    
                    % place a rectangle around that face
                    rectangle('Position', subwindowRect, 'edgecolor', 'red');
                    drawnow;
                else
                    % place a rectangle around that face
                    %rectangle('Position', subwindowRect, 'edgecolor', 'blue');
                    %drawnow;
                end

            end
            
        end
    end
end
