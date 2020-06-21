function varargout = tela(varargin)
% TELA MATLAB code for tela.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tela_OpeningFcn, ...
                   'gui_OutputFcn',  @tela_OutputFcn, ...
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


% --- Executes just before tela is made visible.
function tela_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for tela
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tela wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tela_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------DECLARAÇÃO DE VARIAVEIS GLOBAIS------------------------------------

clc;
clear mapa;
load mapa.txt;

global dir;
global rota_falha;
global mapa_aux;
global mapa2;
global dimen;
global ori_li;
global ori_co;
global des_li;
global des_co;
global load_mapa;
global coordenada;
global rota_ok;
global mat;
global mapa_cam;
global altera_rota;

dir=1;
rota_falha=0;
load_mapa=0;
coordenada=0;
rota_ok=0;
mapa_aux=mapa;
dimen=size(mapa_aux);

mat=zeros(dimen(1),dimen(2));
image(mat);


% --- Executes on button press in CarregarMapa.
function CarregarMapa_Callback(hObject, eventdata, handles)
    global mapa_aux;
    global mapa2;
    global load_mapa;
    global dir;
    
    dir=1;
    load_mapa=1; 
    disp(mapa_aux)
    mapa2=num2str(mapa_aux);
    set(handles.SaidaTexto,'String',mapa2);
   


% --- Executes during object creation, after setting all properties.
function SaidaTexto_CreateFcn(hObject, eventdata, handles)


function ColunaEntradaOrigem_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ColunaEntradaOrigem_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DefinieOrigemDestino.
function DefinieOrigemDestino_Callback(hObject, eventdata, handles)
    global dimen;
    global ori_li;
    global ori_co;
    global des_li;
    global des_co;
    global mapa2;
    global mapa_aux;
    global mapa;
    global load_mapa;
    global coordenada;
    
    
    if(load_mapa==1)   
        clear mapa;
        load mapa.txt;

        A1=get(handles.LinhaEntradaOrigem,'String');
        B1=get(handles.ColunaEntradaOrigem,'String');

        A2=get(handles.LinhaEntradaDestino,'String');
        B2=get(handles.ColunaEntradaDestino,'String');

        A1=str2num(A1);
        B1=str2num(B1);

        A2=str2num(A2);
        B2=str2num(B2); 


        if((A1<=dimen(1) && A1>0) && (B1<=dimen(2) && B1>0) && (A2<=dimen(1) && A2>0) && (B2<=dimen(2) && B2>0) && mapa(A1,B1)==0 && mapa(A2,B2)==0)
            ori_li=A1;
            ori_co=B1;
            des_li=A2;
            des_co=B2;
            
            mapa_aux=mapa;
            mapa_aux(A1,B1)=2;
            mapa_aux(A2,B2)=3;
            mapa2=num2str(mapa_aux);
            
            coordenada=1;

            set(handles.SaidaTexto,'String',mapa2);     
        else
            set(handles.SaidaTexto,'String','Coordenada inválida');
            coordenada=0;
            errordlg('Por favor, corrija as coordenadas.', 'Erro');
            return;
        end
    else
       set(handles.SaidaTexto,'String','Carregue o mapa');
    end
    
function ColunaEntradaDestino_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ColunaEntradaDestino_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DefineDestino.
function DefineDestino_Callback(hObject, eventdata, handles)   
    

function LinhaEntradaDestino_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function LinhaEntradaDestino_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LinhaEntradaOrigem_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function LinhaEntradaOrigem_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function LinhaOrigem_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in GerarRota.
function GerarRota_Callback(hObject, eventdata, handles)
    global coordenada;
    global rota_ok;
    global mat;

    
    if(coordenada==1)
        gerar_rota();
        rota_ok=1; 
    else
       image(mat);
       set(handles.SaidaTexto,'String','Esperando Coordenadas');
       rota_ok=0;
    end

% --- Executes on button press in ExecutarRota.
function ExecutarRota_Callback(hObject, eventdata, handles)
    global rota_ok;
    global mapa_cam;
    global altera_rota;
    global h;
  
    if(rota_ok==1)
        executa_rota();
        if(altera_rota==1)
            set(handles.SaidaTexto,'String','Obstáculo detectado! Gerando nova rota');
            gerar_rota(); 
            pause(3);
            set(handles.SaidaTexto,'String','Execute a rota novamente');
        else
            NXT_PlayTone(400, 200, h);
            msgbox('Destino alcançado.', 'Alerta');
        end
    else
        set(handles.SaidaTexto,'String','Não ha Rotas');
    end
    
    


% --- Executes on button press in RedefineOrigemDestino.
function RedefineOrigemDestino_Callback(hObject, eventdata, handles)
    global mapa_aux
    global coordenada;
    
    clear mapa;
    load mapa.txt;
    
    coordenada=0;
    mapa_aux=mapa;
    mapa2=num2str(mapa_aux);
            
    set(handles.SaidaTexto,'String',mapa2);     
    
    set(handles.ColunaEntradaOrigem,'String','0');
    set(handles.LinhaEntradaOrigem,'String','0');
    set(handles.ColunaEntradaDestino,'String','0');
    set(handles.LinhaEntradaDestino,'String','0');
     
 


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
   
