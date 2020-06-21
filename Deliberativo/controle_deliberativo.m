
clc

% inicia conexão com o lego-----------------------------------------------

% COM_CloseNXT all;
% h=COM_OpenNXT('bluetooth.ini');
% COM_SetDefaultNXT(h);
% NXT_PlayTone(500, 200);

%-------------------------------------------------------------------------

disp('Carregando mapa');
load mapa.txt;

dim=size(mapa);

NumCel=(dim(1)*dim(2));
%disp(NumCel)

fprintf('\nDimensão %d x %d',dim(1),dim(2))

fprintf('\n\n');
disp(mapa) %exibe matriz que representa o mapa

MatAdj=zeros(NumCel,NumCel);
% disp(MatAdj);
Pos2=0;

Co=dim(2);
Li=dim(1);

for i=1:Li
    for j=1:Co
        if (mapa(i,j)==0) %testa se a célula está livre ou se possui obstáculo.
            Pos1=(((i-1)*Co)+(j-1))+1; %converte o valor da célula da matriz map para a matriz de adjacencia.
                        
            if (j>1) %verifica a conectividade com a célula a esquerda.
                if(mapa(i,j-1)==0)
                    Pos2=(((i-1)*Co)+(j-2))+1;
                    MatAdj(Pos1,Pos2)=1;
                    MatAdj(Pos2,Pos1)=1;
                end 
            end
            
            if (j<Co) %verifica a conectividade com a célula a direita.
                if(mapa(i,j+1)==0)
                    Pos2=(((i-1)*Co)+j)+1;
                    MatAdj(Pos1,Pos2)=1;
                    MatAdj(Pos2,Pos1)=1;
                end
            end
            
            if (i>1) %verifica a conectividade com a célula a cima.
                if(mapa(i-1,j)==0)
                   Pos2=(((i-2)*Co)+(j-1))+1;
                   MatAdj(Pos1,Pos2)=1;
                   MatAdj(Pos2,Pos1)=1; 
                end
            end
            
            if (i<Li) %verifica a conectividade com a célula a baixo.
                if(mapa(i+1,j)==0)
                   Pos2=((i*Co)+(j-1))+1;
                   MatAdj(Pos1,Pos2)=1;
                   MatAdj(Pos2,Pos1)=1;
                end
            end
        end
    end
end

fprintf('\n\n');



origem=struct('linha',{},'coluna',{},'nodo',{},'marcado',{});
disp('Coordenadas da origem:');

origem(1).linha=0;
origem(1).coluna=0;

% receber a entrada da coordenada de origem
while(origem(1).linha<1 || origem(1).linha>Li || origem(1).coluna<1 || origem(1).coluna>Co)
    origem(1).linha=input('Linha: ');
    origem(1).coluna=input('Coluna: ');
    clc;
    disp('Carregando mapa');
    fprintf('\n');
    disp(mapa);
end

origem(1).nodo=(((origem.linha-1)*Co)+(origem.coluna-1))+1;
origem(1).marcado=0;
mapa(origem(1).linha,origem(1).coluna)=2;

disp(origem);

% receber coordenada de destino
destino=struct('linha',{},'coluna',{},'nodo',{},'marcado',{});
disp('Coordenadas do destino:');
destino(1).linha=input('Linha: ');
destino(1).coluna=input('Coluna: ');
destino(1).nodo=(((destino.linha-1)*Co)+(destino.coluna-1))+1;
destino(1).marcado=0;
mapa(destino(1).linha,destino(1).coluna)=3;

disp(destino);

disp('Mapa');
disp(mapa);

% exibe matriz de adjacências;
% disp('Matriz de adjacências');
% disp(MatAdj);

listver=struct('marcado',{},'nodo',{},'peso',{},'origem',{});
%ind=1;
sai=0;

   listver(1).marcado=0;
   listver(1).nodo=origem(1).nodo;
   listver(1).peso=0;
   listver(1).origem=0;

while sai==0
   tam=size(listver);
   max=1000; % para pegar nodo com menor peso.
   indMen=0; % indice do nodo menor peso acumulado.
   
   for i=1:tam(2) %dimensão da matriz mapa
       disp(listver(i))
       if(listver(i).peso<max && listver(i).marcado==0)  % atualiza o valor de max para nodos não marcados
           max=listver(i).peso; 
           indMen=i;
       end
   end
   
   cont=1;
   for i=1:NumCel
       
       disp(listver(indMen).nodo)
       
       if(MatAdj(listver(indMen).nodo,i)==1) % verifica adjacencias 
           tam=size(listver); 
           achado=0;
           for j=1:tam(2) 
               if(listver(j).nodo==i)  
                   achado=1;
                   if(listver(j).peso>listver(indMen).peso+1)
                       listver(j).origem=listver(indMen).nodo;
                       listver(j).peso=listver(indMen).peso+1;
                   end
               end
           end
           
           if(achado==0)
              tam(2)=tam(2)+1;
              listver(tam(2)).marcado=0;
              listver(tam(2)).nodo=i;
              listver(tam(2)).peso=listver(indMen).peso+1;
              listver(tam(2)).origem=listver(indMen).nodo;
           end
       end     
   end
   
   listver(indMen).marcado=1;
   tam=size(listver);
   achado=0;
   temMenor=0;
    
   for i=1:tam(2)   
       if(listver(i).nodo==destino(1).nodo)
           achado=i;
       end
   end
   
   if(achado~=0)
       for i=1:tam(2)   
           if(listver(i).peso<listver(achado).peso && listver(i).marcado==0)
               temMenor=1;
           end
       end
       if(temMenor==0)
           sai=1;
       end     
   end
   
