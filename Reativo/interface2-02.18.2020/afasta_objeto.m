function afasta_objeto %manda o robo ir para tras, somente;
    
        %global toqdian;
        %global toqtras;
        %global dist;
        global h; %handle NXT
        
        %OpenUltrasonic(SENSOR_4, 'snapshot', h);
        mBC=NXTMotor('BC', 'Power',-30);
        mBC.SendToNXT(h);%->provavelmente precisara de h
        
        pause(1.5);
        
        %while(toqdian == 1 || toqtras == 1)
           %dist=GetUltrasonic(SENSOR_4, h); %->provavelmente precisara de h
           %disp(dist);
           %toqdian=GetSwitch(SENSOR_1, h); %->provavelmente precisara de h
           %toqtras=GetSwitch(SENSOR_2, h);%->provavelmente precisara de h
           %mBC=NXTMotor('BC', 'Power',-30);
           %mBC.SendToNXT(h);%->provavelmente precisara de h
        %end
        StopMotor('all', 'off', h);%tmb precisa do h
        
        %dist=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
        %disp(dist);

end

