function HSVhist = colorHistogram(I, itspath)

[rows, cols, numOfBands] = size(I);

%double checking the pixels of images;
% PixelsOfImage = rows*cols*numOfBands;
% disp(PixelsOfImage);
image = rgb2hsv(I);
%figure, imshow(image);

%Split it into three of the HSV
hueI = image(:,:,1);
saturI = image(:,:,2);
valueI = image(:,:,3);

%equalization of the V value
new_valueI = histeq(valueI);
% figure, imhist(I);

%quantizing each of the HSV
%USing 16x4x4
HSVhist = zeros(16,4,4);

%index column
% index = zeros(rows*cols, 3);

%find the max pixel of the each component
maxH = max(hueI(:));
maxS = max(saturI(:));
maxV = max(new_valueI(:));

for row = 1 : rows
    for col = 1 : cols
        hueBin = floor(hueI(row,col)/maxH * 15.9999)+ 1;
        saturBin = floor(saturI(row,col)/maxS * 3.9999)+ 1;
        valBin = floor(new_valueI(row,col)/maxV * 3.9999)+ 1;
        HSVhist(hueBin, saturBin, valBin) = HSVhist(hueBin, saturBin, valBin) + 1;
    end
end


%normalize the histogram and return an 1x256 feature vector
HSVhist = HSVhist(:);
%HSVhist = HSVhist/sum(HSVhist);

% disp(HSVhist);
% clear;

end
