function [] = executa_rota()
    
    global h;
    global mapa_atual;
    global dir;
    global rota_falha;
    global listcam2;
    global tam;
    global mapa_cam;
    global ori_li;
    global ori_co;
    global altera_rota;
    
    rota_falha=0;  
    load mapa.txt;
    mapa_atual=mapa;
    mapa_marc=mapa_cam;
    
    altera_rota=0;
       
    
    COM_CloseNXT all;
    h = COM_OpenNXT('bluetooth.ini');
    COM_SetDefaultNXT(h);
    NXT_PlayTone(500, 200, h);
    
    OpenUltrasonic(SENSOR_4, '', h);
    OpenSwitch(SENSOR_1, h);
    
    velo_frente=70;
    velo_gira=45;
    distancia=850;
    %ditancia=1050;
    angulo=1100;
    %angulo=550;
        
    %-------------------------------------------------------------------------

    NXC_ResetErrorCorrection(MOTOR_B, h);
    NXC_ResetErrorCorrection(MOTOR_C, h);
    StopMotor('all', 'off', h);

    %------------------------------------------------------------------------

    ind=1;
    celatual=struct('linha',{},'coluna',{});

    % dir==1, sentido oeste -> leste;
    % dir==2, sentido leste -> oeste;
    % dir==3, sentido norte -> sul;
    % dir==4, sentido sul -> norte;

    celatual(ind).linha=listcam2(1).linha;
    celatual(ind).coluna=listcam2(1).coluna;
    disp(celatual(ind))
    
    mapa_marc(celatual(ind).linha,celatual(ind).coluna)=50;
    image(mapa_marc);
    pause(2);
  
    mBC=NXTMotor('BC', 'Power', velo_frente, 'TachoLimit', distancia);
    %motorBC=NXTMotor('BC', 'Power', velo_frente);

    dir=1; %orientação inicia oeste -> leste;

    
    for i=1:(tam(2)-1)
            if(listcam2(i).linha==listcam2(i+1).linha) 
                if(listcam2(i).coluna<listcam2(i+1).coluna)
                    switch dir
                        case 1
                            % mantem direção atual
                            disp('mantem direção oeste->leste');
                        case 2
                            % gira robo 180º
                            disp('altera direção atual leste->oeste para oeste->leste');
                            dir=1; %atualiza direção atual
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',2*angulo);
                             mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',2*angulo);
                             mB.SendToNXT(h);            
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h);                              
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                           %-------------------------------------------------------
                        case 3
                            % gira 90º para o leste 
                            disp('altera direção atual norte->sul para oeste->leste');
                            dir=1; %atualiza direção atual
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',angulo);
                             mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',angulo);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                        case 4
                            % gira 90º para o oeste 
                            disp('altera direção atual sul->norte para oeste->leste');
                            dir=1; %atualiza direnção atual
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',velo_gira, 'TachoLimit',angulo);
                             mB=NXTMotor('B', 'Power',-velo_gira, 'TachoLimit',angulo+100);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                           %-------------------------------------------------------
                            
                    end
                    disp('anda para frente')
                    %--------------------------------------------------------------
                    motorBC.ResetPosition(h);
                    data = motorBC.ReadFromNXT(h);
                    dist=GetUltrasonic(SENSOR_4, h);
                    toqdian=GetSwitch(SENSOR_1, h);
                    motorBC.SendToNXT(h);
                    aux=0;
                    volta=0;

                    while((dist>14) && (toqdian==0) && (data.Position<distancia))
                        dist=GetUltrasonic(SENSOR_4, h);
                        toqdian=GetSwitch(SENSOR_1, h);
                        data = motorBC.ReadFromNXT(h);
                        if(toqdian==1)
                            aux=1;
                        end
                        if(toqdian==1 || (dist<15))
                            volta=1;
                        end
                    end

                    motorBC.Stop('brake', h);

                    if(aux==1)
                        data.Position=data.Position-100;
                    end

                    if(volta==1) 
                        motorBC = NXTMotor('BC', 'Power', -50 , 'TachoLimit' , data.Position);
                        motorBC.SendToNXT(h);
                        motorBC.WaitFor(10, h);
                        motorBC.ResetPosition(h);
                        disp(celatual(ind))
                        ori_li=celatual(ind).linha;
                        ori_co=celatual(ind).coluna;
                        mapa_atual(listcam2(i+1).linha,listcam2(i+1).coluna)=1;
                        rota_falha=1;
                        disp(mapa_cam)
                        gerar_rota();
                        altera_rota=1;
                        break;
                    else
                        clear mapa_marc;
                        mapa_marc=mapa_cam;
                        ind=ind+1;
                        celatual(ind).linha=listcam2(i+1).linha;
                        celatual(ind).coluna=listcam2(i+1).coluna;
                        mapa_marc(celatual(ind).linha,celatual(ind).coluna)=50;
                        image(mapa_marc);
                        disp(celatual(ind))    
                    end
                    pause(1);
                    %--------------------------------------------------------------
                else
                    switch dir
                        case 1
                            % gira robo 180º
                            disp('altera direção atual oeste->leste para leste->oeste');
                            dir=2; %atualiza direção
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',2*angulo);
                             mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',2*angulo);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                        case 2
                            % mantem direção atual
                            disp('mantem direção leste->oeste ');
                        case 3
                            % gira 90º para o oeste
                            disp('altera direção atual norte->sul para leste->oeste');
                            dir=2; %atualiza direção
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',velo_gira, 'TachoLimit',angulo);
                             mB=NXTMotor('B', 'Power',-velo_gira, 'TachoLimit',angulo+100);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                        case 4
                            % gira 90º para o leste
                            disp('altera direção atual sul->norte para leste->oeste');
                            dir=2; %atualiza direção
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',angulo);
                             mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',angulo);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                             
                    end
                    disp('anda para frente')
                    %--------------------------------------------------------------               
                    motorBC.ResetPosition(h);
                    data = motorBC.ReadFromNXT(h);
                    dist=GetUltrasonic(SENSOR_4, h);
                    toqdian=GetSwitch(SENSOR_1, h);
                    motorBC.SendToNXT(h);
                    aux=0;
                    volta=0;
                    while((dist>14) && (toqdian==0) && (data.Position<distancia))
                        dist=GetUltrasonic(SENSOR_4, h);
                        toqdian=GetSwitch(SENSOR_1, h);
                        data = motorBC.ReadFromNXT(h);
                        if(toqdian==1)
                            aux=1;
                        end
                        if(toqdian==1 || (dist<15))
                            volta=1;
                        end
                    end

                    motorBC.Stop('brake', h);

                    if(aux==1)
                        data.Position=data.Position-100;
                    end

                    if(volta==1) 
                        motorBC = NXTMotor('BC', 'Power', -50 , 'TachoLimit' , data.Position);
                        motorBC.SendToNXT(h);
                        motorBC.WaitFor(10, h);
                        motorBC.ResetPosition(h);
                        disp(celatual(ind))
                        ori_li=celatual(ind).linha;
                        ori_co=celatual(ind).coluna;
                        mapa_atual(listcam2(i+1).linha,listcam2(i+1).coluna)=1;
                        rota_falha=1;
                        disp(mapa_cam)
                        gerar_rota();
                        pause(2);
                        executa_rota();
                        break;
                    else
                        clear mapa_marc;
                        mapa_marc=mapa_cam;
                        ind=ind+1;
                        celatual(ind).linha=listcam2(i+1).linha;
                        celatual(ind).coluna=listcam2(i+1).coluna;
                        mapa_marc(celatual(ind).linha,celatual(ind).coluna)=50;
                        image(mapa_marc);
                        disp(celatual(ind));   
                    end
                    %--------------------------------------------------------------
                    pause(1);
                end
            end
            if(listcam2(i).coluna==listcam2(i+1).coluna)
                if(listcam2(i).linha<listcam2(i+1).linha)
                    switch dir
                        case 1
                            % gira robo 90º para o sul
                            disp('altera direção atual oeste->leste para norte->sul');
                            dir=3; %atualiza direção atual
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',velo_gira, 'TachoLimit',angulo);
                             mB=NXTMotor('B', 'Power',-velo_gira, 'TachoLimit',angulo+100);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                        case 2
                            % gira robo 90º para o sul
                            disp('altera direção atual leste->oeste para norte->sul');
                            dir=3; %atualiza direção atual
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',angulo);
                             mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',angulo);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                        case 3
                            % mantem direção atual 
                            disp('mantem direção norte->sul');
                        case 4
                            % gira robo 180º  
                            disp('altera direção atual sul->norte para norte-sul');
                            dir=3; % atualiza direção atual
                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',2*angulo);
                             mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',2*angulo);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                    end
                    disp('anda para frente')
                    %--------------------------------------------------------------
                    motorBC.ResetPosition(h);
                    data = motorBC.ReadFromNXT(h);
                    dist=GetUltrasonic(SENSOR_4, h);
                    toqdian=GetSwitch(SENSOR_1, h);
                    motorBC.SendToNXT(h);
                    aux=0;
                    volta=0;

                    while((dist>14) && (toqdian==0) && (data.Position<distancia))
                        dist=GetUltrasonic(SENSOR_4, h);
                        toqdian=GetSwitch(SENSOR_1, h);
                        data = motorBC.ReadFromNXT(h);
                        if(toqdian==1)
                            aux=1;
                        end
                        if(toqdian==1 || (dist<15))
                            volta=1;
                        end
                    end

                    motorBC.Stop('brake', h);

                    if(aux==1)
                        data.Position=data.Position-100;
                    end

                    if(volta==1) 
                        motorBC = NXTMotor('BC', 'Power', -50 , 'TachoLimit' , data.Position)
                        motorBC.SendToNXT(h);
                        motorBC.WaitFor(10, h);
                        motorBC.ResetPosition(h);
                        disp(celatual(ind))
                        ori_li=celatual(ind).linha;
                        ori_co=celatual(ind).coluna;
                        mapa_atual(listcam2(i+1).linha,listcam2(i+1).coluna)=1;
                        rota_falha=1;
                        disp(mapa_cam)
                        gerar_rota();
                        altera_rota=1;
                        break;
                    else
                        clear mapa_marc;
                        mapa_marc=mapa_cam;
                        ind=ind+1;
                        celatual(ind).linha=listcam2(i+1).linha;
                        celatual(ind).coluna=listcam2(i+1).coluna;
                        mapa_marc(celatual(ind).linha,celatual(ind).coluna)=50;
                        image(mapa_marc);
                        disp(celatual(ind))    
                    end
                    %--------------------------------------------------------------
                    pause(1);
                else
                     switch dir
                        case 1
                            % gira robo 90º para o norte
                            disp('altera direção atual oeste->leste para sul-norte');
                            dir=4; %atualiza a posição atual

                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',velo_gira, 'TachoLimit',angulo);
                             mB=NXTMotor('B', 'Power',-velo_gira, 'TachoLimit',angulo+100);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------

                         case 2
                            % gira robo 90º para o sul
                            disp('altera direção atual leste->oeste para sul-norte');
                            dir=4; %atualiza a posição atual

                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',velo_gira, 'TachoLimit',angulo);
                             mB=NXTMotor('B', 'Power',-velo_gira, 'TachoLimit',angulo+100);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                        case 3
                            % gira o robo 180º 
                            disp('altera direção atual norte-sul para sul-norte');
                            dir=4; %atualiza posição atual

                            %------------------------------------------------------
                             mC=NXTMotor('C', 'Power',-velo_gira, 'TachoLimit',2*angulo);
                             mB=NXTMotor('B', 'Power',velo_gira, 'TachoLimit',2*angulo);
                             mB.SendToNXT(h);
                             mC.SendToNXT(h);
                             mB.WaitFor(10, h); 
                             mC.WaitFor(10, h);        
                             StopMotor('all', 'off', h);
                             
                             NXC_ResetErrorCorrection(MOTOR_B, h);
                             NXC_ResetErrorCorrection(MOTOR_C, h);
                            %------------------------------------------------------
                        case 4
                            % mantem direção atual   
                            disp('mantem direção sul->norte');

                    end
                    disp('anda para frente')
                     %--------------------------------------------------------------

                    motorBC.ResetPosition(h);
                    data = motorBC.ReadFromNXT(h);
                    dist=GetUltrasonic(SENSOR_4, h);
                    toqdian=GetSwitch(SENSOR_1, h);
                    motorBC.SendToNXT(h);
                    aux=0;
                    volta=0;

                    while((dist>14) && (toqdian==0) && (data.Position<distancia))
                        dist=GetUltrasonic(SENSOR_4, h);
                        toqdian=GetSwitch(SENSOR_1, h);
                        data = motorBC.ReadFromNXT(h);
                        if(toqdian==1)
                            aux=1;
                        end
                        if(toqdian==1 || (dist<15))
                            volta=1;
                        end
                    end

                    motorBC.Stop('brake', h);

                    if(aux==1)
                        data.Position=data.Position-100;
                    end

                    if(volta==1) 
                        motorBC = NXTMotor('BC', 'Power', -50 , 'TachoLimit' , data.Position)
                        motorBC.SendToNXT(h);
                        motorBC.WaitFor(10, h);
                        motorBC.ResetPosition(h);
                        disp(celatual(ind))
                        ori_li=celatual(ind).linha;
                        ori_co=celatual(ind).coluna;
                        mapa_atual(listcam2(i+1).linha,listcam2(i+1).coluna)=1;
                        rota_falha=1;
                        disp(mapa_cam)
                        altera_rota=1;
                        break;
                    else
                        clear mapa_marc;
                        mapa_marc=mapa_cam;
                        ind=ind+1;
                        celatual(ind).linha=listcam2(i+1).linha;
                        celatual(ind).coluna=listcam2(i+1).coluna;
                        mapa_marc(celatual(ind).linha,celatual(ind).coluna)=50;
                        image(mapa_marc);
                        disp(celatual(ind))    
                    end
                    %--------------------------------------------------------------
                    pause(1);
                end
            end
            
        continue

        
    end
end

