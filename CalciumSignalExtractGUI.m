function varargout = CalciumSignalExtractGUI(varargin)
% CALCIUMSIGNALEXTRACTGUI MATLAB code for CalciumSignalExtractGUI.fig
%      CALCIUMSIGNALEXTRACTGUI, by itself, creates a new CALCIUMSIGNALEXTRACTGUI or raises the existing
%      singleton*.
%
%      H = CALCIUMSIGNALEXTRACTGUI returns the handle to a new CALCIUMSIGNALEXTRACTGUI or the handle to
%      the existing singleton*.
%
%      CALCIUMSIGNALEXTRACTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCIUMSIGNALEXTRACTGUI.M with the given input arguments.
%
%      CALCIUMSIGNALEXTRACTGUI('Property','Value',...) creates a new CALCIUMSIGNALEXTRACTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalciumSignalExtractGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalciumSignalExtractGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalciumSignalExtractGUI

% Last Modified by GUIDE v2.5 10-Aug-2015 09:35:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CalciumSignalExtractGUI_OpeningFcn, ...
    'gui_OutputFcn',  @CalciumSignalExtractGUI_OutputFcn, ...
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


% --- Executes just before CalciumSignalExtractGUI is made visible.
function CalciumSignalExtractGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalciumSignalExtractGUI (see VARARGIN)

% Choose default command line output for CalciumSignalExtractGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%load pervious GUI user inputs
loadSettings(handles);



% UIWAIT makes CalciumSignalExtractGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CalciumSignalExtractGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off','all')
try
    LoadRoiData(handles);
catch err
    disp(err.message);
    set(handles.text1,'String',err.message );
    
end

function LoadRoiData(handles)
global globaldata

%load ROIS as txt file
[FileName,PathName] = uigetfile({'*RoiData*';'*.txt'},'Select a RoiData.txt file');
path = strcat(PathName,FileName);

%check if txt file
[pathstr,name,ext] = fileparts(path);
if ~strcmp(ext,'.txt')
    error ('not a .txt file. could not load');
end


B = importdata(path);

globaldata.pathForSave = path;
globaldata.ROI_data = B;
globaldata.FileName_current = FileName;
set(handles.text1,'String','ROI data loaded');
disp('ROI data loaded');




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('off','all')
try
    LoadBehaviorData(handles);
catch err
    disp(err.message);
    set(handles.text1,'String',err.message );
end

function LoadBehaviorData(handles)
global globaldata

%load Behavior mat file
[FileName,PathName] = uigetfile({'*xtime-act*';'*.mat'},'Select a Behavior.mat file');
path = strcat(PathName,FileName);
%check if matfile
[pathstr,name,ext] = fileparts(path);
if ~strcmp(ext,'.mat')
    error ('not a .mat file. could not load');
end

globaldata.pathForSave = path;
globaldata.BehaviorData_in = load(path);
set(handles.text1,'String','Behavior data loaded');
disp('Behavior data loaded');




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning('off','all')
try
    LoadImage(handles);
catch err
    disp(err.message);
    set(handles.text1,'String',err.message );
    
end

function LoadImage(handles)
global globaldata

%load ROI image
[FileName,PathName] = uigetfile({'*RoiImage*';'*.jpg';'*.tiff';'*tif*'},'Select RoiImage file');
path = strcat(PathName,FileName);
%check if image file
[pathstr,name,ext] = fileparts(path);
if ~strcmp(ext,{'.jpeg','.jpg', '.tiff'})
    error ('not a jpeg, jpg or tiff file. could not load');
end

globaldata.Image1 = imread(path);
axes(handles.axes2)
image(globaldata.Image1);
set(handles.text1,'String','Roi Image loaded');
set(handles.axes2,'YTickLabel',[]);
set(handles.axes2,'XTickLabel',[]);
disp('ROI image loaded');


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global globaldata
globaldata.ROI_data = [];
globaldata.BehaviorData_in = [];




function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)cerat

try
    CheckUserInputs(handles);
    PlotAllData(handles);
    
catch err
    disp(err.message);
    set(handles.text1,'String',err.message );
    
end


function PlotAllData(handles)
global globaldata
set(handles.text1,'String', ' ');


%create object
PlotObject = AddDataAndPlot;

%get current GUI
y_spacing = str2double(get(handles.edit1,'String'));
x_spacing = str2double(get(handles.edit2,'String'));

y_max = get(handles.edit3,'String');
y_min = get(handles.edit4,'String');

x_max = get(handles.edit14,'String');
x_min = get(handles.edit15,'String');

