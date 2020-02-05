% ----------------------------------------------------------------------------------------------
% | Here is the codes that was used to construct this part of the toolbox                      |
% | Most of the functions is the OctaveFEMM Toolbox, made by David Meeker                      |
% | All the fuctions used in the code has his own references.                                  |
% ----------------------------------------------------------------------------------------------

function mi_generate_mesh_tsp(img,convertido,femm_path)


RGB = img;
bw = RGB;
bw = imrotate(bw,270);
CH_objects = bwconncomp(bw);

ajuste = convertido;
B2 = bwboundaries(bw);

num = size(B2, 1);

addpath(femm_path); 
openfemm;
newdocument(0);
mi_probdef(0, 'millimeters', 'planar', 1.e-8, 0, 30); 

Maior = zeros(2);
Menor = zeros(2);

for k=1 : num
    
    B=[B2{k,1}];
    P = B*ajuste;
    s = size(P);
    
    ma = max(P); % Number to create the boundary
    Maior = [Maior;ma];
    me = min(P);
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
     mi_drawpolygon(T2);
     T = [];
     P = [];
     
end

maior2 = max(Maior)*1.3;
menor2 = max(Maior)*-1.3;
ymaior = maior2(1,2);
xmaior = maior2(1,1);
ymenor = menor2(1,2);
xmenor = menor2(1,1);
mi_drawrectangle(xmaior,ymaior,xmenor,ymenor)

[pathstr,name,ext]=fileparts(mfilename('fullpath'));
addpath(genpath(pathstr));
mi_saveas([pathstr,'\Filename.FEC'])

mi_createmesh;

end