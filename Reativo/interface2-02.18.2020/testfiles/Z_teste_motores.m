%ARQUIVO DE TESTE
%ESTE ARQUIVO NAO FAZ PARTE DO PROJETO
%Teste de motores para rotação

%RESULTADOS:
%Ultimo parametro como 1100 para virar 90º

global h;

%COM_CloseNXT all;
%h = COM_OpenNXT('bluetooth.ini');
%COM_SetDefaultNXT(h);

NXT_PlayTone(500, 200, h);

mC=NXTMotor('C', 'Power', -30, 'TachoLimit', 1100);%vira 90º antihorario -> tacholimit
mB=NXTMotor('B', 'Power', 30, 'TachoLimit', 1100);%vira 90º antihorario
mB.SendToNXT(h);%->provavelmente precisara de h
mC.SendToNXT(h);%->provavelmente precisara de h
%mB.WaitFor(10, h); %timeout + handle como parametros
            %mC.WaitFor(10, h); %timeout + handle como parametros
            %mB.Stop('off', h);%->provavelmente precisara de h
            %mC.Stop('off', h);%->provavelmente precisara de h
