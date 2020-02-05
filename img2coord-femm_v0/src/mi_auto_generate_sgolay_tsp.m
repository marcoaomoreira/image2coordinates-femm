function mi_auto_generate_sgolay_tsp(image,convert,femm_path)

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
newdocument(0);
mi_probdef(0, 'millimeters', 'planar', 1.e-8, 0, 30);

Maior = zeros(2);
Menor = zeros(2);

boundaries = bwboundaries(BW2);
numberOfBoundaries = size(boundaries, 1);

    for k = 1 : numberOfBoundaries

        firstBoundary = boundaries{k};
        x = firstBoundary(:, 2);
        y = firstBoundary(:, 1);
        windowWidth = 45;
        polynomialOrder = 3;

         if size(x,1)< windowWidth && size(x,1)<3 %Checking if framelen is bigger then size of the matrix
            windowWidth = size(x,1);
            if rem (size(x,1),2)~=0
                polynomialOrder = windowWidth;
            elseif rem (size(x,1),2)==0
                windowWidth = size(x,1)-1;
                polynomialOrder = windowWidth-1;
                if windowWidth <=0
                    windowWidth = 1;
                    polynomialOrder = 0;
                end

            end
        elseif size(x,1)< windowWidth && size(x,1)>3
            windowWidth = size(x,1);
            if rem (size(x,1),2)~=0
              windowWidth = size(x,1);
            elseif rem (size(x,1),2)==0
                windowWidth = size(x,1)-1;
                if windowWidth <=0
                    windowWidth = 1;
                end

            end
        end


        smoothX = sgolayfilt(x, polynomialOrder, windowWidth);
        smoothY = sgolayfilt(y, polynomialOrder, windowWidth);
        T = sgolayfilt(firstBoundary, polynomialOrder, windowWidth);

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
        mi_drawpolygon(P);

        T = [];
        T1 = [];
    end
    

maior2 = max(Maior)*1.1;
menor2 = min(Menor)*1.1;
ymaior = maior2(1,2);
xmaior = maior2(1,1);
ymenor = menor2(1,2);
xmenor = menor2(1,1);
mi_drawrectangle(xmaior,ymaior,xmenor,ymenor)
%close all
[pathstr,name,ext]=fileparts(mfilename('fullpath'));
addpath(genpath(pathstr));
mi_saveas([pathstr,'\Filename.FEC']) 
mi_createmesh;
end