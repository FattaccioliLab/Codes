function varargout = Rayon2(varargin)
% RAYON2 M-file for Rayon2.fig
%      RAYON2, by itself, creates a new RAYON2 or raises the existing
%      singleton*.
%
%      H = RAYON2 returns the handle to a new RAYON2 or the handle to
%      the existing singleton*.
%
%      RAYON2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAYON2.M with the given input arguments.
%
%      RAYON2('Property','Value',...) creates a new RAYON2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Rayon2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Rayon2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Rayon2

% Last Modified by GUIDE v2.5 08-Nov-2005 19:02:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Rayon2_OpeningFcn, ...
                   'gui_OutputFcn',  @Rayon2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Rayon2 is made visible.
function Rayon2_OpeningFcn(hObject, eventdata, handles, varargin)
clc;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Rayon2 (see VARARGIN)

% Choose default command line output for Rayon2
handles.output = hObject;

handles.filename=[];
handles.directory=[];
handles.index=1;
handles.data=[];
handles.datarecap=[];

handles.radius=[];
handles.theory=textread('manipe_theory.txt');
handles.mesure=[];
handles.simul=[];
handles.rayon=textread('rayon.txt');
set(handles.pop_radius,'String',handles.rayon);

handles.min=1.17;
handles.max=0.97;
% Update handles structure
guidata(hObject, handles);

% axes(handles.graph);
% h=plot(handles.mesure(:,1)*1.17,handles.mesure(:,2)*0.98,'b.','Markersize',1);
% hold on
% %h=plot(handles.theory(:,1),handles.theory(:,2),'r.','Markersize',1)
% h=plot(handles.simul(:,1),handles.simul(:,2),'g+','Markersize',3);
% hold off
% set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);

% UIWAIT makes Rayon2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Rayon2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function pop_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in pop_radius.
function pop_radius_Callback(hObject, eventdata, handles)
% hObject    handle to pop_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pop_radius contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_radius

result=get(handles.pop_radius,'Value') %indice selectionné
s=size(handles.simul);

for i=1:s(1)
    if handles.simul(i,3)==handles.rayon(result)
        in(i)=1;
    else in(i)=0;
    end
end
in=logical(in);
zer=rand(1,s(1)).*0;
axes(handles.graph);
h=plot(handles.mesure(~in,1)*1.17,handles.mesure(~in,2)*0.98,'bo','Markersize',1);
hold on
plot(handles.mesure(in,1)*1.17,handles.mesure(in,2)*0.98,'r*','Markersize',3);
hold off
set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);


axes(handles.graph2)
cla;
bins=[10:1:10000];
if in==logical(zer)
xlim([1 10000])
set(gca,'Xscale','log');
set(handles.edit_moyenne,'String','Pas de points')
else
hist(10.^(handles.mesure(in,3)./256),bins);
xlim([1 10000])
set(gca,'Xscale','log');
a=mean(10.^(handles.mesure(in,3)./256))
set(handles.edit_moyenne,'String',a)

end





% --- Executes during object creation, after setting all properties.
function edit_moyenne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_moyenne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_moyenne_Callback(hObject, eventdata, handles)
% hObject    handle to edit_moyenne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_moyenne as text
%        str2double(get(hObject,'String')) returns contents of edit_moyenne as a double


% --- Executes on button press in push_scan.
function push_scan_Callback(hObject, eventdata, handles)
clc;
% hObject    handle to push_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=size(handles.rayon);
s=size(handles.simul);
% for j=1:1:p(1) 
%     for i=1:s(1)
%         if handles.simul(i,3)==handles.rayon(j)
%              in(i,j)=1;
%         else in(i,j)=0;
%         end
%     end
% end
% 


% diff=handles.simul(:,3)*ones(1,s(1))-ones(p(1),1)*handles.rayon'
% diff=(diff==0)
    in=(handles.simul(:,3)*ones(1,p(1))-ones(s(1),1)*handles.rayon'==0);
    in=logical(in);
%     zer=rand(s(1),1).*0;
    
for j=1:1:p(1) 
    if in(:,j)==logical(rand(s(1),1).*0)
        moyenne(j,1)=handles.rayon(j);
        moyenne(j,2)=0;       
    else   
        moyenne(j,1)=handles.rayon(j);
        moyenne(j,2)=mean(10.^(handles.mesure(in(:,j),3)./256));
    end
end

handles.index
axes(handles.graph3);
name=char(handles.datarecap(handles.index));
name = strrep(name,handles.directory,strcat(handles.directory,'moy_'));

dlmwrite(name, moyenne, '\t');
h=plot(moyenne(:,1),moyenne(:,2));
set(gca,'Xlim',[0 handles.rayon(p(1))],'Ylim',[0 10000]);


% --- Executes during object creation, after setting all properties.
function edit_recap_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_recap_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_courant_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_courant_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_index_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_index_Callback(hObject, eventdata, handles)



% --- Executes on button press in push_recap.
function push_recap_Callback(hObject, eventdata, handles)
[FileNameRecap,PathNameRecap] = uigetfile('*.txt','Select the Txt file');


pathfilerecap=strcat(PathNameRecap,FileNameRecap)
datarecap=textread(pathfilerecap,'%q');

set(handles.edit_recap,'String', FileNameRecap)

%A partir de ce fichier, on choisit le premier fichier de mesure
%ici on fixe la valeur de l'index à la premiere ligne du fichier
handles.index=1;
handles.datarecap=datarecap;
handles.filename=strcat(FileNameRecap);
handles.directory=PathNameRecap;
guidata(hObject,handles)

set(handles.edit_index,'String', handles.index)
set(handles.edit_courant,'String', datarecap(handles.index))

data_courant=textread(char(datarecap(handles.index)));

data_courant=textread(char(handles.datarecap(handles.index)));
handles.mesure(:,1)=data_courant(:,1)*handles.min;
handles.mesure(:,2)=data_courant(:,2)*handles.max;
handles.mesure(:,3)=data_courant(:,3);
guidata(hObject,handles);

axes(handles.graph);
h=plot(handles.mesure(:,1),handles.mesure(:,2),'r.','Markersize',1)
hold on
h=plot(handles.theory(:,1),handles.theory(:,2),'b-')
hold off
set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);