do_normalize = get(handles.checkbox1,'Value');
plot_two_windows = get(handles.checkbox2,'Value');


%add data for plot
if isempty(globaldata.ROI_data)
    set(handles.text1,'String','no ROI data loaded');
    
else
    
    %get the offset first
    if ~isempty(globaldata.BehaviorData_in)
        %make sure the data is in right format
        try
            offset_for_sync = globaldata.BehaviorData_in.BehaviorData(4,1);
        catch
            offset_for_sync = 0;
        end
    else
        offset_for_sync = 0;
    end
    
    
    %calculate ROI data
    PlotObject.AddRoiDataAndScale(globaldata.ROI_data, y_spacing, x_spacing, do_normalize, offset_for_sync);
    
    %if some behavior data present
    if ~isempty(globaldata.BehaviorData_in)
        
        try %see if the behavior data entered can be used
            %calculate Behavior data
            PlotObject.AddBehaviorData(globaldata.BehaviorData_in.BehaviorData);
            
        catch err
            globaldata.BehaviorData_in = [];
            error('Behavior data loaded not compatible - was removed');
            
        end
        
    end
    
    %pass in the object, so you can access the data from object, which has been modified and not
    %the one from the gui
    PlotAll(handles, PlotObject,plot_two_windows, y_min, y_max, x_min, x_max);
    if  ~isempty(PlotObject.Stim_legend_string)
       set(handles.text1,'String',mat2str(PlotObject.Stim_legend_string));   
    end
end



function PlotAll(handles, PlotObject, plot_two_windows, y_min, y_max, x_min, x_max)

if plot_two_windows == 1
    figure(2);
    handles.figure2_axes = gca;
    cla(handles.figure2_axes,'reset');
end


set(handles.text8,'String', PlotObject.Percent_correct);
cla(handles.axes1,'reset');

PlotResponses(handles, PlotObject, plot_two_windows);

try %see if the mat file matches what is needed
    PlotStimuli(handles, PlotObject, plot_two_windows);
catch
    set(handles.text1,'String', 'Behavior file not compatible');
    disp('Behavior file not compatible');
end

try
    PlotROIS(handles, PlotObject, plot_two_windows, y_min, y_max, x_min, x_max);
catch err
    disp(err.message);
    set(handles.text1,'String',err.message );
end


function PlotROIS(handles, PlotObject, plot_two_windows, y_min_in, y_max_in, x_min_in, x_max_in)
global globaldata

%get the upper bound of ROIs to be plotted. numbers are already checked to
%be usable
upper_roi_num = get(handles.edit13, 'String');
%if not auto, use number
if ~strcmp(upper_roi_num,'auto')
    %adjust for header row
    upper_roi_num = str2num(get(handles.edit13, 'String'))+1;
    %make sure the number is not larger than total rois
    if upper_roi_num > size(PlotObject.ROI_data,2);
        upper_roi_num = size(PlotObject.ROI_data,2);
    end
else %if auto
    upper_roi_num = size(PlotObject.ROI_data,2);
end

%get the lower bound of ROIs to be plotted
lower_roi_num = get(handles.edit12, 'String');
%if not auto, use number
if ~strcmp(lower_roi_num,'auto')
    %adjust for header row
    lower_roi_num = str2num(get(handles.edit12, 'String'))+1;
    %make sure the number is not larger than total rois
    if lower_roi_num > size(PlotObject.ROI_data,2);
        lower_roi_num = size(PlotObject.ROI_data,2);
    end
    
else %if auto
    %adjust for header row
    lower_roi_num = 2;
end

%plot window
hold on
%set the handle
axes(handles.axes1);
p = plot(PlotObject.ROI_data(:,1),PlotObject.ROI_data(:,lower_roi_num));
set(p,'Color','black')
for i = lower_roi_num+1:upper_roi_num
    hold on
    p = plot(PlotObject.ROI_data(:,1),PlotObject.ROI_data(:,i));
    set(p,'Color','black')
end

%get max and min for plot from last and first ROI
ymax = max(PlotObject.ROI_data(:,upper_roi_num));
ymin = min(PlotObject.ROI_data(:,lower_roi_num));
xmax = max(PlotObject.ROI_data(:,1));
xmin = 0;

%set manual range from GUI if set
if ~strcmp(y_max_in,'auto')
    ymax = str2double(y_max_in);
end

if ~strcmp(y_min_in,'auto')
    ymin = str2double(y_min_in);
end

if ~strcmp(x_max_in,'auto')
    xmax = str2double(x_max_in);
