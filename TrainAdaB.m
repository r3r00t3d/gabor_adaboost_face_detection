%clear variables ; clear global ;clear functions
msghdr='Debug V&J threshold use w/sum(w)abs';
load('images.mat');
load('features.mat');

x=[cumFaces; cumNonFaces];    % matrix with each row being one of the test images
nFaces=size(cumFaces,1);nNonFaces=size(cumNonFaces,1);
sprintf('# faces %d, # nonfaces %d',nFaces,nNonFaces)
disp('Prompting for number of iterations - can take a long time...')
T=10;
sel=input(['Current # iterations is ' num2str(T) '. Enter new/leave blank '],'s');
if ~isempty(sel)
    if sum(isletter(sel))>0 % letters - garbage!
        disp('Numbers please!');
        return
    else
        T=str2double(sel);
    end
end;

tic
% input:
% 'faces', 'cumFaces', 'noisePics', 'cumNoise', 'xN'
patchi=24; % CHANGE THIS FOR SMALLER IMAGE WINDOWS
fpath=which(mfilename);pathMF = fpath(1:findstr(upper(mfilename),upper(fpath))-1);
fNbest=0;
wface=1/(2*nFaces);       % init weights as per V&J IJCV 2k4
wnonface=1/(2*nNonFaces);
% weights array - size xN, wface if x is a face, wnoneface if x is nonface
w=[wface*ones(1,nFaces) wnonface*ones(1,nNonFaces)]; % form a weight vector
%xN=%number of images
faces=[];
nofaces=[];
fN=size(f,2);   % num of features
thetaArray=zeros(1,fN); %thetaArray=[];
pArray=zeros(1,fN);     %pArray=[];
loopn = fN;

y=[ones(1,nFaces) zeros(1,nNonFaces)];  % 1/0 for face/nonface - same pos as wts
fNbestArray=[];
alpha_t_Array=[];
minErrorArray=[];
thetaBestArray=[];
pBestArray=[];
[fid msg]=fopen([pathMF 'trg_res.txt'],'a');     %store in text file
clk=clock;
fprintf(fid,'--%s %d:%d %s\r\n',date,clk(4),clk(5),msghdr);
fclose(fid);

h=zeros(1,nFaces+nNonFaces);
count=0; errcond = 0;   % for all kinds of strange errorss
for t=1:T
    % Normalize weights
    w=w/sum(w);
    %w(1:nFaces)=w(1:nFaces)./(2*sum(w(1:nFaces)));
    %w(nFaces+1:end)=w(nFaces+1:end)./(2*sum(w(nFaces+1:end)));
    minError= inf;
    [fid msg]=fopen([pathMF 'trg_res.txt'],'a');     %store in text file
    tm=cputime;
    disp(sprintf('initial time: %d', tm));
    for fNcount=1:loopn     % set to fN
        fout=x*f(:,fNcount);        % feature value for all samples - vectorise s.t. NO for-loops
        faces = fout(find(y==1))';   % face features
        nonfaces=fout(find(y==0))';   % nonface features: was y==-1
        % use according to V&J 2k4
        [theta,p,weightedError]= findThreshold(fout,w(1:nFaces),w(nFaces+1:end));
        %[theta,p,weightedError]= findClassifier(faces,nonfaces,w(1:nFaces),w(nFaces+1:end));
        
        %Check if x is classified correctly
        posComp = fout*p < theta*p;
        %h(find(temp==1))=1;
        err_classify = xor(posComp',y);   % is abs{h-y) - faster?
        Error= err_classify*w';          % dot product, since both are vectors
        % if lower error, take note       
        if Error < minError
            minError = Error;
            fNbest = fNcount;
            thetaBest = theta;
            pBest = p;
            misclassify_vec = err_classify;
            % keep track for later use - remove when problem fixed
            if p > 0
                featAMax = min(fout);
            else
                featAMax = max(fout);
            end
        end
        
        if mod(fNcount,100)==0
            disp(sprintf('1 Feat # %d iter %d',fNcount,t));
            disp(sprintf('time: %d', cputime-tm));
        end
    end
    
    beta_t =  (minError+0.000001)/(1-minError); % prevent minError from zero
    alpha_t = -log(beta_t);             % 1/beta
    w=w.*beta_t.^(1 - misclassify_vec);     % reduce weight if correct
    
    % THIS IS A KLUDGE - MAKE SURE THETA NOT NEAR LIMITS!!!
    % threshold should be far from a MAXIMUM FEATURE VALUE
    % ignore this iteration, but continue to use the updated weights
    % Also, was this feature used before?
    % Not sure if we will ever get stuck - and ignore the rest of
    % the iterations from hereon - check if BOTH conditions occur
   if (thetaBest*pBest < featAMax*pBest/3)
        fprintf(fid,'??Threshold high: %4.1f feature#%d @ %d\r\n',thetaBest,fNbest,t);
        %errcond=1;     % if want to skip, uncomment
    end
    % if repeat feature, see if threshold the same
    if (sum(fNbest == fNbestArray) >0)
        thetatst = thetaBestArray(find(fNbest == fNbestArray)); % get same features
        if (sum(thetaBest == thetatst) >0)                      % if same threshold
            fprintf(fid,'??Repeat feature #%d @ %d\r\n',fNbest,t);
            errcond=1;          % print and skip
        end
    end

    if ~errcond
        count = count+1;    % how many were actually generated
        fNbestArray=[fNbestArray fNbest];
        minErrorArray=[minErrorArray minError];
        thetaBestArray=[thetaBestArray thetaBest];
        alpha_t_Array=[alpha_t_Array alpha_t];
        pBestArray=[pBestArray pBest];
        fprintf(fid,'%4.0f %4.2f %3.3f \r\n',fNbest, thetaBest, minError);
        sprintf('%4.0f %4.2f %3.3f \r\n',fNbest, thetaBest, minError);
    end
    if errcond
        errcond=0;  % reset error indicator
    end
    fclose(fid);
    ttoc=toc;
    disp(sprintf('ttoc = ', ttoc));
end % for t=1:T
T=count;
clk=clock;

[fid msg]=fopen([pathMF 'trg_res.txt'],'a');     %store in text file
fprintf(fid,'--%s %d:%d %s\r\n',date,clk(4),clk(5),'End of Run');
fclose(fid);

% box=DisplayFeature(patchi,patchi,f(:,fNbest));
% imshow(box,[])
% title(['feature ' num2str(fNbest)]);
% drawnow;

save([pathMF 'TrainResults.mat'], 'fNbestArray','thetaBestArray','pBestArray','alpha_t_Array','T');
