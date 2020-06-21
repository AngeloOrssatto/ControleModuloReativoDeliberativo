function [] = gerar_rota()
    
    global mapa_atual;
    global rota_falha;
    global ori_li;
    global ori_co;
    global des_li;
    global des_co; 
    global listcam2;
    global tam;
    
    if(rota_falha==0)
        clear mapa;
        clear MatAdj;
        load mapa.txt;
    else
       mapa=mapa_atual; 
       disp(mapa)
    end
    
    dim=size(mapa);
    
    NumCel=(dim(1)*dim(2));   % armazena numero de células da matriz mapa ;
    MatAdj=zeros(NumCel,NumCel); % declara a matriz de adjacências ;   
    
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
    
    disp(MatAdj)
    
    origem=struct('linha',{},'coluna',{},'nodo',{},'marcado',{});
    destino=struct('linha',{},'coluna',{},'nodo',{},'marcado',{});
    
    clear origem;
    clear destino;
    
    origem(1).linha=ori_li;
    origem(1).coluna=ori_co;
    origem(1).nodo=(((origem.linha-1)*dim(2))+(origem.coluna-1))+1;
    origem(1).marcado=0;
    mapa(origem(1).linha,origem(1).coluna)=2;
    
    destino(1).linha=des_li;
    destino(1).coluna=des_co;
    destino(1).nodo=(((destino.linha-1)*dim(2))+(destino.coluna-1))+1;
    destino(1).marcado=0;
    mapa(destino(1).linha,destino(1).coluna)=3;
    
    listver=struct('marcado',{},'nodo',{},'peso',{},'origem',{});
    clear listver;
   
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
       
       conta=0;
       semRota=0;
       for i=1:tam(2)
           if((listver(i).marcado==1) && (listver(i).nodo~=destino(1).nodo))
              conta=conta+1;
           end
       end
       if(conta==tam(2))
         sai=1;
         semRota=1;
       end
       

    end

    if(semRota==0)
         tam=size(listver);
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

         global mapa_cam;
         mapa_cam=mapa;

         for i=1:tam(2)
             if(mod(caminho(ind),dim(2))==0)
                div=caminho(ind)/dim(2);
                listcam(ind).linha=div;
                listcam(ind).coluna=dim(2);
                listcam(ind).ordem=i;
                mapa_cam(div,dim(2))=30;
             else
                div=floor(caminho(ind)/dim(2));
                listcam(ind).linha=div+1;
                listcam(ind).coluna=mod(caminho(ind),dim(2));
                listcam(ind).ordem=i;
                mapa_cam(div+1,mod(caminho(ind),dim(2)))=30;
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

        disp(mapa_cam);
        image(mapa_cam);
    else
        disp('caminho impossivel');
    end
end

