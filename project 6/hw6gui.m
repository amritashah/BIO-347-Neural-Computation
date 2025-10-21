function varargout = hw6gui(varargin)
% HW6GUI MATLAB code for hw6gui.fig
%      This script was written by Braden Brinkman for BIO 347 / NEU 547 at
%      Stony Brook University, Nov 2020.
%      HW6GUI, by itself, creates a new HW6GUI or raises the existing
%      singleton*.
%
%      H = HW6GUI returns the handle to a new HW6GUI or the handle to
%      the existing singleton*.
%
%      HW6GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HW6GUI.M with the given input arguments.
%
%      HW6GUI('Property','Value',...) creates a new HW6GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hw6gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hw6gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hw6gui

% Last Modified by GUIDE v2.5 06-Nov-2020 17:31:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hw6gui_OpeningFcn, ...
                   'gui_OutputFcn',  @hw6gui_OutputFcn, ...
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


% --- Executes just before hw6gui is made visible.
function hw6gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hw6gui (see VARARGIN)

rng(2);
%rng(3);

N = 100; % desired number of neurons

%% random patterns to learn

Npat = 1; % number of patterns to store

X = 2*binornd(1,0.5,N,Npat)-1; % vectorized patterns

%% Train network

W = X*X'/N;

W = W - diag(diag(W));

%% Network dynamics

Tmax = 10;

q = zeros(Tmax,1);

Nflip = 0.25; % fraction, not number

% Start in random binary pattern

%v = 2*binornd(1,0.5,N,1)-1;

v = X(:,1);
rperm = randperm(N); % create a random permutation of the numbers 1 to N
if Nflip > 0
v(rperm(1:floor(Nflip*N))) = -v(rperm(1:floor(Nflip*N))); % randomly flip the state of a quarter of the neuron activities.
end
vstart = v;

%%

q(1) = vstart'*X(:,1)/N; % calculate the overlap between the pattern X(:,1) and the initial state of the network.

for t=1:(Tmax-1)
    
   v = sign(W*v); % update the neural activities of the Hopfield network
   
   q(t+1) = v'*X(:,1)/N;
    
end

handles.N = N;
handles.Tmax = Tmax;
handles.Npat = Npat;
handles.X = X;
handles.q = q;
handles.vstart = vstart;
handles.v = v;
handles.W = W;
handles.Nflip = Nflip;

 %  ax = axes;
   imagesc(handles.X1fig,reshape(handles.X(:,1),sqrt(handles.N),sqrt(handles.N)));
   xlabel(handles.X1fig,'horizontal position')
   ylabel(handles.X1fig,'vertical position')
   handles.X1fig.XTick = [];
   handles.X1fig.YTick = [];
   cmapcust = [0,0,0; 128/255, 226/255, 237/255];
   colormap(handles.X1fig,cmapcust);
   
   imagesc(handles.v0fig,reshape(handles.vstart,sqrt(handles.N),sqrt(handles.N)));
   handles.v0fig.XTick = [];
   handles.v0fig.YTick = [];
   cmapcust = [0,0,0; 128/255, 226/255, 237/255];
   colormap(handles.v0fig,cmapcust);
   
   imagesc(handles.Xendfig,reshape(handles.X(:,end),sqrt(handles.N),sqrt(handles.N)));
   handles.Xendfig.XTick = [];
   handles.Xendfig.YTick = [];
   cmapcust = [0,0,0; 128/255, 226/255, 237/255];
   colormap(handles.Xendfig,cmapcust);
   
   imagesc(handles.Wfig,handles.W)
   xlabel(handles.Wfig,'input neuron index')
   ylabel(handles.Wfig,'output neuron index')
   cmap = cmocean('balance');
   colormap(handles.Wfig,cmap);
   colorbar(handles.Wfig);
   axis square;
   
   plot(handles.qfig,(1:handles.Tmax)-1,0*handles.q,'k--','LineWidth',3);
   hold(handles.qfig,'on') 
   plot(handles.qfig,(1:handles.Tmax)-1,ones(size(handles.q)),'r-.','LineWidth',3);
   plot(handles.qfig,(1:handles.Tmax)-1,-ones(size(handles.q)),'r-.','LineWidth',3);
   plot(handles.qfig,(1:handles.Tmax)-1,handles.q,'o-','LineWidth',3);
   ylim(handles.qfig,[-1.1,1.1])
   xlabel(handles.qfig,'time step $t$','interpreter','latex','FontSize',20)
   ylabel(handles.qfig,'overlap with pattern 1, $q(t)$','interpreter','latex','FontSize',20)
   
   handles.sliderval.String = handles.Nflipslider.Value;
   handles.Npattext.String = num2str(handles.Npat);
   
   handles.Nval.String = num2str(handles.N);
   
   %handles.Nflipslider.SliderStep = [1 , 1];

