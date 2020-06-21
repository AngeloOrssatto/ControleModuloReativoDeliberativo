function afasta_objeto
    
        global toqdian;
        global toqtras;
        global dist;
        global h;
        
        mBC=NXTMotor('BC', 'Power',-30);
        mBC.SendToNXT(h);%->provavelmente precisara de h
       
        
        
        while(dist<=6 || toqdian==1)
           dist=GetUltrasonic(SENSOR_4, h); %->provavelmente precisara de h
           disp(dist);
           toqdian=GetSwitch(SENSOR_1, h); %->provavelmente precisara de h
           toqtras=GetSwitch(SENSOR_2, h);%->provavelmente precisara de h
        end
        
        StopMotor('all', 'off', h);%tmb precisa do h
        
        dist=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
        disp(dist);

end