end

if ~strcmp(x_min_in,'auto')
    xmin = str2double(x_min_in);
end

try %see if the range requested in gui matches
    set(handles.axes1,'ylim',[ymin ymax]);
catch
    error ('Y lim min/max values requested not in range for this data');
end

set(handles.axes1,'YTickLabel',[]);

try %see if the range requested in gui matches
    set(handles.axes1,'xlim',[xmin xmax]);
catch
    error ('X lim min/max values requested not in range for this data');
end

hold off

%plot all second window
if plot_two_windows == 1
    
    hold on
    %set the handle
    axes(handles.figure2_axes);
    p = plot(PlotObject.ROI_data(:,1),PlotObject.ROI_data(:,2));
    set(p,'Color','black')
    for i = lower_roi_num:upper_roi_num
        hold on
        p = plot(PlotObject.ROI_data(:,1),PlotObject.ROI_data(:,i));
        set(p,'Color','black')
    end
    
    set(handles.figure2_axes,'ylim',[ymin ymax]);
    set(handles.figure2_axes,'xlim',[xmin xmax])
    
    hold off
    
end

if get(handles.checkbox6, 'Value') == 1
    AddROILabel(handles, PlotObject,lower_roi_num,upper_roi_num, xmin, xmax, ymin)
end
%save data in case of export to workspace
globaldata.temp_ROI_data_for_export = PlotObject.ROI_data;



function AddROILabel(handles, PlotObject,lower_roi_num,upper_roi_num, xmin, xmax, ymin)

%add legends at 0.14% of start (left edge)
x_range = (xmax-xmin)*0.014;
xmin_legend = xmin + x_range;

axes(handles.axes1);
%adjust for header row
for i = lower_roi_num-1:upper_roi_num-1
    text(xmin_legend,min(PlotObject.ROI_data(5:10,i+1)),num2str(i), 'HorizontalAlignment','center','BackgroundColor',[1 1 1]);
end

%calibration bar, only if the data is not normalized to 1

if get(handles.checkbox1, 'Value') ~= 1
    %get range from original data
    cal_height_unround = 1-(mean(PlotObject.ROI_data_original(1:end,2))/max(PlotObject.ROI_data_original(1:end,2)));
    
    %round to next first deciman
    cal_height_dec= round(cal_height_unround*10);
    %to scale to data, adjust it to max of data
    cal_height = (cal_height_dec/10);
    cal_height_bar = (cal_height_dec/10*max(PlotObject.ROI_data_original(1:end,2)));
    %add bar at -0.05% of end (right edge)
    x_range = (xmax-xmin)*0.005;
    xmin_bar = xmax - x_range;
    
    %cal_height = str2double(get(handles.edit12,'String'));
    patch_x = [xmin_bar-x_range, xmin_bar,xmin_bar, xmin_bar-x_range];
    patch_y = [cal_height_bar+ymin, cal_height_bar+ymin, cal_height_bar*2+ymin, cal_height_bar*2+ymin];
    
    patch(patch_x, patch_y,'black', 'EdgeColor','none')
    
    lege_string = strcat(num2str(cal_height*100),'%');
    
    %add label
    text(xmin_bar-(10*x_range),cal_height_bar+ymin, lege_string, 'HorizontalAlignment','left');
    
end





function PlotResponses(handles, PlotObject, plot_two_windows)

axes(handles.axes1);

hold on
p1 = plot(PlotObject.Responses_correct_x, PlotObject.Responses_correct);
set(p1,'Color','green','LineWidth',1.5)
p2 = plot(PlotObject.Responses_wrong_x, PlotObject.Responses_wrong);
set(p2,'Color','red','LineWidth',1.5)
%hold off
set(handles.axes1,'YTickLabel',[]);

hold off

%plot all second window
if plot_two_windows == 1
    axes(handles.figure2_axes);
    
    hold on
    p1 = plot(PlotObject.Responses_correct_x, PlotObject.Responses_correct);
    set(p1,'Color','green','LineWidth',1.5)
    p2 = plot(PlotObject.Responses_wrong_x, PlotObject.Responses_wrong);
    set(p2,'Color','red','LineWidth',1.5)
    %hold off
    set(handles.figure2_axes,'YTickLabel',[]);
    hold off
end



function PlotStimuli(handles, PlotObject, plot_two_windows)


hold on

%set the handle
axes(handles.axes1);
%plot left
if size(PlotObject.Stimulus_left_x,1) > 1
    hold on
    for i = 1:size(PlotObject.Stimulus_left_x,1)
        patch(PlotObject.Stimulus_left_x(i,:), PlotObject.Stimulus_left_y(i,:),'yellow', 'EdgeColor','none', 'FaceAlpha', 0.4)
    end
    hold off