% Choose default command line output for hw6gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hw6gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hw6gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in resetnetworkbutton.
function resetnetworkbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetnetworkbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rng(2);
%rng(3);

%% random patterns to learn

handles.Npat = 1; % number of patterns to store

%handles.X = handles.X(:,1);
handles.X = 2*binornd(1,0.5,handles.N,handles.Npat)-1; % vectorized patterns

%% Train network

handles.W = handles.X*handles.X'/handles.N;

handles.W = handles.W - diag(diag(handles.W));

%% Network dynamics

handles.Tmax = 10;

handles.q = zeros(handles.Tmax,1);

% Start in random binary pattern

%v = 2*binornd(1,0.5,N,1)-1;

handles.v = handles.X(:,1);
rperm = randperm(handles.N); % create a random permutation of the numbers 1 to N
if handles.Nflip > 0
handles.v(rperm(1:floor(handles.Nflip*handles.N))) = -handles.v(rperm(1:floor(handles.Nflip*handles.N))); % randomly flip the state of a quarter of the neuron activities.
end
handles.vstart = handles.v;

%%

handles.q(1) = handles.vstart'*handles.X(:,1)/handles.N;

for t=1:(handles.Tmax-1)
    
   handles.v = sign(handles.W*handles.v); 
   
   handles.q(t+1) = handles.v'*handles.X(:,1)/handles.N;
    
end


% Update handles structure
guidata(hObject, handles);

 %  ax = axes;
   imagesc(handles.X1fig,reshape(handles.X(:,1),sqrt(handles.N),sqrt(handles.N)));
   xlabel(handles.X1fig,'horizontal position')
   ylabel(handles.X1fig,'vertical position')
   handles.X1fig.XTick = [];
   handles.X1fig.YTick = [];
   cmapcust = [0,0,0; 128/255, 226/255, 237/255];
   colormap(handles.X1fig,cmapcust);
   
   imagesc(handles.v0fig,reshape(handles.vstart,sqrt(handles.N),sqrt(handles.N)));
   handles.v0fig.XTick = [];
   handles.v0fig.YTick = [];
   cmapcust = [0,0,0; 128/255, 226/255, 237/255];
   colormap(handles.v0fig,cmapcust);
   
   imagesc(handles.Xendfig,reshape(handles.X(:,end),sqrt(handles.N),sqrt(handles.N)));
   handles.Xendfig.XTick = [];
   handles.Xendfig.YTick = [];
   cmapcust = [0,0,0; 128/255, 226/255, 237/255];
   colormap(handles.Xendfig,cmapcust);
   
   imagesc(handles.Wfig,handles.W)
   xlabel(handles.Wfig,'input neuron index')
   ylabel(handles.Wfig,'output neuron index')
   cmap = cmocean('balance');
   colormap(handles.Wfig,cmap);
   colorbar(handles.Wfig);
   axis square;
   
   hold(handles.qfig,'off') 
   plot(handles.qfig,(1:handles.Tmax)-1,0*handles.q,'k--','LineWidth',3);
   hold(handles.qfig,'on') 
   plot(handles.qfig,(1:handles.Tmax)-1,ones(size(handles.q)),'r-.','LineWidth',3);
   plot(handles.qfig,(1:handles.Tmax)-1,-ones(size(handles.q)),'r-.','LineWidth',3);
   plot(handles.qfig,(1:handles.Tmax)-1,handles.q,'o-','LineWidth',3);
   ylim(handles.qfig,[-1.1,1.1])
   xlabel(handles.qfig,'time step $t$','interpreter','latex','FontSize',20)
   ylabel(handles.qfig,'overlap with pattern 1, $q(t)$','interpreter','latex','FontSize',20)
   
   handles.sliderval.String = num2str(handles.Nflipslider.Value);
   handles.Npattext.String = num2str(handles.Npat);



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


