clear variables
clear global
clear functions
close all;
threshf=0.3;    % threshold factor
PerNonFaceCorrect=[];
PerFaceCorrect=[];
load('images.mat');load('features.mat');
load('TrainResults.mat');
T=2;
%Fst=1;Fen=T;
Fst=8;Fen=11;
for i=Fst:Fen
    x=[cumFaces];
    %f=%a matrix with each column being a feature image 
    %x= % Load images in COLUMN ARRAY FORMAT - want to test to see if it is a face or not;
    %T=% number of best features found in our training program 
    %fNbestArray=% Load in the array with the index of the best features found in training 
    isfacenum=0; isnotfacenum=0;
    numFaces =size(faces,1);
    for xNcount=1:numFaces
        total=0;
        for t=1:i
            fout=x(xNcount,:)*f(:,fNbestArray(t));
            if fout*pBestArray(t) < thetaBestArray(t)*pBestArray(t) 
                h(t)=1;
            else 
                %h(t)=-1;
                h(t)=0;
            end 
            total=total + alpha_t_Array(t)*h(t);
        end
        %if sum>0
        if total>threshf*sum(alpha_t_Array(1:i)); 
            isfacenum=isfacenum+1;%fprintf('IS FACE!\n') 
        else 
            isnotfacenum=isnotfacenum+1;%fprintf('NO FACE!\n') 
        end
    end
    PerFaceCorrect=[PerFaceCorrect isfacenum/numFaces];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    x=[cumNonFaces];%x=[cumFaces ; cumNoise];%a matrix with each column being one of the test images
    %f=%a matrix with each column being a feature image
    %x= % Load in the image (MUST BE IN COLUMN ARRAY FORMAT!!!) we want to
    %test to see if it is a face or not;
    %T=% number of best features found in our training program 
    %fNbestArray=% Load in the array with the index of the best features found in training 
    isfacenum=0; isnotfacenum=0;
    numNonFaces=size(nonfaces,1);
    for xNcount=1:numNonFaces
        total=0;
        for t=1:i
            %fout=IntegralImageFunction( x , f( : , fNbestArray(t) ) ); %finds the output as a number fout of applyin the feature to image 
            fout=x(xNcount,:)*f(:,fNbestArray(t));
            if fout*pBestArray(t) < thetaBestArray(t)*pBestArray(t) 
                h(t)=1;
            else
                %h(t)=-1;
                h(t)=0;
            end
            total=total + alpha_t_Array(t)* h(t);
        end
        %if sum>0 
        if total>threshf*sum(alpha_t_Array(1:i)); 
            isfacenum=isfacenum+1;%fprintf('IS FACE!\n') 
        else
            isnotfacenum=isnotfacenum+1;%fprintf('NOT FACE!\n') 
        end
    end
    PerNonFaceCorrect=[PerNonFaceCorrect 1-isfacenum/numNonFaces];
end
truePos= PerFaceCorrect;
trueNeg= PerNonFaceCorrect;
falsePos= 1 - trueNeg;
PropOfImagesClassedCorrectly= (PerFaceCorrect+PerNonFaceCorrect)./2;
figure;
%subplot(2,2,1),plot([1:T],1 + -PropOfImagesClassedCorrectly);title('all images');
subplot(2,2,1),plot([Fst:Fen],1 + -PropOfImagesClassedCorrectly);title('all images');
xlabel('# features');
ylabel('P(error)');
%subplot(2,2,2),plot([1:T],1 + -PerFaceCorrect);title('faces');
subplot(2,2,2),plot([Fst:Fen],1 + -PerFaceCorrect);title('faces');
xlabel('# features');
ylabel('P(error)');
%subplot(2,2,3),plot([1:T],1 + -PerNonFaceCorrect);title('non faces');
subplot(2,2,3),plot([Fst:Fen],1 + -PerNonFaceCorrect);title('non faces');
xlabel('# features');
ylabel('P(error)');
subplot(2,2,4),plot(falsePos, truePos, '*-');title('ROC curve:');
subplot(2,2,4),plot(falsePos, truePos, '*-');title('ROC curve:');
xlabel('P(true pos) vs P(false pos)');
%disp([PerFaceCorrect  PerNonFaceCorrect])
sprintf('%4.3f %4.3f ',PerFaceCorrect)
sprintf('%4.3f %4.3f ', falsePos)