end

%plot right
if size(PlotObject.Stimulus_right_x,1) > 1
    hold on
    for i = 1:size(PlotObject.Stimulus_right_x,1)
        patch(PlotObject.Stimulus_right_x(i,:), PlotObject.Stimulus_right_y(i,:),'blue', 'EdgeColor','none','FaceAlpha', 0.5)
    end
    hold off
end

%plot all others if using orientation tuning
if size(PlotObject.Stimulus_left_x,1) < 1
    
    if size(PlotObject.Stimulus_0_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_0_x,1)
            patch(PlotObject.Stimulus_0_x(i,:), PlotObject.Stimulus_0_y(i,:),[0.5 0 0], 'EdgeColor','none','FaceAlpha', 0.5)
           
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_12_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_12_x,1)
            patch(PlotObject.Stimulus_12_x(i,:), PlotObject.Stimulus_12_y(i,:),[0 1 0], 'EdgeColor','none','FaceAlpha', 0.5)
          
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_22_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_22_x,1)
            patch(PlotObject.Stimulus_22_x(i,:), PlotObject.Stimulus_22_y(i,:),[0 1 1], 'EdgeColor','none','FaceAlpha', 0.5)
        
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_33_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_33_x,1)
            patch(PlotObject.Stimulus_33_x(i,:), PlotObject.Stimulus_33_y(i,:),[1 0 0], 'EdgeColor','none','FaceAlpha', 0.5)
       
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_45_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_45_x,1)
            patch(PlotObject.Stimulus_45_x(i,:), PlotObject.Stimulus_45_y(i,:),[1 0 1], 'EdgeColor','none','FaceAlpha', 0.5)
       
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_56_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_56_x,1)
            patch(PlotObject.Stimulus_56_x(i,:), PlotObject.Stimulus_56_y(i,:),[0.5 1 0], 'EdgeColor','none','FaceAlpha', 0.5)
        
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_67_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_67_x,1)
            patch(PlotObject.Stimulus_67_x(i,:), PlotObject.Stimulus_67_y(i,:),[0 0 0], 'EdgeColor','none','FaceAlpha', 0.5)
       
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_78_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_78_x,1)
            patch(PlotObject.Stimulus_78_x(i,:), PlotObject.Stimulus_78_y(i,:),[1 0.2 0.7], 'EdgeColor','none','FaceAlpha', 0.5)
      
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_90_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_90_x,1)
            patch(PlotObject.Stimulus_90_x(i,:), PlotObject.Stimulus_90_y(i,:),[1 0.7 0.2], 'EdgeColor','none','FaceAlpha', 0.5)
       
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_101_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_101_x,1)
            patch(PlotObject.Stimulus_101_x(i,:), PlotObject.Stimulus_101_y(i,:),[0.7 1 0], 'EdgeColor','none','FaceAlpha', 0.5)
        
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_112_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_112_x,1)
            patch(PlotObject.Stimulus_112_x(i,:), PlotObject.Stimulus_112_y(i,:),[0.7 0 0], 'EdgeColor','none','FaceAlpha', 0.5)
       
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_123_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_123_x,1)
            patch(PlotObject.Stimulus_123_x(i,:), PlotObject.Stimulus_123_y(i,:),[0.7 0 1], 'EdgeColor','none','FaceAlpha', 0.5)
   
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_135_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_135_x,1)
            patch(PlotObject.Stimulus_135_x(i,:), PlotObject.Stimulus_135_y(i,:),[0.7 0.7 0], 'EdgeColor','none','FaceAlpha', 0.5)
      
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_146_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_146_x,1)
            patch(PlotObject.Stimulus_146_x(i,:), PlotObject.Stimulus_146_y(i,:),[0.7 0 0.7], 'EdgeColor','none','FaceAlpha', 0.5)
      
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_157_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_157_x,1)
            patch(PlotObject.Stimulus_157_x(i,:), PlotObject.Stimulus_157_y(i,:),[0.7 0.7 0.7], 'EdgeColor','none','FaceAlpha', 0.5)
       
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_168_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_168_x,1)
            patch(PlotObject.Stimulus_168_x(i,:), PlotObject.Stimulus_168_y(i,:),[0.5 0 0.2], 'EdgeColor','none','FaceAlpha', 0.5)
      
        end
        hold off
    end
    
    
    if size(PlotObject.Stimulus_180_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_180_x,1)
            patch(PlotObject.Stimulus_180_x(i,:), PlotObject.Stimulus_180_y(i,:),[1 0.2 0.5], 'EdgeColor','none','FaceAlpha', 0.5)
      
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_202_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_202_x,1)
            patch(PlotObject.Stimulus_202_x(i,:), PlotObject.Stimulus_202_y(i,:),[0 0.5 0.5], 'EdgeColor','none','FaceAlpha', 0.5)
       
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_225_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_225_x,1)
            patch(PlotObject.Stimulus_225_x(i,:), PlotObject.Stimulus_225_y(i,:),[0.2 0.7 0.2], 'EdgeColor','none','FaceAlpha', 0.5)
      
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_247_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_247_x,1)
            patch(PlotObject.Stimulus_247_x(i,:), PlotObject.Stimulus_247_y(i,:),[0.7 0.2 0.7], 'EdgeColor','none','FaceAlpha', 0.5)
     
        end
        hold off
    end
    
    
    if size(PlotObject.Stimulus_270_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_270_x,1)
            patch(PlotObject.Stimulus_270_x(i,:), PlotObject.Stimulus_270_y(i,:),[0.5 1 0.2], 'EdgeColor','none','FaceAlpha', 0.5)
       
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_292_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_292_x,1)
            patch(PlotObject.Stimulus_292_x(i,:), PlotObject.Stimulus_292_y(i,:),[0.7 0.7 0.2], 'EdgeColor','none','FaceAlpha', 0.5)
     
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_315_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_315_x,1)
            patch(PlotObject.Stimulus_315_x(i,:), PlotObject.Stimulus_315_y(i,:),[0.2 0.2 0.7], 'EdgeColor','none','FaceAlpha', 0.5)
      
        end
        hold off
    end
    
    if size(PlotObject.Stimulus_337_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_337_x,1)
            patch(PlotObject.Stimulus_337_x(i,:), PlotObject.Stimulus_337_y(i,:),[0.2 0.2 0.2], 'EdgeColor','none','FaceAlpha', 0.5)
      
        end
        hold off
    end
    
