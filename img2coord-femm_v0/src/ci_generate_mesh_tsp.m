% ----------------------------------------------------------------------------------------------
% | Here is the codes that was used to construct this part of the toolbox.                     |
% | Most of the functions is the OctaveFEMM Toolbox, made by David Meeker                      |
% | All the fuctions used in the code has his own references.                                  |
% | Reference: Image Analyst (2015). Image Segmentation Tutorial                               |
% | https://www.mathworks.com/matlabcentral/fileexchange/25157-image-segmentation-tutorial),   |
% | MATLAB Central File Exchange. Retrieved February 4, 2020.                                  |
% | (c) 2015                                                                                   |
% ----------------------------------------------------------------------------------------------


function ci_generate_mesh_tsp(img,convertido)


RGB = img;
bw = RGB;
bw = imrotate(bw,270);
CH_objects = bwconncomp(bw);

ajuste = convertido;
B2 = bwboundaries(bw);

num = size(B2, 1);

addpath(femm_path); 
openfemm;
newdocument(3);
ci_probdef('millimeters', 'planar', 0, 1.e-8, 30); 

Maior = zeros(2);
Menor = zeros(2);

for k=1 : num
    
    
    B=[B2{k,1}];
   % assignin('base','B2',B2)
   
    P = B*ajuste;
    s = size(P);
    %assignin('base','P',P)
    ma = max(P);
    %assignin('base','ma',ma)
    Maior = [Maior;ma];
    me = min(P);
    %assignin('base','me',me)
    Menor = [Menor;me];
    
    userConfig = struct('xy',P,'showProg',false,'showResult',false,'showWaitbar',false);
    resultStruct = tsp_nn(userConfig);
    
    tt = size(resultStruct.optRoute);
    assignin('base','tt',tt)
        for i=1:tt(1,2)
            T(i,1) = P(resultStruct.optRoute(1,i),1);
            T(i,2) = P(resultStruct.optRoute(1,i),2);
        end
        
     T1 = T;
     xx = smooth(T1(:,1));
     yy = smooth(T1(:,2));
     T2 = [xx,yy];
     ci_drawpolygon(T2);
     T = [];
     P = [];
     
end

maior2 = max(Maior)*1.1;
menor2 = min(Menor)*1.1;
ymaior = maior2(1,2);
xmaior = maior2(1,1);
ymenor = menor2(1,2);
xmenor = menor2(1,1);
ci_drawrectangle(xmaior,ymaior,xmenor,ymenor)
%close all
[pathstr,name,ext]=fileparts(mfilename('fullpath'));
addpath(genpath(pathstr));

ci_saveas([pathstr,'\Filename.FEC'])
ci_createmesh;

end