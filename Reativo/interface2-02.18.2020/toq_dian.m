function toq_dian
    
        global toqdian;
        global dist;
        global h; %handle NXT
        
        if(toqdian==1)
           disp('tocando objeto recuando');
           mBC=NXTMotor('BC', 'Power',-30);
           mBC.SendToNXT(h);%->provavelmente precisara de h
        end
              
        while(toqdian==1)
           toqdian=GetSwitch(SENSOR_1, h);%->provavelmente precisara de h 
        end
        
        StopMotor('all', 'off', h);%tmb precisa de h
        
        dist=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
        disp(dist);

end