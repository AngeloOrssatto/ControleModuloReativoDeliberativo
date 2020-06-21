%ARQUIVO DE TESTE
%ESSE ARQUIVO NAO FAZ PARTE DO PROJETO
%Teste sobre o funcionamento do sensor ultrassonico

%RESULTADOS:
%Utilizar a forma OpenUltrassonic(sensor, mode, handle) onde:
%sensor = SENSOR_4; mode = '', handle = h

global h;
global echos;

COM_CloseNXT all;
h = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(h);
NXT_PlayTone(500, 200, h);

OpenUltrasonic(SENSOR_4, '', h);
%USMakeSnapshot(SENSOR_4, h);
%pause(0.1); 

echos = GetUltrasonic(SENSOR_4, h);
disp(echos);

while(1)
    
    if(echos >= 15)
        mBC=NXTMotor('BC', 'Power', 25);
        mBC.SendToNXT(h);
        pause(1);
    
        %USMakeSnapshot(SENSOR_4, h);
        pause(0.1); 
        echos = GetUltrasonic(SENSOR_4, h);
        disp(echos);
        %StopMotor('all', 'off', h);

        %mBC=NXTMotor('BC', 'Power', -30);
        %mBC.SendToNXT(h);
        %pause(1);
        %disp(echos);
    
 

    else
        mBC=NXTMotor('BC', 'Power', -25);
        mBC.SendToNXT(h);
        pause(1);

        %USMakeSnapshot(SENSOR_4, h);
        pause(0.1); 
        echos = GetUltrasonic(SENSOR_4, h);
        disp(echos);
        %StopMotor('all', 'off', h);

        %mBC=NXTMotor('BC', 'Power', -30);
        %mBC.SendToNXT(h);
        %pause(1);
        %disp(echos);
    
    end    
end
StopMotor('all', 'off', h);
CloseSensor(SENSOR_4, h);
NXT_PlayTone(500, 200, h);
