function vid=makeSwarmEllipse(n,xR,yR,xPos,yPos,r,xVel,yVel,rVSwarm,xCent,yCent,xBound,yBound,x,y,video,vid)
    %make titles/labels/setup
    clf;
    hold on;
    box on;
    %fix plot and axes to show everything*******
    axis([-xR-5+xCent xR+5+xCent -yR-5+yCent yR+5+yCent]);
    axis square
    axis equal
    %axis normal
    title('Swarm Controls Test');
    string=sprintf('#Particles = %d     vSwarm = %.2f m/s      Position = (%.2f,%.2f)',n,rVSwarm,xCent,yCent);
    xlabel(string);
    
    %outside wall/map boundary
    pBound=plot(xBound,yBound);
    set(pBound,'Color','r','LineWidth',2);
    
    %create boundary(circle)
    p=plot(x,y);
    set(p,'Color','k','LineWidth',2);

    for k=1:n
        %create particles
        theta=0:0.1:2*pi;
        x = xPos(k) + r*cos(theta);
        y = yPos(k) + r*sin(theta);
        patch(x,y,[1 0 1]);
        
        %create the main velocity line
        newX=xPos(k)+xVel(k);
        newY=yPos(k)+yVel(k);
        x1=[xPos(k) newX];
        y1=[yPos(k) newY];
        p1=plot(x1,y1);
        set(p1,'Color','k','LineWidth',2);
        
        %make arrow for velocity line
        theta1=atan2(yVel(k),xVel(k));
        xArrow=xVel(k)*cos(-theta1)-yVel(k)*sin(-theta1); 
        yArrow=xVel(k)*sin(-theta1)+yVel(k)*cos(-theta1);
        xArr=[xArrow-.5*r xArrow-.5*r xArrow];
        yArr=[yArrow+.5*r yArrow-.5*r yArrow];
        xArr1=xArr*cos(theta1)-yArr*sin(theta1);
        yArr1=xArr*sin(theta1)+yArr*cos(theta1);
        xArr2=xArr1+xPos(k);
        yArr2=yArr1+yPos(k);
        patch(xArr2,yArr2,'k');
    end
    
    %saves picture to format into a video for later use if specified
    if (video==1)
        saveas(gcf,[pwd '\swarmControls' num2str(vid)],'png')
        vid=vid+1;
    end
end