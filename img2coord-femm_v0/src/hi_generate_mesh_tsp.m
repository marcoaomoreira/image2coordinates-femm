function hi_generate_mesh_tsp(img,convertido)


RGB = img;
bw = RGB;
bw = imrotate(bw,270);
CH_objects = bwconncomp(bw);

ajuste = convertido;
B2 = bwboundaries(bw);

num = size(B2, 1);

addpath(femm_path); 
openfemm;
newdocument(2);
hi_probdef('millimeters', 'planar', 1.e-8, 0, 30); 

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
     hi_drawpolygon(T2);
     T = [];
     P = [];
     
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

end