% --- Executes on button press in push_previous.
function push_previous_Callback(hObject, eventdata, handles)
% hObject    handle to push_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index==1 
    handles.index=1
else handles.index=handles.index-1;
end
handles.mesure=[];

set(handles.edit_courant,'String', handles.datarecap(handles.index))

data_courant=textread(char(handles.datarecap(handles.index)));

data_courant=textread(char(handles.datarecap(handles.index)));
handles.mesure(:,1)=data_courant(:,1)*handles.min;
handles.mesure(:,2)=data_courant(:,2)*handles.max;
handles.mesure(:,3)=data_courant(:,3);
guidata(hObject,handles);

set(handles.edit_index,'String', handles.index)

axes(handles.graph);
h=plot(handles.mesure(:,1),handles.mesure(:,2),'r.','Markersize',1)
hold on
h=plot(handles.theory(:,1),handles.theory(:,2),'b-')
hold off
set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);


% --- Executes on button press in push_next.
function push_next_Callback(hObject, eventdata, handles)
 handles.index=handles.index+1;
 handles.mesure=[];
 guidata(hObject,handles);

set(handles.edit_courant,'String', handles.datarecap(handles.index))
set(handles.edit_index,'String', handles.index)

data_courant=textread(char(handles.datarecap(handles.index)));
handles.mesure(:,1)=data_courant(:,1)*handles.min;
handles.mesure(:,2)=data_courant(:,2)*handles.max;
handles.mesure(:,3)=data_courant(:,3);
guidata(hObject,handles);

set(handles.edit_index,'String', handles.index)

axes(handles.graph);
h=plot(handles.mesure(:,1),handles.mesure(:,2),'r.','Markersize',1)
hold on
h=plot(handles.theory(:,1),handles.theory(:,2),'b-')
hold off
set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);


% --- Executes on button press in push_fit.
function push_fit_Callback(hObject, eventdata, handles)
clc;
handles.simul=[];
guidata(hObject,handles);

sa=size(handles.rayon');  
sm=size(handles.mesure);

[fs_fit,S_fs,mu_fs]=polyfit(handles.theory(:,3),handles.theory(:,1),14);
fs_interp=polyval(fs_fit,handles.rayon',[],mu_fs);

[ss_fit,S_ss,mu_ss]=polyfit(handles.theory(:,3),handles.theory(:,2),3);
ss_interp=polyval(ss_fit,handles.rayon',[],mu_ss);

%creation des vecteurs de calcul
%creation de la matrice de calcul : lignes : mesure / colonne : interpolation
%on calcule la distance entre chaque point de mesure et les points de l'interpolation


DX=handles.mesure(:,1)*ones(1,sa(2))-ones(sm(1),1)*fs_interp;
DY=handles.mesure(:,2)*ones(1,sa(2))-ones(sm(1),1)*ss_interp;


d=((DX).^2+(DY).^2).^0.5;
dmin=d.';
[A,I]=min(dmin);

name=char(handles.datarecap(handles.index));
name = strrep(name,handles.directory,strcat(handles.directory,'fit_'));
fid=fopen(name,'w+');

for i=1:sm(1)
    handles.simul(i,1)=fs_interp(I(i));
    handles.simul(i,2)=ss_interp(I(i));
    handles.simul(i,3)=handles.rayon(I(i));
    guidata(hObject,handles);
    fprintf(fid,'%g\t %g\t %g\r',handles.simul(i,1),handles.simul(i,2),handles.simul(i,3));
end

fclose(fid);

axes(handles.graph);
h=plot(handles.mesure(:,1),handles.mesure(:,2),'r.','Markersize',1)
hold on
h=plot(handles.simul(:,1),handles.simul(:,2),'go','Markersize',2)
hold off
set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);


% --- Executes during object creation, after setting all properties.
function edit_min_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min as text
%        str2double(get(hObject,'String')) returns contents of edit_min as a double
handles.min=str2num(get(handles.edit_min,'String'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_max as text
%        str2double(get(hObject,'String')) returns contents of edit_max as a double
handles.max=str2num(get(handles.edit_max,'String'));
guidata(hObject,handles);


% --- Executes on button press in push_reload.
function push_reload_Callback(hObject, eventdata, handles)
% hObject    handle to push_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data_courant=textread(char(handles.datarecap(handles.index)));
handles.mesure(:,1)=data_courant(:,1)*handles.min;
handles.mesure(:,2)=data_courant(:,2)*handles.max;
handles.mesure(:,3)=data_courant(:,3);
guidata(hObject,handles);
set(handles.edit_index,'String', handles.index)

axes(handles.graph);
h=plot(handles.mesure(:,1),handles.mesure(:,2),'r.','Markersize',1)
hold on
h=plot(handles.theory(:,1),handles.theory(:,2),'b-')
hold off
set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);