end


 tam=size(listver);
 
%  exibe lista de todos os vertices que foram visitados
%   for i=1:tam(2)
%       disp(listver(i));
%   end
 
 clear caminho;
 caminho(1) = destino(1).nodo;
 camInd=2;
 
 atual=destino(1).nodo;
 
 while atual~=origem(1).nodo
	achadoFlag = 0;
	listverIndex = 1;
    while achadoFlag==0
         if(atual==listver(listverIndex).nodo)
             caminho(camInd)=listver(listverIndex).origem;
             atual=listver(listverIndex).origem;
             camInd=camInd+1;
			achadoFlag=1;
         end
		listverIndex=listverIndex+1;
     end
 end
 
 disp(caminho)
 tam=size(caminho);
 
 listcam=struct('linha',{},'coluna',{},'ordem',{});
 listcam2=struct('linha',{},'coluna',{},'ordem',{});
 
 ind=tam(2);
 div=0;
 
 mapa2=mapa;
 
 
 
 % conversão do caminho em coordenadas do mapa
 
 for i=1:tam(2)
     if(mod(caminho(ind),dim(2))==0)
        div=caminho(ind)/dim(2);
        listcam(ind).linha=div;
        listcam(ind).coluna=dim(2);
        listcam(ind).ordem=i;
        mapa2(div,dim(2))='*';
     else
        div=floor(caminho(ind)/dim(2));
        listcam(ind).linha=div+1;
        listcam(ind).coluna=mod(caminho(ind),dim(2));
        listcam(ind).ordem=i;
        mapa2(div+1,mod(caminho(ind),dim(2)))='*';
     end
     ind=ind-1;
 end
 
 ind=tam(2);
 
 for i=1:tam(2)
     listcam2(i).linha=listcam(ind).linha;
     listcam2(i).coluna=listcam(ind).coluna;
     listcam2(i).ordem=listcam(ind).ordem;
     ind=ind-1;
 end
 
 for i=1:tam(2)
    disp(listcam2(i))
 end
 
disp(mapa2);
image(mapa2);


%-------------------------------------------------------------------------

% NXC_ResetErrorCorrection(MOTOR_B, h);
% NXC_ResetErrorCorrection(MOTOR_C, h);
% StopMotor('all', 'off', h);

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

mBC=NXTMotor('BC', 'Power',40, 'TachoLimit', 1000);
%mBC.SendToNXT(h);

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
%                     mC=NXTMotor('C', 'Power',-30, 'TachoLimit',1010);
%                     mB=NXTMotor('B', 'Power',30, 'TachoLimit',1010);
%                     mB.SendToNXT(h);
%                     mC.SendToNXT(h);
%                     mB.WaitFor(10, h);
%                     mC.WaitFor(10, h);        
%                     mB.Stop('off', h);
%                     mC.Stop('off', h);
                   %-------------------------------------------------------
                    
                case 3
                    % gira 90º para o leste 
                    disp('altera direção atual norte->sul para oeste->leste');
                    dir=1; %atualiza direção atual
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',30, 'TachoLimit',505);
%                     mB=NXTMotor('B', 'Power',-30, 'TachoLimit',505);
%                     mB.SendToNXT(h);
%                     mC.SendToNXT(h);
%                     mB.WaitFor(10, h); 
%                     mC.WaitFor(10, h);        
%                     mB.Stop('off', h);
%                     mC.Stop('off', h);
                    %------------------------------------------------------
                    
                    
                case 4
                    % gira 90º para o oeste 
                    disp('altera direção atual sul->norte para oeste->leste');
                    dir=1; %atualiza direnção atual
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',-30, 'TachoLimit',505);
%                     mB=NXTMotor('B', 'Power',30, 'TachoLimit',505);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
                   %-------------------------------------------------------
                   
            end
            disp('anda para frente')
            
            %--------------------------------------------------------------
