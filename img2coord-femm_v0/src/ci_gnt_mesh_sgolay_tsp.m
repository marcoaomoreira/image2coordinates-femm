% ----------------------------------------------------------------------------------------------
% | Here is the codes that was used to construct this part of the toolbox.                     |
% | Most of the functions is the OctaveFEMM Toolbox, made by David Meeker                      |
% | All the fuctions used in the code has his own references.                                  |
% | Reference: Image Analyst (2015). Image Segmentation Tutorial                               |
% | https://www.mathworks.com/matlabcentral/fileexchange/25157-image-segmentation-tutorial),   |
% | MATLAB Central File Exchange. Retrieved February 4, 2020.                                  |
% | (c) 2015                                                                                   |
% ----------------------------------------------------------------------------------------------


function ci_gnt_mesh_sgolay_tsp(img,convertido,femm_path)

I = img;

BW2 = I;
BW2 = imrotate(BW2,270);

ajuste = convertido;

Maior = zeros(2);
Menor = zeros(2);

addpath(femm_path); 
openfemm;
newdocument(3);
ci_probdef('millimeters', 'planar', 0, 1.e-8, 20);


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
    ci_drawpolygon(P);
    
    T = [];
    T1 = [];
    
end
%close all
maior2 = max(Maior)*1.1;
menor2 = min(Menor)*1.1;
ymaior = maior2(1,2);
xmaior = maior2(1,1);
ymenor = menor2(1,2);
xmenor = menor2(1,1);
ci_drawrectangle(xmaior,ymaior,xmenor,ymenor)
[pathstr,name,ext]=fileparts(mfilename('fullpath'));
addpath(genpath(pathstr));
ci_saveas([pathstr,'\Filename.FEC'])
ci_createmesh;
end