% --- Executes on button press in addpatternbutton.
function addpatternbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addpatternbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 x = 2*binornd(1,0.5,handles.N,1)-1;
 
 handles.Npat = handles.Npat + 1;
 
 handles.Npattext.String = num2str(handles.Npat);
 
 handles.X = [handles.X,x];
 
 handles.W = handles.W + (x*x'-eye(handles.N))/handles.N;
 
 
 % calculate new q(t)
 handles.q(1) = handles.vstart'*handles.X(:,1)/handles.N;

for t=1:(handles.Tmax-1)
    
   handles.v = sign(handles.W*handles.v); 
   
   handles.q(t+1) = handles.v'*handles.X(:,1)/handles.N;
    
end
 
 % Update handles structure
guidata(hObject, handles);

% Update plots
 imagesc(handles.Xendfig,reshape(handles.X(:,end),sqrt(handles.N),sqrt(handles.N)));
   handles.Xendfig.XTick = [];
   handles.Xendfig.YTick = [];
   cmapcust = [0,0,0; 128/255, 226/255, 237/255];
   colormap(handles.Xendfig,cmapcust);
   
   imagesc(handles.Wfig,handles.W)
   xlabel(handles.Wfig,'input neuron index')
   ylabel(handles.Wfig,'output neuron index')
   cmap = cmocean('balance');
   colormap(handles.Wfig,cmap);
   colorbar(handles.Wfig);
   axis square;
   
   plot(handles.qfig,(1:handles.Tmax)-1,0*handles.q,'k--','LineWidth',3);
   hold(handles.qfig,'on') 
   plot(handles.qfig,(1:handles.Tmax)-1,ones(size(handles.q)),'r-.','LineWidth',3);
   plot(handles.qfig,(1:handles.Tmax)-1,-ones(size(handles.q)),'r-.','LineWidth',3);
   plot(handles.qfig,(1:handles.Tmax)-1,handles.q,'o-','LineWidth',3);
   ylim(handles.qfig,[-1.1,1.1])
   xlabel(handles.qfig,'time step $t$','interpreter','latex','FontSize',20)
   ylabel(handles.qfig,'overlap with pattern 1, $q(t)$','interpreter','latex','FontSize',20)


% --- Executes on slider movement.
function Nflipslider_Callback(hObject, eventdata, handles)
% hObject    handle to Nflipslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.sliderval.String = sprintf('%.2f', hObject.Value);
handles.Nflip = hObject.Value;

%rng(2);
handles.v = handles.X(:,1);
rperm = randperm(handles.N); % create a random permutation of the numbers 1 to N
if handles.Nflip > 0
handles.v(rperm(1:floor(handles.Nflip*handles.N))) = -handles.v(rperm(1:floor(handles.Nflip*handles.N))); % randomly flip the state of a quarter of the neuron activities.
end
handles.vstart = handles.v;

% Update handles structure
guidata(hObject, handles);

   imagesc(handles.v0fig,reshape(handles.vstart,sqrt(handles.N),sqrt(handles.N)));
   handles.v0fig.XTick = [];
   handles.v0fig.YTick = [];
   cmapcust = [0,0,0; 128/255, 226/255, 237/255];
   colormap(handles.v0fig,cmapcust);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Nflipslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nflipslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Nslider_Callback(hObject, eventdata, handles)
% hObject    handle to Nslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% force value to be integer
hObject.Value = floor(hObject.Value);

handles.Nval.String = sprintf('%d', hObject.Value^2);
handles.N = (hObject.Value)^2;

% Update handles structure
guidata(hObject, handles);



% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Nslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
