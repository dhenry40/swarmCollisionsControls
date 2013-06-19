function mapGenerator
        
    %define variables
    bigR=10;
    r=.5;
    n=20;                %number of times map can change direction
    
    %other intialization stuff
    clf
    box on
    hold on
    ylabel('Inclusion of Wall Generator');
    
    %make starting square with exit
    %make boundaries/values for the next step
    neg=-bigR;
    pos=bigR;
    num=1;
    while (num==1)
        exit1=randi([-bigR 0],1);   %random start point for exit
        exit2=randi(bigR,1);        %random end point for exit
        distExit=exit2-exit1;
        if distExit>=r*4;
            num=0;
        end
    end
    distMap=distExit;
    
    %randomly choose a side for the exit
    choice=randi([1 4],1);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (choice==1)
        %starting box
        x=[neg neg];
        y=[neg exit1];
        x1=[neg neg pos pos neg];
        y1=[exit2 pos pos neg neg];
        
        farPoint=-randi(10)-bigR;
        xA=[neg farPoint];
        yA=[exit2 exit2];
        xB=[neg farPoint];
        yB=[exit1 exit1];
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif (choice==2)
        %starting box
        x=[neg neg exit1];
        y=[neg pos pos];
        x1=[exit2 pos pos neg];
        y1=[pos pos neg neg];
        
        farPoint=randi(10)+bigR;
        xA=[exit2 exit2];
        yA=[pos farPoint];
        xB=[exit1 exit1];
        yB=[pos farPoint];
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    elseif (choice==3)
        %starting box
        x=[neg neg pos pos];
        y=[neg pos pos exit2];
        x1=[pos pos neg];
        y1=[exit1 neg neg];
        
        farPoint=randi(10)+bigR;
        xA=[pos farPoint];
        yA=[exit1 exit1];
        xB=[pos farPoint];
        yB=[exit2 exit2];
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    else 
        %starting box
        x=[neg neg pos pos exit2];
        y=[neg pos pos neg neg];
        x1=[exit1 neg];
        y1=[neg neg];
        
        farPoint=-randi(10)-bigR;
        xA=[exit1 exit1];
        yA=[neg farPoint];
        xB=[exit2 exit2];
        yB=[neg farPoint];
        
    end
    
    choiceOrigin=choice;
    %change to choiceOld
    if choice==1
        choiceOld=3;
    elseif choice==2
        choiceOld=4;
    elseif choice==3
        choiceOld=1;
    else
        choiceOld=2;
    end
    
    %choiceOld=choice;
    %make legs of map
    for k=1:n
        %randomly choose a direction
        num=1;
        while num==1
            choiceNew=randi([1 4],1);
            %check that it doesn't go back to starting box
            if choiceNew==choiceOrigin
                numA(1)=1;
            else
                numA(1)=0;
            end
            
            %check that it doesn't go backwards
            if choiceNew==1 && choiceOld==3
                numA(2)=1;
            elseif choiceNew==3 && choiceOld==1
                numA(2)=1;
            elseif choiceNew==2 && choiceOld==4
                numA(2)=1;
            elseif choiceNew==4 && choiceOld==2
                numA(2)=1;
            else
                numA(2)=0;
            end
            
            %check if both criteria are met
            if sum(numA)<1
                num=0;
            else
                num=1;
            end

        end
        
        %make leg by using old direction as basis
        len=length(xA);
        xPointA=xA(len);
        yPointA=yA(len);
        xPointB=xB(len);
        yPointB=yB(len);
        farPoint=randi([5 10]);
        if choiceNew==1
            if choiceOld==4
                xA(len+1)=xPointA;
                xA(len+2)=xPointA;
                xA(len+3)=xPointA+farPoint;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA;
                yA(len+3)=yPointA;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB+distMap;
                xB(len+3)=xPointB+distMap+farPoint;
                yB(len+1)=yPointB+distMap;
                yB(len+2)=yPointB+distMap;
                yB(len+3)=yPointB+distMap;
               
            elseif choiceOld==1
                xA(len+1)=xPointA;
                xA(len+2)=xPointA+distMap;
                xA(len+3)=xPointA+distMap+farPoint;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA;
                yA(len+3)=yPointA;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB+distMap;
                xB(len+3)=xPointB+distMap+farPoint;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB;
                yB(len+3)=yPointB;
                
            elseif choiceOld==2
                xA(len+1)=xPointA;
                xA(len+2)=xPointA+distMap;
                xA(len+3)=xPointA+distMap+farPoint;
                yA(len+1)=yPointA-distMap;
                yA(len+2)=yPointA-distMap;
                yA(len+3)=yPointA-distMap;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB;
                xB(len+3)=xPointB+farPoint;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB;
                yB(len+3)=yPointB;
            end
       
        elseif choiceNew==2
            if choiceOld==3
                xA(len+1)=xPointA-distMap;
                xA(len+2)=xPointA-distMap;
                xA(len+3)=xPointA-distMap;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA-distMap;
                yA(len+3)=yPointA-distMap-farPoint;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB;
                xB(len+3)=xPointB;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB;
                yB(len+3)=yPointB-farPoint;
                
            elseif choiceOld==1
                xA(len+1)=xPointA;
                xA(len+2)=xPointA;
                xA(len+3)=xPointA;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA;
                yA(len+3)=yPointA-farPoint;
                
                xB(len+1)=xPointB+distMap;
                xB(len+2)=xPointB+distMap;
                xB(len+3)=xPointB+distMap;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB-distMap;
                yB(len+3)=yPointB-distMap-farPoint;
                
            elseif choiceOld==2
                xA(len+1)=xPointA;
                xA(len+2)=xPointA;
                xA(len+3)=xPointA;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA-distMap;
                yA(len+3)=yPointA-farPoint;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB;
                xB(len+3)=xPointB;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB-distMap;
                yB(len+3)=yPointB-farPoint;

            end
            
        elseif choiceNew==3
            if choiceOld==3
                xA(len+1)=xPointA;
                xA(len+2)=xPointA-distMap;
                xA(len+3)=xPointA-distMap-farPoint;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA;
                yA(len+3)=yPointA;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB-distMap;
                xB(len+3)=xPointB-distMap-farPoint;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB;
                yB(len+3)=yPointB;
                
            elseif choiceOld==4
                xA(len+1)=xPointA;
                xA(len+2)=xPointA-distMap;
                xA(len+3)=xPointA-distMap-farPoint;
                yA(len+1)=yPointA+distMap;
                yA(len+2)=yPointA+distMap;
                yA(len+3)=yPointA+distMap;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB;
                xB(len+3)=xPointB-farPoint;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB;
                yB(len+3)=yPointB;
                
            elseif choiceOld==2
                xA(len+1)=xPointA;
                xA(len+2)=xPointA;
                xA(len+3)=xPointA-farPoint;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA;
                yA(len+3)=yPointA;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB-distMap;
                xB(len+3)=xPointB-distMap-farPoint;
                yB(len+1)=yPointB-distMap;
                yB(len+2)=yPointB-distMap;
                yB(len+3)=yPointB-distMap;
            end
            
        else
            if choiceOld==3
                xA(len+1)=xPointA;
                xA(len+2)=xPointA;
                xA(len+3)=xPointA;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA;
                yA(len+3)=yPointA+farPoint;
                
                xB(len+1)=xPointB-distMap;
                xB(len+2)=xPointB-distMap;
                xB(len+3)=xPointB-distMap;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB+distMap;
                yB(len+3)=yPointB+distMap+farPoint;
                
            elseif choiceOld==4
                xA(len+1)=xPointA;
                xA(len+2)=xPointA;
                xA(len+3)=xPointA;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA+distMap;
                yA(len+3)=yPointA+distMap+farPoint;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB;
                xB(len+3)=xPointB;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB+distMap;
                yB(len+3)=yPointB+distMap+farPoint;
                
            elseif choiceOld==1
                xA(len+1)=xPointA+distMap;
                xA(len+2)=xPointA+distMap;
                xA(len+3)=xPointA+distMap;
                yA(len+1)=yPointA;
                yA(len+2)=yPointA+distMap;
                yA(len+3)=yPointA+distMap+farPoint;
                
                xB(len+1)=xPointB;
                xB(len+2)=xPointB;
                xB(len+3)=xPointB;
                yB(len+1)=yPointB;
                yB(len+2)=yPointB;
                yB(len+3)=yPointB+farPoint;
            end
        end
        
        choiceOld=choiceNew;
    end
    

    
    %plot everything
    %starting box
    p=plot(x,y);
    p1=plot(x1,y1);
    set(p,'Color','k','Linewidth',2);
    set(p1,'Color','k','Linewidth',2);
    
    %resulting maze 
    pA=plot(xA,yA);
    pB=plot(xB,yB);
    set(pA,'Color','r','Linewidth',2);
    set(pB,'Color','b','Linewidth',2); 

end