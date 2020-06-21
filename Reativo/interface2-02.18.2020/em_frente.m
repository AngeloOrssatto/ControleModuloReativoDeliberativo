function em_frente

        global toqdian;
        global dist;
        global h; %handle NXT
                
        mBC=NXTMotor('BC','Power',40);
        mBC.SendToNXT(h); %->provavelmente precisara de h
        
        while((dist > 13) && (toqdian == 0))
            dist = GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
            disp('distancia ultrassonico');
            disp(dist);
            toqdian = GetSwitch(SENSOR_1, h);%->provavelmente precisara de h
            disp('toque sensor frente');
            disp(toqdian);
        end
        
        mBC.Stop('off', h);%->provavelmente precisara de h
               
        dist=GetUltrasonic(SENSOR_4, h);%->provavelmente precisara de h
        disp(dist);
end

