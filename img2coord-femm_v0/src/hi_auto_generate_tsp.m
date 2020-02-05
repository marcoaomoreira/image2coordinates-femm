function hi_auto_generate_tsp(image,convert,femm_path)

RGB = image;

ajuste = convert;

[rows, columns, numberOfColorChannels] = size(RGB);

if numberOfColorChannels > 1
	% Do the conversion using standard book formula
	I = rgb2gray(RGB);
    sharphened_image = imsharpen(I,'Amount', 1,'Radius', 2, 'Threshold', 0);
    bw = imbinarize(sharphened_image);

    bw = bwareaopen(bw,30);
    BW2 = imcomplement(bw);
    iterations = 100;
    BW3 = activecontour(I, BW2, iterations, 'Chan-Vese');
    %remove all object containing fewer than 30 pixels
    %figure(5)
    % fill a gap in the pen's cap
    se = strel('disk',3);
    BW2 = imclose(BW3,se);
    
else
    I=RGB;
    BW2=I;
end

% fill a gap in the pen's cap
se = strel('disk',3);
BW2 = imclose(BW2,se);

BW2 = imrotate(BW2,270);

addpath(femm_path); 
openfemm;
newdocument(2);
hi_probdef('millimeters', 'planar', 1.e-8, 0, 30);

Maior = zeros(2);
Menor = zeros(2);

boundaries = bwboundaries(BW2);
numberOfBoundaries = size(boundaries, 1);

for k = 1 : numberOfBoundaries
    
    firstBoundary = boundaries{k};
    x = firstBoundary(:, 2);
    y = firstBoundary(:, 1);
        
    T = firstBoundary;
    
    userConfig = struct('xy',T,'showProg',false,'showResult',false,'showWaitbar',false);
    resultStruct = tsp_nn(userConfig);
    tt = size(resultStruct.optRoute);
        for i=1:tt(1,2)
            T1(i,1) = T(resultStruct.optRoute(1,i),1);
            T1(i,2) = T(resultStruct.optRoute(1,i),2);
        end
    T1 = [T1(:,1) T1(:,2);T1(1,1) T1(1,2)];
      
    P = T1*ajuste;
    
    ma = max(P);
    Maior = [Maior;ma];
    me = min(P);
    Menor = [Menor;me];
    hi_drawpolygon(P);
    
    T = [];
    T1 = [];
end

maior2 = max(Maior)*1.1;
menor2 = min(Menor)*1.1;
ymaior = maior2(1,2);
xmaior = maior2(1,1);
ymenor = menor2(1,2);
xmenor = menor2(1,1);
hi_drawrectangle(xmaior,ymaior,xmenor,ymenor)
%close all
[pathstr,name,ext]=fileparts(mfilename('fullpath'));
addpath(genpath(pathstr));
hi_saveas([pathstr,'\Filename.FEC']) 
hi_createmesh;