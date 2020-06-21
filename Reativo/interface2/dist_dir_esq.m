function dist_dir_esq

     global distdir;
     global distesq;
     global dist;
     global toqtras;
     global aux;
     global h;
     
     aux=0;
  
    disp('olha para a esquerda');
   
    % verifica dist�ncia de um obst�culo a direita do rob�;
    mA=NXTMotor('A', 'Power',45, 'TachoLimit', 90);
    mA.SendToNXT(h); %->provavelmente precisara de h
    mA.WaitFor(h); %->provavelmente precisara de h
    mA.Stop('off', h); %->provavelmente precisara de h
    pause(0.5);
    distesq=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
    pause(0.5);
            
    mA=NXTMotor('A', 'Power',-45, 'TachoLimit', 90);
    mA.SendToNXT(h);%->provavelmente precisara de h
    mA.WaitFor(h); %->provavelmente precisara de h
    mA.Stop('off', h);%->provavelmente precisara de h
      
    disp('olha para a direita');
    % verifica a dist�ncia de um obst�culo a esquerda do rob�;
    mA=NXTMotor('A', 'Power',-45, 'TachoLimit', 90);
    mA.SendToNXT(h);%->provavelmente precisara de h
    mA.WaitFor(h); %->provavelmente precisara de h
    mA.Stop('off', h);%->provavelmente precisara de h
    pause(0.5);
    distdir=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
    pause(0.5);
          
    mA=NXTMotor('A', 'Power',45, 'TachoLimit', 90);
    mA.SendToNXT(h);%->provavelmente precisara de h
    mA.WaitFor(h); %->provavelmente precisara de h
    mA.Stop('off', h);%->provavelmente precisara de h
            
    if(distdir>25)
            % tenta sempre virar para a direita
            disp('vira direita 1');
            mC=NXTMotor('C', 'Power',-30, 'TachoLimit',505);
            mB=NXTMotor('B', 'Power',30, 'TachoLimit',505);
            mB.SendToNXT(h);%->provavelmente precisara de h
            mC.SendToNXT(h);%->provavelmente precisara de h
            mB.WaitFor(h);%->provavelmente precisara de h 
            mC.WaitFor(h);%->provavelmente precisara de h        
            mB.Stop('off', h);%->provavelmente precisara de h
            mC.Stop('off', h);%->provavelmente precisara de h
            distesq=0;
            aux=1;
          
    end 
    
    if(distesq>25) 
            % se dist�ncia para esquerda maior que para direita, vira robo para a esquerda; 
            disp('vira esquerda 1');
            mC=NXTMotor('C', 'Power',30, 'TachoLimit',505);
            mB=NXTMotor('B', 'Power',-30, 'TachoLimit',505);
            mB.SendToNXT(h);%->provavelmente precisara de h
            mC.SendToNXT(h);%->provavelmente precisara de h
            mB.WaitFor(h); %->provavelmente precisara de h
            mC.WaitFor(h); %->provavelmente precisara de h       
            mB.Stop('off', h);%->provavelmente precisara de h
            mC.Stop('off', h);%->provavelmente precisara de h
            distdir=0;
            aux=1;
    end
    
    if(distdir<25 && distesq<25 && aux==0)

            % verifica dist�ncia de um obst�culo atr�s do rob�;
            disp('olhando para tr�s...');
            mA=NXTMotor('A', 'Power',45, 'TachoLimit', 180);
            mA.SendToNXT(h);%->provavelmente precisara de h
            mA.WaitFor(h); %->provavelmente precisara de h
            mA.Stop('off', h);%->provavelmente precisara de h
            dist=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
            toqtras=GetSwitch(SENSOR_2, h);%->provavelmente precisara de h

            if(dist>20 && toqtras==0)         
                mBC=NXTMotor('BC', 'Power',-30);
                mBC.SendToNXT(h);%->provavelmente precisara de h
            end

            % enquanto puder vai para tr�s
            disp('indo para tr�s...');
            while(dist>17 && toqtras==0)
               dist=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
               toqtras=GetSwitch(SENSOR_2, h);%->provavelmente precisara de h
               dist=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
               disp(dist);         
            end
    
            disp('parou');
            StopMotor('all', 'off');

            % afasta de obst�culo para poder manobrar
            if(toqtras==1)
               mBC=NXTMotor('BC', 'Power',30);
               mBC.SendToNXT(h);%->provavelmente precisara de h
               pause(0.8);
               StopMotor('all', 'off');
            end

            dist=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
            disp(dist);

            % corrige a posi��o do sensor ultra-s�nico
            mA=NXTMotor('A', 'Power',-45, 'TachoLimit', 180);
            mA.SendToNXT(h);%->provavelmente precisara de h
            mA.WaitFor(h); %->provavelmente precisara de h
            mA.Stop('off', h);%->provavelmente precisara de h

            % verifica dist�ncia de um obst�culo a direita do rob�;
            mA=NXTMotor('A', 'Power',45, 'TachoLimit', 90);
            mA.SendToNXT(h);%->provavelmente precisara de h
            mA.WaitFor(h); %->provavelmente precisara de h
            mA.Stop('off', h);%->provavelmente precisara de h
            pause(0.5);
            disp('olha para direita...');
            distesq=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
            disp(distesq);
            pause(0.5);

            mA=NXTMotor('A', 'Power',-45, 'TachoLimit', 90);
            mA.SendToNXT(h);%->provavelmente precisara de h
            mA.WaitFor(h); %->provavelmente precisara de h
            mA.Stop('off', h);%->provavelmente precisara de h

            % verifica a dist�ncia de um obst�culo a esquerda do rob�;
            mA=NXTMotor('A', 'Power',-45, 'TachoLimit', 90);
            mA.SendToNXT(h);%->provavelmente precisara de h
            mA.WaitFor(h); %->provavelmente precisara de h
            mA.Stop('off', h);%->provavelmente precisara de h
            pause(0.5);
            disp('olha para esquerda...');
            distdir=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
            disp(distdir);
            pause(0.5);

            mA=NXTMotor('A', 'Power',45, 'TachoLimit', 90);
            mA.SendToNXT(h);%->provavelmente precisara de h
            mA.WaitFor(h); %->provavelmente precisara de h
            mA.Stop('off', h);%->provavelmente precisara de h
            
            if(distdir>25)
                % virar para a direita
                disp('vira direita 2');
                mC=NXTMotor('C', 'Power',-30, 'TachoLimit',505);
                mB=NXTMotor('B', 'Power',30, 'TachoLimit',505);
                mB.SendToNXT(h);%->provavelmente precisara de h
                mC.SendToNXT(h);%->provavelmente precisara de h
                mB.WaitFor(h); %->provavelmente precisara de h
                mC.WaitFor(h); %->provavelmente precisara de h       
                mB.Stop('off', h);%->provavelmente precisara de h
                mC.Stop('off', h);%->provavelmente precisara de h
                distesq=0;
             end
            
             if(distesq>25) 
                % vira para a esquerda;
                disp('vira esquerda 2');
                mC=NXTMotor('C', 'Power',30, 'TachoLimit',505);
                mB=NXTMotor('B', 'Power',-30, 'TachoLimit',505);
                mB.SendToNXT(h);%->provavelmente precisara de h
                mC.SendToNXT(h);%->provavelmente precisara de h
                mB.WaitFor(h); %->provavelmente precisara de h
                mC.WaitFor(h); %->provavelmente precisara de h       
                mB.Stop('off', h);%->provavelmente precisara de h
                mC.Stop('off', h);%->provavelmente precisara de h
                distdir=0;
             end  
    end
                            
   
       
end   
                





