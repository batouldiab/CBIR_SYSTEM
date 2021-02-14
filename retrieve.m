function [ similarityValues,  euclideanDistances, fileNames] = retrieve( I, itspath, imageFolder )
    %RETRIEVE Summary of this function goes here
    % Detailed explanation goes here
    % gabor filter arguments
    gamma=0.3; %aspect ratio
    psi=0; %phase
    theta=90; %orientation
    bw=2.8; %bandwidth or effective width
    lambda=3.5; % wavelength
    pi=180;
          
    % images are resized before any form of processing
    % desired resolution of the resized image
    resolution = [540; 540];

    % Filtering Selections from user
    % 1 = color histogram, 2 = gabor
    firstPassFilter = 1;
    secondPassFilter = 2;
    thirdPassFilter = 3;

    % Similarity threshold input from user
    firstPassSimilarityThreshold = 0.3;
    secondPassSimilarityThreshold = 0.4;
    thirdPassSimilarityThreshold = 0.4;

    % query input image from user 
    queryimg = I;
    queryimg = imresize(queryimg,[resolution(1,:) resolution(2,:)]); % resize query image

    % getting HSV color histogram for the query image
    colorHistQuery = colorHistogram(queryimg,itspath);

    % Getting the mean and standard Gabor feature vectors for the query image
    gaborQuery = myGabor(queryimg, gamma, psi, theta, bw, lambda, pi);
    gaborMeanQuery = mean(gaborQuery);
    gaborStdQuery = std(gaborQuery);

    [ animalsImageSet, numberOfFiles ,fullFileNames] = getImages(imageFolder);
    % Initialising arrays: 
    %       euclideanDistances - All Euclidean Value Distance Results
    %       similarityValues   - All Similarity values, min=0 max=1
    % col 1: color histogram values
    % col 2: gabor filter mean values
    % col 3: gabor filter standard deviation values
    % col 4: sum of values
    euclideanDistances = zeros(numberOfFiles, 4);
    similarityValues = zeros(numberOfFiles, 4);
    
    maxDist1=0;
    maxDist2=0;
    maxDist3=0;
    maxDist4=0;

    % Initialising list of filenames
    fileNames = {};

    % loops each image file on the dataset
    % computes color histogram + gabor mean + gabor standard deviation features
    % calculates euclidean distances of each image with the query image
    for ii=1:numberOfFiles
        % get current file name, read current image
        currentimage = imread(animalsImageSet.Files{ii});
        currentfilename= fullFileNames{ii};
        
        currentInfo = imfinfo(currentfilename);
        currentFileFormat = currentInfo.Format;
        
        % update file names row
        fileNames = [fileNames; currentfilename];

        % resizing curr image to a standard resolution
        currentimage = imresize(currentimage,[resolution(1,:) resolution(2,:)]);
        [rows, cols, numOfBands] = size(currentimage);

        if numOfBands == 1
            disp(numOfBands);
            currentimage = grs2rgb(currentimage);
            imshow(currentimage);
            [rows,cols,numOfC] = size(currentimage);
            disp(numOfC);
        end 

        % Calculate euclidean distance with color histogram
        colorHistCurrent = colorHistogram(currentimage,currentfilename);
        colorDist = euclideanDistance(colorHistQuery, colorHistCurrent);
        euclideanDistances(ii, 1) = colorDist;

        % Calculate euclidean distances for mean and
        % standard deviation of Gabor filter
        currentGabor = myGabor(currentimage, gamma, psi, theta, bw, lambda, pi);
        currentGaborMean = mean(currentGabor);
        currentGaborStd = std(currentGabor);
        resultMean = euclideanDistance(gaborMeanQuery, currentGaborMean);
        resultStd = euclideanDistance(gaborStdQuery, currentGaborStd);
        euclideanDistances(ii, 2) = resultMean;
        euclideanDistances(ii, 3) = resultStd;
        
        if(colorDist>maxDist1)
            maxDist1=colorDist;
        end
        if(resultMean>maxDist2)
            maxDist2=resultMean;
        end
        if(resultStd>maxDist3)
            maxDist3=resultStd;
        end
		
    end
	

    %%%PASS SIMILARITY CALCULATION

    % getting highest EuclideanDist value as the benchmark for 0% similarity
    % a Euclidean Distance of 0 will be considered 100% similarity
    
    len = length(euclideanDistances);
    
    %filter 1
    % Computing similarity values for sum filter pass
    for ii = 1:len
        eDist = euclideanDistances(ii,firstPassFilter);
        result =  (eDist/maxDist1);
        similarityValues(ii,firstPassFilter) = result;
    end
    
    %filter 2
    % Computing similarity values for sum filter pass
    for ii = 1:len
        eDist = euclideanDistances(ii,secondPassFilter);
        result = (eDist/maxDist2);
        similarityValues(ii,secondPassFilter) = result;
    end
    
    %filter 3
    % Computing similarity values for sum filter pass
    for ii = 1:len
        eDist = euclideanDistances(ii,thirdPassFilter);
        result = (eDist/maxDist3);
        similarityValues(ii,thirdPassFilter) = result;
    end
    
    rate1=0.5;
    rate2=0.2;
    rate3=0.3;
    %SUM
    for ii = 1:len
        eDist = rate1 *similarityValues(ii,firstPassFilter)+ rate2 *similarityValues(ii,secondPassFilter)+ rate3 *similarityValues(ii,thirdPassFilter);
        similarityValues(ii,4)= eDist;
    end    
     
    % sort by similaruty distance of sum, most similar images first
    [similarityValues, sortedIndexes] = sortrows(similarityValues,4);

    % sorting fileNames array accordingly 
    % (no need to sort SimilarityValues because it is still filled with zeroes)
    len = length(euclideanDistances);
    newFileNames = {};
    for ii = 1:len
        newFileNames = [newFileNames; fileNames(sortedIndexes(ii,1),1)];
    end
    fileNames = newFileNames;
    
    close all;

end

