global cropsize     % all images use this size
cropsize=24;
while 1
    disp('Adaboost demo - Select an option');
    disp('1. Create list of faces/nonfaces');
    disp('2. Read in and normalize images');
    disp('3. Create features');
    disp('4. Display features');
    disp('5. Train features');
    disp('6. Accuracy Plots');
    disp('7. Test Face Detector');
    sel=input('Select an option - no input quits: ');
    if isempty(sel) 
        return;
    end;
    switch sel
        case 1
            makelist;   % create list of files
            continue;
        case 2
            ReadImageFile;
            continue;
        case 3
            makeImagesF;
        case 4
            displayFG;
        case 5
            TrainAdaB;
        case 6
            TestGetAccuracyPlots;
        case 7
            FaceDetector;
    end
end
