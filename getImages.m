function [ animalsImageSet, numberOfImages ,fullFileNames] = getImages(imageFolder)
    
    %animalsImageSet = imageDatastore(imageFolder,'LabelSource','foldernames','IncludeSubfolders',true);
    animalsImageSet = imageDatastore(imageFolder,...
    'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames');
    numberOfImages= numel(animalsImageSet.Files);
    %I = imread(animalsImageSet.Files{1});
    %imshow(I);

    fullFileNames = vertcat(animalsImageSet.Files);
    %for k = 1 : length(fullFileNames)
    %    [folder, baseFileNameNoExt, ext] = fileparts(fullFileNames{k});
    %    baseFileNameWithExt = [ baseFileNameNoExt, ext];
    %    fprintf('Base file name #%d = %s\n', k, fullFileNames{k});
    %end

end

