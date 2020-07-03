global h;

%COM_CloseNXT all;
%h=COM_OpenNXT('bluetooth.ini');
%COM_SetDefaultNXT(h);
%NXT_PlayTone(500, 200, h);
    
OpenUltrasonic(SENSOR_4, '', h);
OpenSwitch(SENSOR_1, h);

velo_frente=70;
velo_gira=45;
distancia=850; %para andar 30cm, distancia = 800
angulo=1100;

%pra frente
%----------------------------------------------------------------%
%mBC=NXTMotor('BC', 'Power', velo_frente, 'TachoLimit', distancia);
%mBC.SendToNXT(h);            
%mBC.WaitFor(10, h);                              
%mBC.Stop('brake', h);

%mBC.ResetPosition(h);


%vira 180º TA TOP
%-----------------------------------------------------------
mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',2*angulo);
mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',2*angulo);
mB.SendToNXT(h);            
mC.SendToNXT(h);
mB.WaitFor(10, h);                              
mC.WaitFor(10, h);        
StopMotor('all', 'off', h);
%tem que girar 2*angulo


%NXT_PlayTone(500, 200, h);

%vira -90º
%-----------------------------------------------------
mB=NXTMotor('B', 'Power', -velo_gira,'TachoLimit', angulo+100);
mC=NXTMotor('C', 'Power', velo_gira,'TachoLimit', angulo);
mB.SendToNXT(h);
mC.SendToNXT(h);
mB.WaitFor(10, h); 
mC.WaitFor(10, h);        
StopMotor('all', 'off', h);

mC.ResetPosition(h);
mB.ResetPosition(h);


NXC_ResetErrorCorrection(MOTOR_B, h);
NXC_ResetErrorCorrection(MOTOR_C, h)

%tem que girar 1*angulo

%vira 90º
%-----------------------------------------------------
mB=NXTMotor('B', 'Power', velo_gira,'TachoLimit', 1100);
mC=NXTMotor('C', 'Power', -velo_gira,'TachoLimit',1100);
mB.SendToNXT(h);
mC.SendToNXT(h);
mB.WaitFor(10, h); 
mC.WaitFor(10, h);        
StopMotor('all', 'off', h);