end


%plot all second window
if plot_two_windows == 1
    hold on
    axes(handles.figure2_axes);
    
    %plot left
    if size(PlotObject.Stimulus_left_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_left_x,1)
            patch(PlotObject.Stimulus_left_x(i,:), PlotObject.Stimulus_left_y(i,:),'yellow', 'EdgeColor','none', 'FaceAlpha', 0.4)
        end
        hold off
    end
    
    %plot right
    if size(PlotObject.Stimulus_right_x,1) > 1
        hold on
        for i = 1:size(PlotObject.Stimulus_right_x,1)
            patch(PlotObject.Stimulus_right_x(i,:), PlotObject.Stimulus_right_y(i,:),'blue', 'EdgeColor','none','FaceAlpha', 0.5)
        end
        hold off
    end
    hold off
end

function [x_coor,y_coor] = rotateLine(A,B,degrees)

R=[ ...
   cosd(degrees) -sind(degrees)
   sind(degrees) cosd(degrees)
   ];

rData = R*[A;B];

x_coor = rData(1,:);
y_coor = rData(2,:);



function SaveGUIImage(handles)

global globaldata

GUI_handle = gcf;

%save GUI as image
set(GUI_handle,'PaperPositionMode','auto');
set(gcf,'InvertHardcopy','off');
saveasname = [globaldata.pathForSave(1:end-12),'_DATAPLOT','.jpg'];

%extract file name only
[pathstr,name,ext] = fileparts(globaldata.pathForSave);
set(handles.text20,'String', name);
pause(0.01);

print ('-dbmp', '-r250', saveasname);
disp(['saved: ',saveasname]);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    SaveGUIImage(handles)
catch
    set(handles.text1,'String','Nothing there to save' );
end


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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    CheckUserInputs(handles);
    ExtractFromSingleFile(handles);
    set(handles.text1,'String','Extracted Single File');
catch err
    disp(err.message);
    set(handles.text1,'String',err.message );
    
end


function ExtractFromSingleFile(handles)
global globaldata

%get ROI settings:
Minsize = str2double(get(handles.edit6,'String'));
Maxsize = str2double(get(handles.edit5,'String'));
Method_av = get(handles.popupmenu1,'Value');
Skipbeginning = str2double(get(handles.edit7,'String'));
BinaryThreshold = str2double(get(handles.edit8,'String'));
temp_smooth = str2double(get(handles.edit9,'String'));
Method = get(handles.popupmenu2,'Value');
gui_ID = gcf;
%make new analysis object
analyzer =  ROIExtractionMain(Minsize, Maxsize, Method_av, Skipbeginning, BinaryThreshold, temp_smooth, Method, gui_ID);

