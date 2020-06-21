function [ ]=controle_reativo(x)

        global R;
        global toqdian;
        global toqtras;
        global dist;
        global h;
        
        
        NXC_ResetErrorCorrection(MOTOR_B, h); %->provavelmente precisara de h
        NXC_ResetErrorCorrection(MOTOR_C, h); %->provavelmente precisara de h
        StopMotor('all', 'off', h);%TMB PRECISA DO H NESSA PORRA
        
        CloseSensor(SENSOR_1, h);
        CloseSensor(SENSOR_2, h);
        CloseSensor(SENSOR_4, h);
        
        % seta as portas e os respectivos sensores;
        OpenUltrasonic(SENSOR_4, 'snapshot', h);
        OpenSwitch(SENSOR_1, h);
        OpenSwitch(SENSOR_2, h);
       
              
        toqdian=GetSwitch(SENSOR_1, h);  %sensor de toque dianteiro; %->provavelmente precisara de h
        toqtras=GetSwitch(SENSOR_2, h); %sensor de toque traseiro; %->provavelmente precisara de h
        dist=GetUltrasonic(SENSOR_4, h); %sensor ultrass�nico; %->provavelmente precisara de h
        disp(dist);
        
        % se afasta de um objeto que est� muito pr�ximo ou tocando o rob�;
        if ((dist<8) || (toqdian==1) && x==0)  
          disp('se afasta de um objeto que est� muito pr�ximo ou tocando o rob�;');
          afasta_objeto;
          dist_dir_esq;
       
        
            % avan�a at� se aproximar ou tocar um objeto;    
        else if ((dist>12) && (toqdian==0) && x==0)
              disp('avan�a at� que um obejto esteje muito pr�ximo ou tocando o rob�;');
              em_frente;
              %toq_dian;
   
            % obstaculo detectado pelo sensor ultrassonico;
            elseif((dist<14) && (toqdian==0) && x==0)
              disp('obejto detectado, mudan�a de dire��o;');  
              dist_dir_esq;  

            end
        end
        
        % limpa mem�ria dos motores, fecha conex�o dos sensores;   
        NXC_ResetErrorCorrection(MOTOR_B, h);%->provavelmente precisara de h
        NXC_ResetErrorCorrection(MOTOR_C, h);%->provavelmente precisara de h
        StopMotor('all', 'off', h);%talvez tem q passar 
        CloseSensor(SENSOR_1, h);
        CloseSensor(SENSOR_2, h);
        CloseSensor(SENSOR_3, h);
        CloseSensor(SENSOR_4, h);
return