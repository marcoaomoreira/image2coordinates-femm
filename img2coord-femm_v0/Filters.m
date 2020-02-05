% -----------------------------------------------------------------------------
% This toolbox was made by Marco Aurélio de Oliveira Moreira 
% Universidade Federal de Santa Catarina - GRUCAD (https://grucad.ufsc.br/)
% 2020
% ----------------------------------------------------------------------------

% -----------------------------------------------------------------------------
% | Here is the codes that was used to construct this part of the toolbox     |
% | References used in the code:                                              |
% | Chuang Alex (2020). DataCapturer                                          |
% | Functions varassign and Slider2 are parts of the DataCapturer             |
% | (https://www.mathworks.com/matlabcentral/fileexchange/67820-datacapturer),|
% | MATLAB Central File Exchange. Retrieved February 4, 2020.                 |
% | (c) 2015                                                                  |
% -----------------------------------------------------------------------------

function varargout = Filters(varargin)
% FILTERS MATLAB code for Filters.fig
%      FILTERS, by itself, creates a new FILTERS or raises the existing
%      singleton*.
%
%      H = FILTERS returns the handle to a new FILTERS or the handle to
%      the existing singleton*.
%
%      FILTERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERS.M with the given input arguments.
%
%      FILTERS('Property','Value',...) creates a new FILTERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Filters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Filters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Filters

% Last Modified by GUIDE v2.5 06-Oct-2019 16:13:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Filters_OpeningFcn, ...
                   'gui_OutputFcn',  @Filters_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Filters is made visible.
function Filters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Filters (see VARARGIN)
global img
global img_original
global type
global conversao
global femm_path

type = varargin{2};
img = varargin{1};
femm_path = varargin{3};
img_original = img;

cla(handles.ax_data);
imshow(img, 'InitialMagnification', 'fit', 'parent', handles.ax_data);

  handles.state.fail = false;
  handles.state.start = false;
  handles.state.erasing = false;
  
  wid = 230;
  lim.m = 0;
  lim.M = 255;
  val.m = 0;
  val.M = 225;
  
  pos.x = 10;
  pos.y = 40;
  handles.sld_dataFilter_B = Slider2(handles.ax_original,pos,wid,lim,val);
  pos.y = 100;
  handles.sld_dataFilter_G = Slider2(handles.ax_original,pos,wid,lim,val);
  pos.y = 160;
  handles.sld_dataFilter_R = Slider2(handles.ax_original,pos,wid,lim,val);
  set(handles.figure1,'WindowButtonMotionFcn',{@Mouse_Motion_Callback,handles},...
    'WindowButtonUpFcn',{@Mouse_Up_Callback,handles});
% Choose default command line output for Filters
handles.output = hObject;

axis(handles.ax_original,[0 280 0 210])
axis image

[pathstr,name,ext]=fileparts(mfilename('fullpath'));
addpath(genpath(pathstr));

handles = initialize(handles);
  
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Filters wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 %% Inner fcns
function handles = initialize(handles)
  handles.state.start = true;
  handles.sld_dataFilter_R.Enable = 'on';
  handles.sld_dataFilter_G.Enable = 'on';
  handles.sld_dataFilter_B.Enable = 'on';
function hObject = isClickOn(objs)
  hObject = [];
  for sldID = 1:length(objs)
    if ~isempty(objs(sldID).Mouse.click)
      hObject = objs(sldID);
      return
    end
  end
function chk = isMouseOnAx(ax)
  pos = get(ax,'CurrentPoint');
  x = pos(1,1);
  y = pos(1,2);
  if x < ax.XLim(2) && x > ax.XLim(1) &&...
      y < ax.YLim(2) && y > ax.YLim(1)
    chk = true;
  else
    chk = false;
  end 
  
  %% Updates
 function handles = Update_dataFilter(handles)
  global img
  global img_original;
  
  %assignin('base','img',img);
  handles.im.h.Data = img_original;
  %sliderBW = handles.im.h.Data;
  I = img;  
  if handles.state.fail
    handles = failImage(handles);
    return
  end
  filter_R = handles.sld_dataFilter_R.val;
  filter_G = handles.sld_dataFilter_G.val;
  filter_B = handles.sld_dataFilter_B.val;
  
  sliderBW = (handles.im.h.Data(:,:,1) >= filter_R.m) & (handles.im.h.Data(:,:,1) <= filter_R.M) & ...
   (handles.im.h.Data(:,:,2) >= filter_G.m) & (handles.im.h.Data(:,:,2) <= filter_G.M) &...
   (handles.im.h.Data(:,:,3) >= filter_B.m) & (handles.im.h.Data(:,:,3) <= filter_B.M);
  if isempty(handles.im.h.Data)
    handles.state.fail = true;
  end
  
  BW = sliderBW;

  % Initialize output masked image based on input image.
  maskedRGBImage = handles.im.h.Data;

  % Set background pixels where BW is false to zero.
  maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
  
  imshow(maskedRGBImage, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
  img = maskedRGBImage;
  

function Mouse_Motion_Callback(~,~,handles)
  handles = guidata(handles.figure1);
  if ~handles.state.start; return; end
  if isMouseOnAx(handles.ax_original)
    objs = [handles.sld_dataFilter_R,handles.sld_dataFilter_G,handles.sld_dataFilter_B];
    hObject = isClickOn(objs);
    if isempty(hObject); return; end
    pos = get(handles.ax_original,'CurrentPoint');
    x = pos(1,1);
    switch hObject.Mouse.click
      case 'm'
        lim.M = hObject.label2axis(hObject.val.M) - hObject.Gap.mM_Marker;
        lim.m = hObject.axLim.m;
        hObject.moveMarker(lim,x);
      case 'M'
        lim.M = hObject.axLim.M;
        lim.m = hObject.label2axis(hObject.val.m) + hObject.Gap.mM_Marker;
        hObject.moveMarker(lim,x);
      case 'I'
        lim.M = hObject.axLim.M - hObject.Mouse.MDiff;
        lim.m = hObject.axLim.m + hObject.Mouse.mDiff;
        hObject.moveInterval(lim,x);
    end
    handles = Update_dataFilter(handles);
  end
guidata(handles.figure1,handles)
function Mouse_Up_Callback(~,~,handles)
  handles = guidata(handles.figure1);
  if ~handles.state.start; return; end
  handles.sld_dataFilter_R.Mouse.click = [];
  handles.sld_dataFilter_G.Mouse.click = [];
  handles.sld_dataFilter_B.Mouse.click = [];
  handles.state.erasing = false;
  guidata(handles.figure1,handles)
 
% --- Outputs from this function are returned to the command line.
function varargout = Filters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global img
 global img_original
 
     if handles.gaussian_radio.Value == true
         %H = fspecial('gaussian',[3 3],0.25);
         FilteredImage = imgaussfilt(img,1);
         imshow(FilteredImage, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = FilteredImage;
     elseif handles.laplacian_radio.Value == true
         H = fspecial('laplacian',0.25);
         FilteredImage = imfilter(img,H,'replicate');
         imshow(FilteredImage, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = FilteredImage;

     elseif handles.prewitt_radio.Value == true
         H = fspecial('prewitt');
         FilteredImage = imfilter(img,H,'replicate');
         imshow(FilteredImage, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = FilteredImage;

     elseif handles.sobel_radio.Value == true
          H = fspecial('sobel');
         FilteredImage = imfilter(img,H,'replicate');
         imshow(FilteredImage, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = FilteredImage;

     elseif handles.median_radio.Value == true
         %H = imnlmfilt(img);
         H = bwareafilt(img,[0 30]);
         imshow(H, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = H;  
     end
     
     % --- Executes on button press in binary_button.
function binary_button_Callback(hObject, eventdata, handles)
% hObject    handle to binary_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img
%global img_original

I = img;
if size(I,3)==3
    I = rgb2gray(I);
end
BW = imbinarize(I);
imshow(BW, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
img = BW;


% --- Executes on button press in remove_pxl_button.
function remove_pxl_button_Callback(hObject, eventdata, handles)
% hObject    handle to remove_pxl_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img
BW = img;
pixelnumber = str2double(get(handles.pixel_number,'String'));

if isempty(pixelnumber) == 0
    BW = bwareaopen(BW,5);
else
    BW = bwareaopen(BW,pixelnumber);
end


imshow(BW, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
img = BW;


function pixel_number_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_number as text
%        str2double(get(hObject,'String')) returns contents of pixel_number as a double


% --- Executes during object creation, after setting all properties.
function pixel_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in generate_mesh.
function generate_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to generate_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img
global conversao
global type
global femm_path
valorreal = conversao;

    if isempty(valorreal)==1|| valorreal==0
        valorreal=1;
        convertido = valorreal;
    else
        convertido = valorreal;
    end
    
    if type == "mi"
       %mi_gnt_mesh_sgolay_tsp(img,convertido,femm_path);
       mi_generate_mesh_tsp(img,convertido,femm_path);
    elseif type == "hi"
       %hi_gnt_mesh_sgolay_tsp(img,convertido,femm_path);
       hi_generate_mesh_tsp(img,convertido,femm_path);
    elseif type == "ei"
       %ei_gnt_mesh_sgolay_tsp(img,convertido,femm_path);
       ei_generate_mesh_tsp(img,convertido,femm_path);
    elseif type == "ci"
       %ci_gnt_mesh_sgolay_tsp(img,convertido,femm_path);
       ci_generate_mesh_tsp(img,convertido,femm_path);
    end


% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup3 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img
global img_original
     
    %Using function contour
     if handles.countour_img.Value == true
        if size(img,3)==3
            img = rgb2gray(img);
        end
         BW = img;
         original = img_original;
         iterations = 100;
         BW = activecontour(original, BW, iterations, 'Chan-Vese');
         imshow(BW, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = BW;
         
     elseif handles.edge_radio.Value == true
            if size(img,3)==3
                img = rgb2gray(img);
            end
         ImagePropertie = edge(img);
         imshow(ImagePropertie, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = ImagePropertie;
     
     elseif handles.sharpen_radio.Value == true
            if size(img,3)==3
                img = rgb2gray(img);
            end
         sharphened_image = imsharpen(img,'Amount', 1,'Radius', 2, 'Threshold', 0);
         imshow(sharphened_image, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = sharphened_image;
         
     elseif handles.adjust_radio.Value == true
         smooth_image = imadjust(img);
         imshow(smooth_image, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = smooth_image;
         
     elseif handles.imcomplement_radio.Value == true
         imcomplement_image = imcomplement(img);
         imshow(imcomplement_image, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = imcomplement_image;
         
     %Subtracting Background/Foreground 
     elseif handles.subtration_radio.Value == true
         se = strel('disk',1);
         background = imopen(img,se);
         if get(handles.checkbox1,'value') == 1
            sub_image = img_original-img;
         else
             sub_image = img-img_original;
         end
              
         imshow(sub_image, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = sub_image;
      
    %Subtracting Background/Foreground 
     elseif handles.fill_region_radio.Value == true
         bin = img;  
         BW2 = imfill(bin,'holes');
         imshow(BW2, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = BW2;
         
    elseif handles.strel_radio.Value == true
         se = strel('disk',15);
         background = imopen(img,se);
         imshow(background, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = background;
     end 
         
 % --- Executes on button press in originalimg_button.
function originalimg_button_Callback(hObject, eventdata, handles)
% hObject    handle to originalimg_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img
global img_original

I = img_original;
imshow(I, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
img = I;  

function number_obj_Callback(hObject, eventdata, handles)
% hObject    handle to number_obj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number_obj as text
%        str2double(get(hObject,'String')) returns contents of number_obj as a double

% --- Executes during object creation, after setting all properties.
function number_obj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number_obj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Num_Obj_button_1.
function Num_Obj_button_1_Callback(hObject, eventdata, handles)
% hObject    handle to Num_Obj_button_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img


num_of_objs(img,handles.ax_data,handles.number_obj);

% RGB = img;
% bw = RGB;
% [B2,L ,num , A] = bwboundaries(bw);
% string1 = sprintf('%.1f',num);
% 
% blobMeasurements = regionprops(bw, 'all');
% numberOfBlobs = size(blobMeasurements, 1);
% hold on;
% 
% boundaries = bwboundaries(bw);
% set(handles.number_obj,'String',string1);
% numberOfBoundaries = size(num, 1);
% axes(handles.ax_data)
%     textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
% labelShiftX = -7;
% blobECD = zeros(1, numberOfBlobs);
%     for k = 1 : numberOfBlobs           % Loop through all blobs.
%         % Find the mean of each blob.  (R2008a has a better way where you can pass the original image
%         % directly into regionprops.  The way below works for all versions including earlier versions.)
%         %thisBlobsPixels = blobMeasurements(k).PixelIdxList;  % Get list of pixels in current blob.
%     % 	meanGL = mean(originalImage(thisBlobsPixels)); % Find mean intensity (in original image!)
%     % 	meanGL2008a = blobMeasurements(k).MeanIntensity; % Mean again, but only for version >= R2008a
% 
%         blobArea = blobMeasurements(k).Area;		% Get area.
%     % 	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
%         blobCentroid = blobMeasurements(k).Centroid;		% Get centroid one at a time
%     % 	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
%         %fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
%         %fprintf(2,'#%2d %11.1f \n', k, blobArea);
%         % Put the "blob number" labels on the "boundaries" grayscale image.
%         text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight',  'Bold','Color','c');
%     end
% hold off
    
% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in convert_button.
function convert_button_Callback(hObject, eventdata, handles)
% hObject    handle to convert_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global img
global conversao
% 
objreferencia = str2double(get(handles.obj_ref,'String'));
valorreal = str2double(get(handles.real_value,'String'));
if get(handles.remove_ref,'value') == 1
    removal = 1;
else
    removal = 0;
end

[conversao, remove] = conversion(img,valorreal,objreferencia,removal);
img = remove;
% 
% %% Separando as imagens para calculo das demais áreas
% RGB = img;
% bw = RGB;
% [B2,L ,num , A] = bwboundaries(bw);
% string1 = sprintf('%.1f',num);
% 
% blobMeasurements = regionprops(bw, 'all');
% numberOfBlobs = size(blobMeasurements, 1);
% hold on;
% 
% boundaries = bwboundaries(bw);
% set(handles.number_obj,'String',string1);
% numberOfBoundaries = size(num, 1);
% axes(handles.ax_data)
% textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
% labelShiftX = -7;
% blobECD = zeros(1, numberOfBlobs);
%     for k = 1 : numberOfBlobs           % Loop through all blobs.
%       
%         blobArea = blobMeasurements(k).Area;		% Get area.
%     % 	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
%         blobCentroid = blobMeasurements(k).Centroid;
%         blobDiameter = blobMeasurements(k).EquivDiameter;% Get centroid one at a time
%     % 	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
%         %fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
%         %fprintf(2,'#%2d %11.1f \n', k, blobArea);
%         % Put the "blob number" labels on the "boundaries" grayscale image.
%         text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight',  'Bold','Color','c');
%     end
% hold off
% 
% for k = 1 : numberOfBlobs           
%         convertidos = blobMeasurements(k).EquivDiameter*valorreal/blobMeasurements(objreferencia).EquivDiameter;
%        		% Get area.
%          
%         fprintf(2,'#%2d %11.1f \n', k, convertidos);
% end
% 
% convertion = valorreal/blobMeasurements(objreferencia).EquivDiameter;
% 
% conversao = convertion;




% --- Executes during object creation, after setting all properties.
function obj_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function real_value_Callback(hObject, eventdata, handles)
% hObject    handle to real_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of real_value as text
%        str2double(get(hObject,'String')) returns contents of real_value as a double

function obj_ref_Callback(hObject, eventdata, handles)
% hObject    handle to real_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of real_value as text
%        str2double(get(hObject,'String')) returns contents of real_value as a double

% --- Executes during object creation, after setting all properties.
function real_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to real_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global img
global img_original

%pop = get(handles.popupmenu1,'String');
val = get(handles.popupmenu1,'Value');
%string_list = get(handles.popupmenu1,'String');
%selected_string = string_list{val};
     
    %Using function contour
     switch val
         case 1
         se = strel('disk',5);
         originalBW = img;
         closeBW = imclose(originalBW,se);
         imshow(closeBW, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = closeBW;
         case 2
         se = strel('disk',3);
         originalBW = img;
         openBW = imclose(originalBW,se);
         imshow(openBW, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = openBW;
         case 3
         originalBW = img;
         BW2 = bwmorph(originalBW,'remove');
         imshow(BW2, 'InitialMagnification', 'fit', 'parent', handles.ax_data);
         img = BW2;
     end
     
    
     
     

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in remove_ref.
function remove_ref_Callback(hObject, eventdata, handles)
% hObject    handle to remove_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of remove_ref
