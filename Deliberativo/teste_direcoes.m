global h;

%COM_CloseNXT all;
%h=COM_OpenNXT('bluetooth.ini');
%COM_SetDefaultNXT(h);
NXT_PlayTone(500, 200, h);
    
OpenUltrasonic(SENSOR_4, '', h);
OpenSwitch(SENSOR_1, h);

velo_frente=70;
velo_gira=45;
distancia=800; %para andar 30cm, distancia = 800
angulo=1100;

%pra frente
%mBC=NXTMotor('BC', 'Power', velo_frente, 'TachoLimit', distancia);
%mBC.SendToNXT(h);            
%mBC.WaitFor(10, h);                              
%mBC.Stop('brake', h);

%vira 180� TA TOP
%mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',4*angulo);
%mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',4*angulo);
%mB.SendToNXT(h);            
%mC.SendToNXT(h);
%mB.WaitFor(10, h);                              
%mC.WaitFor(10, h);        
%mB.Stop('brake', h);
%mC.Stop('brake', h);
%tem que girar 4*angulo

mC.ResetPosition(h);
mB.ResetPosition(h);


%vira 90�
mB=NXTMotor('B', 'Power', -velo_gira,'TachoLimit', 1100);
mC=NXTMotor('C', 'Power', velo_gira,'TachoLimit',1100);
mB.SendToNXT(h);
mC.SendToNXT(h);
mB.WaitFor(0, h); 
mC.WaitFor(0, h);        
mB.Stop('brake', h);
mC.Stop('brake', h);

%tem que girar 2*angulo


