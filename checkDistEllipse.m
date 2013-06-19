function num=checkDistEllipse(n,r,xR,yR,xPos,yPos,xCent,yCent)
    iterate=1; %set first iteration to 1
    for k=1:n-1                   
        for k1=k+1:n            
        %check all values for distances between agents
            distRad=sqrt((xPos(k1)-xPos(k))^2+(yPos(k1)-yPos(k))^2);
            %use the sum of yesNo to get num's final value
            if (distRad<=2*r)
                yesNo(iterate)=1;
            else
                yesNo(iterate)=0;
            end 
            iterate=iterate+1;
        end
    end
    %then check all values for distances between agents and boundary
    for k=1:n
        xx=xPos(k)-xCent;
        yy=yPos(k)-yCent;
        test=(xx^2/(xR-r)^2)+(yy^2/(yR-r)^2);
        if (test>=1)
            yesNo(iterate)=1;
        else
            yesNo(iterate)=0;
        end
    end
    if (sum(yesNo)>=.5)
        num=1;
    else
        num=0;
    end
end