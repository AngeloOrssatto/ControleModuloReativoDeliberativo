function varargout = interface_2(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_2_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_2_OutputFcn, ...
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


% --- Executes just before interface_2 is made visible.
function interface_2_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for interface_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_2_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;
global h;
global cntdo;
global sai;
sai=0;
cntdo=0;
clc;



% --- Executes on button press in conectarNXT.
function conectarNXT_Callback(hObject, eventdata, handles)
    global sai;
    sai=0;
    global h;
    COM_CloseNXT all;
    h = COM_OpenNXT('bluetooth.ini');
    COM_SetDefaultNXT(h);
    NXT_PlayTone(500, 200, h);
    global cntdo;
    cntdo=1;
    disp('Conexão estabelecida ');
    %COM_GetDefaultNXT(); nao necessita dessa função
    disp('conexão padrão');
    %NXT_GetFirmwareVersion(h);
    set(handles.texto_estatico,'String','Conexão estabelecida!');
    %set(handles.texto_estatico,'String','conexão padrão',COM_GetDefaultNXT());
    [protocol_version firmware_version] = NXT_GetFirmwareVersion(h); %colocar o handle(h) como parametro
    disp(protocol_version);
    disp(firmware_version);
    %set(handles.texto_estatico,'String',protocol_version,firmware_version);
    
    
    

% --- Executes on key press with focus on conectarNXT and none of its controls.
function conectarNXT_KeyPressFcn(hObject, eventdata, handles)


% --- Executes on button press in inicia_controle.
function inicia_controle_Callback(hObject, eventdata, handles)
    global sai;
    global h;%tem q colocar em todo lugar isso aqui
    sai=0;
    global cntdo;
    if(cntdo==1);
        disp('Controle Reativo em Execução...');
        while(cntdo==1 && sai==0)
            CloseSensor(SENSOR_1, h);%o h tmb tem q por em tudo quanto é canto
            CloseSensor(SENSOR_2, h);
            CloseSensor(SENSOR_4, h);
            OpenUltrasonic(SENSOR_4, 'snapshot', h); %so esse é o diferentao
            OpenSwitch(SENSOR_1, h);
            OpenSwitch(SENSOR_2, h);
            controle_reativo(sai);
        end
    else
        disp('Não é póssivel enviar os comandos ao Robô!');
        set(handles.texto_estatico,'String',' ERRO! >> Não é póssivel enviar os comandos ao Robô!');
    end    
      

% --- Executes on button press in finaliza_controle.
function finaliza_controle_Callback(hObject, eventdata, handles)
    global cntdo;
    global h;
    global sai;
    sai=1;
    if(cntdo==1)
        %StopMotor('all', 'off');
        StopMotor(MOTOR_A, 'off', h);
        StopMotor(MOTOR_B, 'off', h);
        StopMotor(MOTOR_C, 'off', h);
        %StopMotor('all', 'off');
        CloseSensor(SENSOR_1, h);
        CloseSensor(SENSOR_2, h);
        CloseSensor(SENSOR_4, h);
        disp('Execução do Controle Reativo Interrompida !');
        set(handles.texto_estatico,'String','Execução do Controle Reativo Interrompida!');
    else
        set(handles.texto_estatico,'String','A exploração não foi inicia!');
    end    
        


% --- Executes on button press in desconectar_nxt.
function desconectar_nxt_Callback(hObject, eventdata, handles)
    global cntdo;
    global h;
    if (cntdo==1)
        NXT_PlayTone(200,400,h);
        COM_CloseNXT all
        disp('Conexão finalizada');
        set(handles.texto_estatico,'String','Conexão finalizada');
        cntdo=0;
    else
        disp('Não existem conexões ativas!')
        set(handles.texto_estatico,'String','Não existem conexões ativas!');
    end    


% --- Executes during object creation, after setting all properties.
function texto_estatico_CreateFcn(hObject, eventdata, handles)
    

% --- Executes on button press in bateria.
function bateria_Callback(hObject, eventdata, handles)
    global cntdo;
    global h;
    if(cntdo==1)
        set(handles.texto_estatico,'String',NXT_GetBatteryLevel(h));
    else
        set(handles.texto_estatico,'String','ERRO! >> Não existem conexões ativas!');
    end
    
    
    
