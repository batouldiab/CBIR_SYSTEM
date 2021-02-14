function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 13-Feb-2021 11:53:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.originalimage, 'Visible','off');

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in b1.
function b1_Callback(hObject, eventdata, handles)
[filename, pathname]=uigetfile( {'*.jpg';'*.jpeg';'*.gif';'*.png';'*.bmp'},'Select file'); 
%This code checks if the user pressed cancel on the dialog.
        if isequal(filename,0) || isequal(pathname,0)
            uiwait(msgbox ('User pressed cancel','failed','modal')  )
            hold on;
        else
            hold off;
            name = strcat(pathname, filename);
            MyImage=imread(name);
            set(handles.edit1,'string',name);
            handles.MyImage = MyImage;
            imshow(MyImage,'Parent',handles.originalimage);
            setappdata(0,'originalimage',MyImage);
        end
handles.axes   = axes;
guidata(handles.axes, handles);
handles.output = hObject;
%setappdata(0,'handles',handles);
guidata(hObject, handles);





% --- Executes on button press in b2.
function b2_Callback(hObject, eventdata, handles)
%set(handles.edit4,'string','Processing Please Wait..');
%guidata(hObject, handles);
%set(handles.pleasewait,'string','Please Consider That The Process Might Take Some Time');
%guidata(hObject, handles);
name=get(handles.edit1,'string');
imageFolder=get(handles.edit2,'string');

if(strcmp(name,'Original Image Path')==1)
    uiwait( msgbox('Please Add An Image to process'));
else
    if(strcmp(imageFolder,'Original Database Path')==1)
        uiwait( msgbox('Please Add An Image Datase Folder'));
    else

    uiwait( msgbox('The Operation Will Take Time, Please Wait Till You Are Notified'));

    originalimage=imread(name);
    disp('Processing Started')

    [ similarityValues,  euclideanDistances, fileNames]=retrieve(originalimage,name,imageFolder);

    assignin('base','similarityValues',similarityValues)
    assignin('base','euclideanDistances',euclideanDistances)
    assignin('base','fileNames',fileNames)
    
    knn=9;
    freq = cell(knn,2);
    for k =1:length(freq)
        freq(k,1) = {'empty'};
        freq(k,2) = {0};
    end
    for i=1:9
        subPath=regexp(fileNames{i+1},'\','split');
        n=numel(subPath);
        animalName=subPath{n-2};
        %disp(animalName);
        presentInTable= 0;
        for row=1:knn
            if (strcmp(animalName,freq(row,1)))
                presentInTable=1;
                prev=cell2mat(freq(row,2));
                x=prev+1;
                freq(row,2)= num2cell(x);
            end
        end
        if (presentInTable==0)
            for k=1:knn
                if (strcmp(freq(k,1),'empty'))
                    freq(k,1)={animalName};
                    freq(k,2)=num2cell(1);
                    break;
                end
            end
        end
        I=imread(fileNames{i+1});
        subplot(3,3,i);
        imshow(I);
    end
    
    assignin('base','freq',freq)
    max=0;
    mostVoted='';
    for k=1:knn
        temp= cell2mat(freq(k,2));
        if(temp>max)
            max=cell2mat(freq(k,2));
            mostVoted=freq(k,1);
        end
    end
    str=char(mostVoted);
    message = sprintf('Pridicted Animal Name: %s % ', str);
    uiwait( msgbox(message));
    disp(message)
    end
    
end



% --- Executes on button press in b3.
function b3_Callback(hObject, eventdata, handles)
% hObject    handle to b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message ='Enter The Testing Dataset';
uiwait(msgbox(message, 'modal'));
imageFolderTesting = uigetdir();
if(imageFolderTesting==0)
    uiwait(msgbox ('User pressed cancel','failed','modal')  )
else
    disp('Processing Started')

    [ animalsImageSet, numberOfFiles ,fullFileNames] = getImages(imageFolderTesting);

    message ='Enter The Main Dataset';
    uiwait(msgbox(message, 'modal'));
    imageFolder = uigetdir();
    if(imageFolder==0)
        uiwait(msgbox ('User pressed cancel','failed','modal')  )
    else

        uiwait( msgbox('The Operation Will Take Time, Please Wait Till You Are Notified'));
        t=0.0;
        f=0.0;
        for nof=1:numberOfFiles
            originalimage = imread(animalsImageSet.Files{nof});
            currentfilename= fullFileNames{nof};

            [ similarityValues,  euclideanDistances, fileNames]=retrieve(originalimage,currentfilename,imageFolder);

            knn=9;
            freq = cell(knn,2);

            subPath=regexp(fileNames{1},'\','split');
            n=numel(subPath);
            animalNameOriginal=subPath{n-2};

            for k =1:length(freq)
                freq(k,1) = {'empty'};
                freq(k,2) = {0};
            end

            for i=1:knn
                subPath=regexp(fileNames{i+1},'\','split');
                n=numel(subPath);
                animalName=subPath{n-2};

                presentInTable= 0;
                for row=1:knn
                    if (strcmp(animalName,freq(row,1)))
                        presentInTable=1;
                        prev=cell2mat(freq(row,2));
                        x=prev+1;
                        freq(row,2)= num2cell(x);
                    end
                end
                if (presentInTable==0)
                    for k=1:knn
                        if (strcmp(freq(k,1),'empty'))
                            freq(k,1)={animalName};
                            freq(k,2)=num2cell(1);
                            break;
                        end
                    end
                end
            end

            max=0;
            mostVoted='';
            for k=1:knn
                temp= cell2mat(freq(k,2));
                if(temp>max)
                    max=cell2mat(freq(k,2));
                    mostVoted=freq(k,1);
                end
            end
            if(strcmp(mostVoted,animalNameOriginal))
                t=t+1;
            else
                f=f+1;
            end
            progress=(nof/numberOfFiles)*100;
            message = sprintf(' %f %% done', progress);
            disp(message);

        end
        accuracy=t*100/(t+f);
        message = sprintf('After Processing The Testing Data, Accuracy = %f % ', accuracy);
        disp(accuracy)
        uiwait(msgbox(message, 'modal'));
    end
end






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


function setGlobalNumberOfFiles(val)
global numberOfFiles
numberOfFiles = val;


function r = getGlobalNumberOfFiles
global numberOfFiles
r = numberOfFiles;

function setGlobalAnimalsImageSet(val)
global animalImageSet
animalImageSet = val;

function r = getGlobalAnimalsImageSet
global animalImageSet
r = animalImageSet;

function setGlobalPath(p)
global folderPath
folderPath = p;

function r = getGlobalPath
global folderPath
r = folderPath;

function sethObject(hObject)
global hObj
hObj=hObject;

function ho = gethObject
global hObj
ho = hObj;

function sethandles(handles)
global h
h=handles;

function han = gethandles
global h
han = h;
% --- Executes during object creation, after setting all properties.
function pleasewait_CreateFcn(hObject, eventdata, handles)
set(hObject,'string','Please Consider That The Process Might Take Some Time');
guidata(hObject, handles); 


% --- Executes on button press in b4.
function b4_Callback(hObject, eventdata, handles)
imageFolder = uigetdir();
if(imageFolder==0)
    uiwait(msgbox ('User pressed cancel','failed','modal')  )
else
    setGlobalPath(imageFolder);
    animalsImageSet = imageDatastore(imageFolder,'LabelSource','foldernames','IncludeSubfolders',true);
    setGlobalNumberOfFiles(numel(animalsImageSet.Files));
    setGlobalAnimalsImageSet(animalsImageSet);
    set(handles.edit2,'string',imageFolder);
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
