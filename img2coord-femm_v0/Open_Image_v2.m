% -----------------------------------------------------------------------------
% This toolbox was made by Marco Aurélio de Oliveira Moreira 
% Universidade Federal de Santa Catarina - GRUCAD (https://grucad.ufsc.br/)
% marcoaomoreira@gmail.com
% 2020
% ----------------------------------------------------------------------------

% Here is the first part of the toolbox that connects with the manual       
% part and calculates the automatic part. First of all, the user have to    
% install FEMM 4.2 in the computer (http://www.femm.info/wiki/Download) and
% after that make sure to put the path ot the femm in this code. (Generally
% the path is ~FEMM42\femm42\mfiles). 
%
%
%
%

function varargout = Open_Image(varargin)
% OPEN_IMAGE MATLAB code for Open_Image.fig
%      OPEN_IMAGE, by itself, creates a new OPEN_IMAGE or raises the existing
%      singleton*.
%
%      H = OPEN_IMAGE returns the handle to a new OPEN_IMAGE or the handle to
%      the existing singleton*.
%
%      OPEN_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPEN_IMAGE.M with the given input arguments.
%
%      OPEN_IMAGE('Property','Value',...) creates a new OPEN_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Open_Image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Open_Image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Open_Image

% Last Modified by GUIDE v2.5 06-Oct-2019 17:20:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Open_Image_OpeningFcn, ...
                   'gui_OutputFcn',  @Open_Image_OutputFcn, ...
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


% --- Executes just before Open_Image is made visible.
function Open_Image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Open_Image (see VARARGIN)

global convert
global imagen
global type
global img_original
global femm_path

[pathstr,name,ext]=fileparts(mfilename('fullpath'));
addpath(genpath(pathstr));
femm_path = addpath('D:\Arquivos de Programas\FEMM42\femm42\mfiles'); 

%addpath(genpath('D:\Marco\Faculdade\Mestrado\Materias\Dissertação - Material\Programa Final\Programa Final - Versão Completa'))
% Choose default command line output for Open_Image
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Open_Image wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Open_Image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in open_image_button.
function open_image_button_Callback(hObject, eventdata, handles)
% hObject    handle to open_image_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,path] = uigetfile(...
    {'*.jpg;*.png','Images (*.jpg,*.png)';...
    '*.*','All Files (*.*)'},...
    'Select an image');
  if ~fileName; return; end
  file = [path,fileName];
handles.txt_input.String = file;
cla reset
hold off;

cla(handles.ax_original);
global imagen
global img_original

imagen = imread(file);
img_original = imread(file);

% filenames = fullfile(path, fileName);
handles.imagen = imagen;


	% IMPORTANT NOTE: hold needs to be off in order for the "fit" feature to work correctly.
% h.imagedata = cellfun(@imread, imagen, 'uniformoutput', 0);
imshow(imagen,'InitialMagnification', 'fit','parent','Border','loose', handles.ax_original);
axis off;
% h.graph.ipt = image(h.ax_original,h.im.ipt);
% axis(h.ax_original,'off','ij');


guidata(handles.ax_original,imagen)

guidata(handles.figure1,handles);

% --- Executes on button press in automesh_button.
function automesh_button_Callback(hObject, eventdata, handles)
% hObject    handle to automesh_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global convert
global femm_path

path = femm_path;
valorreal = convert;

    if isempty(valorreal)==1|| valorreal==0
        valorreal=1;
        convertido = valorreal;
    else
        convertido = valorreal;
    end
    if handles.mi_problem.Value == true
        %mi_auto_generate_sgolay_tsp(imagen,convertido,path);
        mi_auto_generate_tsp(imagen,convertido,path);
    elseif handles.hi_problem.Value == true
        hi_auto_generate_sgolay_tsp(imagen,convertido,path);
        %hi_auto_generate_tsp(imagen,convertido,femmpath);
    elseif handles.ei_problem.Value == true
        ei_auto_generate_sgolay_tsp(imagen,convertido,path);
        %ei_auto_generate_tsp(imagen,convertido,path);
    elseif handles.ci_problem.Value == true
        ci_auto_generate_sgolay_tsp(imagen,convertido,path);
        %ci_auto_generate_tsp(imagen,convertido,path);
    end

% --- Executes on button press in filter_button.
function filter_button_Callback(hObject, eventdata, handles)
% hObject    handle to filter_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global type
global femm_path
femm_path = addpath('D:\Arquivos de Programas\FEMM42\femm42\mfiles'); 
    
    if handles.mi_problem.Value == true
       type = 'mi';
    elseif handles.hi_problem.Value == true
       type = 'hi';
    elseif handles.ei_problem.Value == true
       type = 'ei';
    elseif handles.ci_problem.Value == true
       type = 'ci';
    end

% [imagen] = Filters(img);
Filters(imagen, type,femm_path);
% --- Executes during object creation, after setting all properties.

function automesh_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function obj_ref_Callback(hObject, eventdata, handles)
% hObject    handle to obj_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of obj_ref as text
%        str2double(get(hObject,'String')) returns contents of obj_ref as a double


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

% --- Executes on button press in Num_Obj_button_1.
function Num_Obj_button_1_Callback(hObject, eventdata, handles)
% hObject    handle to Num_Obj_button_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global num_obj
img = imagen;

num_of_objs(img,handles.ax_original,handles.edit3);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in convert_button.
function convert_button_Callback(hObject, eventdata, handles)
% hObject    handle to convert_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global convert
global imagen
global real_value

img = imagen;
objreferencia = str2double(get(handles.obj_ref,'String'));
valorreal = str2double(get(handles.real_value,'String'));

if get(handles.remove_ref,'value') == 1
    removal = 1;
   
else
    removal = 0;
        
end

 [value, remove] = conversion(imagen,valorreal,objreferencia,removal);
 imagen = remove;
 convert = value;


% --- Executes on button press in remove_ref.
function remove_ref_Callback(hObject, eventdata, handles)
% hObject    handle to remove_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of remove_ref


% --- Executes on button press in original_img.
function original_img_Callback(hObject, eventdata, handles)
% hObject    handle to original_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global imagen
global img_original

I = img_original;
imshow(I, 'InitialMagnification', 'fit', 'parent', handles.ax_original);
imagen = I; 