HideAllButtonsExceptStop(handles);
try
    [globaldata.ROI_data globaldata.pathForSave] = analyzer.extractSingleFile(handles);
catch err
    set(handles.text1,'String',err.message );
    ShowAllButtonsExceptStop(handles);
    rethrow(err);
end

ShowAllButtonsExceptStop(handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    CheckUserInputs(handles);
    ExtractFromFolder(handles);
    
catch err
    disp(err.message);
    set(handles.text1,'String',err.message );
    
end

function ExtractFromFolder(handles)
global globaldata

Minsize = str2double(get(handles.edit6,'String'));
Maxsize = str2double(get(handles.edit5,'String'));
Method = get(handles.popupmenu2,'Value');
Skipbeginning = str2double(get(handles.edit7,'String'));
BinaryThreshold = str2double(get(handles.edit8,'String'));
temp_smooth = str2double(get(handles.edit9,'String'));
Method_av = get(handles.popupmenu1,'Value');
gui_ID = gcf;
HideAllButtonsExceptStop(handles);
%make new analysis object
analyzer =  ROIExtractionMain(Minsize, Maxsize, Method_av, Skipbeginning, BinaryThreshold, temp_smooth, Method, gui_ID);
try
    [globaldata.ROI_data globaldata.pathForSave] = analyzer.extractFolder(handles);
    
    set(handles.text1,'String', 'Done');
    
    
catch err
    
    
end
ShowAllButtonsExceptStop(handles);
set(handles.pushbutton8,'string','folder');
pause(0.01);



% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ExportPlotToWorkspace(handles);



function ExportPlotToWorkspace(handles)
global globaldata

try
    %extract filename from path
    [pathstr,name,ext] = fileparts(globaldata.pathForSave);
    %add letter in case it starts with number
    export_name = ['Plot_',name];
    assignin('base',export_name,globaldata.temp_ROI_data_for_export);
    set(handles.text1,'String', 'plot data exported to workspace');
    disp('Plot data exported to workspace');
catch
    set(handles.text1,'String', 'nothing there to export');
    
end

function HideAllButtonsExceptStop(handles)
set(handles.pushbutton1, 'Enable','off');
set(handles.pushbutton2, 'Enable','off');
set(handles.pushbutton3, 'Enable','off');
set(handles.pushbutton5, 'Enable','off');
set(handles.pushbutton6, 'Enable','off');
set(handles.pushbutton7, 'Enable','off');
set(handles.pushbutton8, 'Enable','off');
set(handles.pushbutton9, 'Enable','off');
set(handles.pushbutton11, 'Enable','off');
set(handles.pushbutton12, 'Enable','off');
set(handles.pushbutton13, 'Enable','off');
set(handles.togglebutton1, 'Enable','on');
pause(0.01);


function ShowAllButtonsExceptStop(handles)
set(handles.pushbutton1, 'Enable','on');
set(handles.pushbutton2, 'Enable','on');
set(handles.pushbutton3, 'Enable','on');
set(handles.pushbutton5, 'Enable','on');
set(handles.pushbutton6, 'Enable','on');
set(handles.pushbutton7, 'Enable','on');
set(handles.pushbutton8, 'Enable','on');
set(handles.pushbutton9, 'Enable','on');
set(handles.pushbutton11, 'Enable','on');
set(handles.pushbutton12, 'Enable','on');
set(handles.pushbutton13, 'Enable','on');
set(handles.togglebutton1, 'Enable','off');
set(handles.togglebutton1, 'Value',0);
pause(0.01);


function CheckUserInputs(handles)
all_button_IDs = [handles.edit1,handles.edit2,handles.edit5,handles.edit6,handles.edit7,handles.edit8,handles.edit9,handles.edit11];
all_button_labels = {'ROI YSpace','Time Step x','Max size ROI','Min size ROI','Skip frames', '% threshold', 'Temp smooth', 'mean threshold'};

%go through all buttons and see if they are correct
for i=1:length(all_button_IDs)
    %check if string is number
    [num, status] = str2num(get(all_button_IDs(i), 'String'));
    if status == 0
        error(strcat(char(all_button_labels(i)),' needs to be a number'));
    end
    %check if in range
    if str2double(get(all_button_IDs(i), 'String'))<0
        error(strcat(char(all_button_labels(i)),' needs to be > 0'));
    end
end



%ROI#
%edit12 can have 'auto' as parameter and be less than 0
edit12_input = get(handles.edit12, 'String');
%check if input is string
[num, status] = str2num(edit12_input);
%store number
edit12_entry=-1;
%if number
if status == 1
    %check if number in range, if so add to temp , else
    if str2double(edit12_input) < 1
        error('min ROI # plot needs to be number >0 or auto');
    end
    %if so, store
    edit12_entry = str2double(edit12_input);
    
    %if string, check if auto, if yes, do nothing
elseif ~strcmp(edit12_input,'auto')
    error('min ROI # plot needs to be number >0 or auto');
end

%edit13 can have 'auto' as parameter, be larger than 0 and larger than
%edit12
edit13_input = get(handles.edit13, 'String');
%check if input is string
[num, status] = str2num(edit13_input);
%if number
if status == 1
    %check if number in range,
    if str2double(edit13_input) < 1
        error('min ROI # plot needs to be number >0 or auto');
    end
    %check if number is larger than edit 12,
    if str2double(edit13_input) < edit12_entry
        error('max ROI # plot needs to be larger/equal than min ROI # plot ');
    end
    %if string, check if auto, if yes, do nothing
elseif ~strcmp(edit13_input,'auto')
    error('min ROI # plot needs to be number > max ROI or auto');
    
end



%ylim
%edit3 can have 'auto' as parameter
edit3_input = get(handles.edit3, 'String');
%check if input is string
[num, status] = str2num(edit3_input);
%store number
edit3_entry=-1;
%if number
if status == 1
    %store number
    edit3_entry = str2double(edit3_input);
    %if string, check if auto, if yes, do nothing
elseif ~strcmp(edit3_input,'auto')
    error('YLim max needs to be number or auto');
end


%edit4 can have 'auto' as parameter
edit4_input = get(handles.edit4, 'String');

%check if input is string
[num, status] = str2num(edit4_input);

%if number
if status == 1
    %check if number is smaller than edit3
    if str2double(edit4_input) >  edit3_entry && ~strcmp(edit3_input,'auto')
        error('YLim min needs to be smaller than YLim max or auto');
    end
    
    %if string, check if auto, if yes, do nothing
elseif ~strcmp(edit4_input,'auto')
    error('YLim min needs to be smaller than YLim max or auto');
end


%Xlim
%edit3 can have 'auto' as parameter
edit14_input = get(handles.edit14, 'String');
%check if input is string
[num, status] = str2num(edit14_input);
%store number
edit14_entry=-1;
%if number
if status == 1
    %store number
    edit14_entry = str2double(edit14_input);
    %if string, check if auto, if yes, do nothing
elseif ~strcmp(edit14_input,'auto')
    error('YLim max needs to be number or auto');
end


%edit15 can have 'auto' as parameter
edit15_input = get(handles.edit15, 'String');

%check if input is string
[num, status] = str2num(edit15_input);

%if number
if status == 1
    %check if number is smaller than edit3
    if str2double(edit15_input) >  edit14_entry && ~strcmp(edit14_input,'auto')
        error('XLim min needs to be smaller than XLim max or auto');
    end
    
    %if string, check if auto, if yes, do nothing
elseif ~strcmp(edit15_input,'auto')
    error('XLim min needs to be smaller than XLim max or auto');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[Setting_Struct] = SaveGuiSettings(handles);


function [Setting_Struct] = SaveGuiSettings(handles)
%create structure to save all settings
Setting_Struct(1,1).max_roi=get(handles.edit5,'String');
Setting_Struct(1,1).min_roi=get(handles.edit6,'String');
Setting_Struct(1,1).skip_frames=get(handles.edit7,'String');
Setting_Struct(1,1).perc_threshold=get(handles.edit8,'String');
Setting_Struct(1,1).temp_smooth=get(handles.edit9,'String');
Setting_Struct(1,1).time_step_x=get(handles.edit2,'String');
Setting_Struct(1,1).roi_space_y=get(handles.edit1,'String');
Setting_Struct(1,1).y_lim_max=get(handles.edit3,'String');
Setting_Struct(1,1).y_lim_min=get(handles.edit4,'String');
Setting_Struct(1,1).mean_threshold=get(handles.edit11,'String');
Setting_Struct(1,1).min_Rou_num=get(handles.edit12,'String');
Setting_Struct(1,1).max_Roi_num=get(handles.edit13,'String');
Setting_Struct(1,1).x_lim_max=get(handles.edit14,'String');
Setting_Struct(1,1).x_lim_min=get(handles.edit15,'String');

Setting_Struct(1,1).sub_bg_x=get(handles.checkbox3,'Value');
Setting_Struct(1,1).sub_bg_y=get(handles.checkbox4,'Value');
Setting_Struct(1,1).ratio_data=get(handles.checkbox5,'Value');
Setting_Struct(1,1).scale_to_1=get(handles.checkbox1,'Value');
Setting_Struct(1,1).plot_window=get(handles.checkbox2,'Value');
Setting_Struct(1,1).plot_ROI_nums=get(handles.checkbox6,'Value');

Setting_Struct(1,1).average=get(handles.popupmenu1,'Value');
Setting_Struct(1,1).segmentation=get(handles.popupmenu2,'Value');

saveasname = 'SavedSettingsCalciumSignalExtract.mat';

save(saveasname, 'Setting_Struct');
disp(['Settings Saved as: ',saveasname]);
set(handles.text1,'String', ['Settings Saved as: ',saveasname]);




% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadSettings(handles);

function loadSettings(handles)

loadname = 'SavedSettingsCalciumSignalExtract.mat';

try
    load(loadname);
    %pass the loaded Setting_Struct out of this function
    restoreGUISettings(Setting_Struct, handles);
    set(handles.text1,'String', 'Saved settings restored');
    disp(['Settings Restored: ',loadname]);
catch
    disp('No saved settings found current folder, using current values');
    set(handles.text1,'String', 'No saved settings found in current folder, using default values');
    
end



function restoreGUISettings(Setting_Struct, handles)
%create structure to save all settings

set(handles.edit5,'String',Setting_Struct(1,1).max_roi);
set(handles.edit6,'String',Setting_Struct(1,1).min_roi);
set(handles.edit7,'String',Setting_Struct(1,1).skip_frames);
set(handles.edit8,'String',Setting_Struct(1,1).perc_threshold);
set(handles.edit9,'String',Setting_Struct(1,1).temp_smooth);
set(handles.edit2,'String',Setting_Struct(1,1).time_step_x);
set(handles.edit1,'String',Setting_Struct(1,1).roi_space_y);
set(handles.edit3,'String',Setting_Struct(1,1).y_lim_max);
set(handles.edit4,'String',Setting_Struct(1,1).y_lim_min);
set(handles.edit11,'String',Setting_Struct(1,1).mean_threshold);
set(handles.edit12,'String',Setting_Struct(1,1).min_Rou_num);
set(handles.edit13,'String',Setting_Struct(1,1).max_Roi_num);
set(handles.edit14,'String',Setting_Struct(1,1).x_lim_max);
set(handles.edit15,'String',Setting_Struct(1,1).x_lim_min);

set(handles.checkbox3,'Value',Setting_Struct(1,1).sub_bg_x);
set(handles.checkbox4,'Value',Setting_Struct(1,1).sub_bg_y);
set(handles.checkbox5,'Value',Setting_Struct(1,1).ratio_data);
set(handles.checkbox1,'Value',Setting_Struct(1,1).scale_to_1);
set(handles.checkbox2,'Value',Setting_Struct(1,1).plot_window);
set(handles.checkbox6,'Value',Setting_Struct(1,1).plot_ROI_nums);

set(handles.popupmenu1,'Value',Setting_Struct(1,1).average);
set(handles.popupmenu2,'Value',Setting_Struct(1,1).segmentation);

%let Matlab GUI update
pause(0.01);



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

restoreGUIDefault(handles)


function restoreGUIDefault(handles)
%create structure to save all settings
set(handles.edit5,'String','400');
set(handles.edit6,'String','40');
set(handles.edit7,'String','110');
set(handles.edit8,'String','0.25');
set(handles.edit9,'String','3');
set(handles.edit2,'String','0.297');
set(handles.edit1,'String','0.5');
set(handles.edit3,'String','auto');
set(handles.edit4,'String','auto');
set(handles.edit11,'String','75');
set(handles.edit12,'String','auto');
set(handles.edit13,'String','auto');
set(handles.edit14,'String','auto');
set(handles.edit15,'String','auto');

set(handles.checkbox3,'Value',1);
set(handles.checkbox4,'Value',1);
set(handles.checkbox5,'Value',0);
set(handles.checkbox1,'Value',0);
set(handles.checkbox2,'Value',0);
set(handles.checkbox6,'Value',1);

set(handles.popupmenu1,'Value',2);
set(handles.popupmenu2,'Value',1);

%let Matlab GUI update
pause(0.01);


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
