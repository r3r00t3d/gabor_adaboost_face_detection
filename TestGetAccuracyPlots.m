% Accuracy plots - 1 to 3 use a threshold of 1/2 sum(alpha)
% 4 is ROC with variable # of features - contributed by Ivan Laptev
clear variables
clear global
clear functions
threshf=0.5;    % threshold factor
fntsze=7;
PerNonFaceCorrect=[];
PerFaceCorrect=[];
load('images.mat');load('features.mat');
load('TrainResults.mat');
%T=10;
for i=1:T
    x=[cumFaces];
    %f=%a matrix with each column being a feature image 
    %x= % Load images in COLUMN ARRAY FORMAT - want to test to see if it is a face or not;
    %T=% number of best features found in our training program 
    %fNbestArray=% Load in the array with the index of the best features found in training 
    isfacenum=0; isnotfacenum=0;
    numFaces =size(faces,1);
    %    for xNcount=1:numFaces
    %        sum=0;
    %        for t=1:i
    %            fout=x(xNcount,:)*f(:,fNbestArray(t));
    %            if fout*pBestArray(t) < thetaBestArray(t)*pBestArray(t) 
    %                h(t)=1;
    %            else 
    %                h(t)=-1;
    %            end 
    %            sum=sum + alpha_t_Array(t)*h(t);
    %        end
    %        if sum>0
    %            isfacenum=isfacenum+1;%fprintf('IS FACE!\n') 
    %        else 
    %            isnotfacenum=isnotfacenum+1;%fprintf('NO FACE!\n') 
    %        end
    %    end
    
    % vectorised version - two loops - if hit memory limits, may restore a loop?
    fout=x((1:numFaces),:)*f(:,fNbestArray(1:i));    % size-faces by features
    h = fout.*repmat(pBestArray(1:i),numFaces,1) <repmat(thetaBestArray(1:i).*pBestArray(1:i),numFaces,1);
    total = alpha_t_Array(1:i)*h';
    
    isfv=total>threshf*sum(alpha_t_Array(1:i));
    isfacenum=sum(isfv);
    isnotfacenum=-1*sum(isfv-1);
    PerFaceCorrect=[PerFaceCorrect isfacenum/numFaces];
    
    % for non faces
    numNonFaces=size(nonfaces,1);
    x=[cumNonFaces];
    %isfacenum=0; isnotfacenum=0;
    %for xNcount=1:numNonFaces
    %    sum=0;
    %    for t=1:i
    %        %fout=IntegralImageFunction( x , f( : , fNbestArray(t) ) ); %finds the output as a number fout of applyin the feature to image 
    %        fout=x(xNcount,:)*f(:,fNbestArray(t));
    %        if fout*pBestArray(t) < thetaBestArray(t)*pBestArray(t) 
    %            h(t)=1;
    %        else
    %            h(t)=-1;
    %        end
    %        sum=sum + alpha_t_Array(t)* h(t);
    %    end
    %    if sum>0 
    %        isfacenum=isfacenum+1;%fprintf('IS FACE!\n') 
    %    else
    %        isnotfacenum=isnotfacenum+1;%fprintf('NOT FACE!\n') 
    %    end
    %end
    
    % vectorise
    fout=x((1:numNonFaces),:)*f(:,fNbestArray(1:i));    % size-faces by features
    h = fout.*repmat(pBestArray(1:i),numNonFaces,1) <repmat(thetaBestArray(1:i).*pBestArray(1:i),numNonFaces,1); % xNcount x i
    total = alpha_t_Array(1:i)*h';
    
    isfv=total>threshf*sum(alpha_t_Array(1:i));
    isfacenum=sum(isfv);
    isnotfacenum=-1*sum(isfv-1);
    
    PerNonFaceCorrect=[PerNonFaceCorrect 1-isfacenum/numNonFaces];
end
truePos= PerFaceCorrect;
trueNeg= PerNonFaceCorrect;
falsePos= 1 - trueNeg;
PropOfImagesClassedCorrectly= (PerFaceCorrect+PerNonFaceCorrect)./2;
figure;
set(gca,'FontSize',6);
subplot(2,2,1),plot([1:T],1 + -PropOfImagesClassedCorrectly);title('all images');
xlabel('# features'); ylabel('P(error)');set(gca,'FontSize',fntsze);

subplot(2,2,2),plot([1:T],1 + -PerFaceCorrect);title('faces');
xlabel('# features');ylabel('P(error)');set(gca,'FontSize',fntsze);
subplot(2,2,3),plot([1:T],1 + -PerNonFaceCorrect);title('non faces');
xlabel('# features'); ylabel('P(error)'); set(gca,'FontSize',fntsze);

%subplot(2,2,4),plot(falsePos, truePos, '*-');title('ROC curve:');
%xlabel('P(true pos) vs P(false pos)');

% ROC curve by Ivan Laptev - commented by TL
x=[cumFaces; cumNonFaces];
indfaces=1:size(cumFaces,1);
indnonfaces=size(cumFaces,1)+(1:size(cumNonFaces,1));
thrfactor=linspace(.2,3,20);    % list of thresholds
v1=ones(size(x,1),1);           % to make scalar same size as matrix

fstep=5;        % step thru features
legn='';hold off    % for legend
colorsel ='krygbmcb';               % # colours
%for i=length(fNbestArray):-fstep:1   % number of features
for i=1:fstep:length(fNbestArray)   % number of features
    fout=x*f(:,fNbestArray(1:i));   % face AND nonface feature values 
    tp=[]; fp=[];
    for j=1:length(thrfactor)       % each threshold
        h=fout.*(v1*pBestArray(1:i))<thrfactor(j)*v1*(thetaBestArray(1:i).*pBestArray(1:i));
        h=round(2*(h-.5))*transpose(alpha_t_Array(1:i));
        tp(j)=mean(h(indfaces)>0);  % these are faces - count and normalize
        fp(j)=mean(h(indnonfaces)>0);   % nonfaces incorrectly id
    end
    %subplot(2,2,4),plot(fp, tp, '-');hold on;
    subplot(2,2,4),plot(fp, tp, colorsel(mod(i,8)+1));hold on;
    legn=[legn '''' '# feats ' num2str(i) '''' ','];
end
title('ROC curve:');
ylabel('P(true pos)');
xlabel('P(false pos)');
% table of # features
fv=[1:fstep:length(fNbestArray)];   % # features
legn=[legn '4'];
set(gca,'FontSize',fntsze);
eval(['legend(' legn ')']);           % invoke legend
%text(0.5,0.75,'# features');