%             mBC.SendToNXT();
%             mBC.WaitFor();
%             mBC.Stop('off');
            %--------------------------------------------------------------
            
            ind=ind+1;
            celatual(ind).linha=listcam2(i+1).linha;
            celatual(ind).coluna=listcam2(i+1).coluna;
            disp(celatual(ind))
        else
            switch dir
                case 1
                    % gira robo 180º
                    disp('altera direção atual oeste->leste para leste->oeste');
                    dir=2; %atualiza direção
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',-30, 'TachoLimit',1010);
%                     mB=NXTMotor('B', 'Power',30, 'TachoLimit',1010);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
%                     pause(1);
                    %------------------------------------------------------
                    
                case 2
                    % mantem direção atual
                    disp('mantem direção leste->oeste ');
                    pause(1);
                    
                case 3
                    % gira 90º para o oeste
                    disp('altera direção atual norte->sul para leste->oeste');
                    dir=2; %atualiza direção
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',-30, 'TachoLimit',505);
%                     mB=NXTMotor('B', 'Power',30, 'TachoLimit',505);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
%                     pause(1);
                    %------------------------------------------------------
                    
                    
                case 4
                    % gira 90º para o leste
                    disp('altera direção atual sul->norte para leste->oeste');
                    dir=2; %atualiza direção
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',30, 'TachoLimit',505);
%                     mB=NXTMotor('B', 'Power',-30, 'TachoLimit',505);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
%                     pause(1);
                    %------------------------------------------------------
                    
            end
            disp('anda para frente')
            
            %--------------------------------------------------------------
%             mBC.SendToNXT();
%             mBC.WaitFor();
%             pause(1);
            %--------------------------------------------------------------
            
            ind=ind+1;
            celatual(ind).linha=listcam2(i+1).linha;
            celatual(ind).coluna=listcam2(i+1).coluna;
            disp(celatual(ind))
            
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
%                     mC=NXTMotor('C', 'Power',-30, 'TachoLimit',505);
%                     mB=NXTMotor('B', 'Power',30, 'TachoLimit',505);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
                    %------------------------------------------------------
                    
                case 2
                    % gira robo 90º para o sul
                    disp('altera direção atual leste->oeste para norte->sul');
                    dir=3; %atualiza direção atual
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',30, 'TachoLimit',505);
%                     mB=NXTMotor('B', 'Power',-30, 'TachoLimit',505);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
                    %------------------------------------------------------

                case 3
                    % mantem direção atual 
                    disp('mantem direção norte->sul');
                case 4
                    % gira robo 180º  
                    disp('altera direção atual sul->norte para norte-sul');
                    dir=3; % atualiza direção atual
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',-30, 'TachoLimit',1010);
%                     mB=NXTMotor('B', 'Power',30, 'TachoLimit',1010);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
                    %------------------------------------------------------
            end
            disp('anda para frente')
            
            %--------------------------------------------------------------
%             mBC.SendToNXT();
%             mBC.WaitFor();
            %--------------------------------------------------------------
           
            ind=ind+1;
            celatual(ind).linha=listcam2(i+1).linha;
            celatual(ind).coluna=listcam2(i+1).coluna;
            disp(celatual(ind))
        else
             switch dir
                case 1
                    % gira robo 90º para o norte
                    disp('altera direção atual oeste->leste para sul-norte');
                    dir=4; %atualiza a posição atual
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',30, 'TachoLimit',505);
%                     mB=NXTMotor('B', 'Power',-30, 'TachoLimit',505);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
                    %------------------------------------------------------
                
                 case 2
                    % gira robo 90º para o sul
                    disp('altera direção atual leste->oeste para sul-norte');
                    dir=4; %atualiza a posição atual
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',-30, 'TachoLimit',505);
%                     mB=NXTMotor('B', 'Power',30, 'TachoLimit',505);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
                    %------------------------------------------------------
                case 3
                    % gira o robo 180º 
                    disp('altera direção atual norte-sul para sul-norte');
                    dir=4; %atualiza posição atual
                    
                    %------------------------------------------------------
%                     mC=NXTMotor('C', 'Power',-30, 'TachoLimit',1010);
%                     mB=NXTMotor('B', 'Power',30, 'TachoLimit',1010);
%                     mB.SendToNXT();
%                     mC.SendToNXT();
%                     mB.WaitFor(); 
%                     mC.WaitFor();        
%                     mB.Stop('off');
%                     mC.Stop('off');
                    %------------------------------------------------------
                case 4
                    % mantem direção atual   
                    disp('mantem direção sul->norte');
                    
            end
            disp('anda para frente')
            %--------------------------------------------------------------
%             mBC.SendToNXT();
%             mBC.WaitFor();
            %--------------------------------------------------------------
            ind=ind+1;
            celatual(ind).linha=listcam2(i+1).linha;
            celatual(ind).coluna=listcam2(i+1).coluna;
            disp(celatual(ind))
        end
    end
    
    % encerra conexão com o lego
%     mB.WaitFor(); 
%     mC.WaitFor();   
%     mBC.WaitFor();
%     
%     NXT_PlayTone(200,400);
%     COM_CloseNXT all
%    disp('Conexão finalizada');
    
    
end
 














