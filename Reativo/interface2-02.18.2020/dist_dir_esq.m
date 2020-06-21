function dist_dir_esq

     %function dist_dir_esq

     global distdir;
     global distesq;
     global dist;
     global toqtras;
     global aux;
     global h; %handle NXT
     
     aux=0;
     
    OpenUltrasonic(SENSOR_4, '', h); 
    OpenSwitch(SENSOR_1, h);
    OpenSwitch(SENSOR_2, h);
    % verifica distância de um obstáculo a esquerda do robô;
    disp('olha para a esquerda');
    mA=NXTMotor('A', 'Power',45, 'TachoLimit', 90);
    mA.SendToNXT(h); 
    mA.WaitFor(10, h); 
    mA.Stop('off', h); 
    pause(0.5);
    distesq=GetUltrasonic(SENSOR_4, h);
    pause(0.5);
    disp(distesq);
    
    % verifica a distância de um obstáculo a direita do robô;
    disp('olha para a direita');
    mA=NXTMotor('A', 'Power',-45, 'TachoLimit', 180);
    mA.SendToNXT(h);
    mA.WaitFor(10, h);
    mA.Stop('off', h);
    pause(0.5);
    distdir=GetUltrasonic(SENSOR_4, h);
    pause(0.5);
    disp(distdir);
    
    %ajusta o sensor ultrassonico      
    mA=NXTMotor('A', 'Power',45, 'TachoLimit', 90);
    mA.SendToNXT(h);
    mA.WaitFor(10, h);
    mA.Stop('off', h);
            
    if(distdir > distesq)
            if (distdir > 25)
                disp('vira direita 1');
                mC=NXTMotor('C', 'Power',45, 'TachoLimit',1100);
                mB=NXTMotor('B', 'Power',-45, 'TachoLimit',1100);
                mB.SendToNXT(h);
                mC.SendToNXT(h);
                mB.WaitFor(10, h);
                mC.WaitFor(10, h);
                mB.Stop('off', h);
                mC.Stop('off', h);
                %distesq = 0;
                %aux = 1;
            else
                % verifica distância de um obstáculo atrás do robô;
                disp('olhando para trás..., 25 > direita > esquerda');
                mA=NXTMotor('A', 'Power',45, 'TachoLimit', 180);
                mA.SendToNXT(h);
                mA.WaitFor(10, h);
                mA.Stop('off', h);
                dist=GetUltrasonic(SENSOR_4, h);
                pause(0.5);
                toqtras=GetSwitch(SENSOR_2, h);
                pause(0.5);

                if(dist>20 && toqtras==0)         
                    mBC=NXTMotor('BC', 'Power',-30);
                    mBC.SendToNXT(h);
                end
                
                % enquanto puder vai para trás
                disp('indo para trás...');
                while(dist>17 && toqtras==0)
                   dist=GetUltrasonic(SENSOR_4, h);
                   pause(0.5);
                   toqtras=GetSwitch(SENSOR_2, h);
                   pause(0.5)
                   disp(dist);         
                end
                
                %ajusta o sensor ultrassonico      
                mA=NXTMotor('A', 'Power',45, 'TachoLimit', 180);
                mA.SendToNXT(h);
                mA.WaitFor(10, h);
                mA.Stop('off', h);
                
                disp('parou');
                StopMotor('all', 'off', h);
              
            end
    else
        if(distesq > 25) 
                % se distância para esquerda maior que para direita, vira robo para a esquerda; 
                disp('vira esquerda 1');
                mC=NXTMotor('C', 'Power', -45, 'TachoLimit',1100);
                mB=NXTMotor('B', 'Power', 45, 'TachoLimit',1100);
                mB.SendToNXT(h);%->provavelmente precisara de h
                mC.SendToNXT(h);%->provavelmente precisara de h
                mB.WaitFor(10, h); %timeout + handle como parametros
                mC.WaitFor(10, h); %timeout + handle como parametros     
                mB.Stop('off', h);%->provavelmente precisara de h
                mC.Stop('off', h);%->provavelmente precisara de h
                %distdir = 0;
                %aux = 1;
        else
                % verifica distância de um obstáculo atrás do robô;
                disp('olhando para trás... 25 > esquerda > direita');
                mA=NXTMotor('A', 'Power', 45, 'TachoLimit', 180);
                mA.SendToNXT(h);
                mA.WaitFor(10, h);
                mA.Stop('off', h);
                dist=GetUltrasonic(SENSOR_4, h);
                disp(dist);
                pause(0.5);
                toqtras=GetSwitch(SENSOR_2, h);
                disp(toqtras);
                pause(0.5);

                if(dist > 20 && toqtras == 0)         
                    mBC=NXTMotor('BC', 'Power',-30);
                    mBC.SendToNXT(h);
                end
                
                % enquanto puder vai para trás
                disp('indo para trás...');
                while(dist>17 && toqtras==0)
                   dist=GetUltrasonic(SENSOR_4, h);
                   pause(0.5);
                   toqtras=GetSwitch(SENSOR_2, h);
                   pause(0.5)
                   disp(dist);         
                end
                
                %ajusta o sensor ultrassonico      
                mA=NXTMotor('A', 'Power',45, 'TachoLimit', 180);
                mA.SendToNXT(h);
                mA.WaitFor(10, h);
                mA.Stop('off', h);
                
                disp('parou');
                StopMotor('all', 'off', h);
        end
    end   

                           
end   
