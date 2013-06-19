function swarmCollisionsControls01
    
    %clear everything up
    clear all;
    close all;
    clc;

%--------------------------------------------------------------------------
%START FIRST FRAME AND INITIALIZE CONDITIONS
%--------------------------------------------------------------------------

    %define variables here (subject to change)
    xR=10;                  %x radius of swarm boundary
    yR=15;                  %y radius of swarm boundary
    n=20;                   %number of agents
    r=.5;                   %radius of each agent
    m(1,1:n)=1;             %mass of each agent
    dt=1/450;               %change in time
    tFinal=500;             %final time
    w=0;                    %angular velocity
    rV=1;                   %length of velocity vector for each agent
    xCent=0;                %x component of center of swarm
    yCent=0;                %y component of center of swarm
    rVSwarm=0.1;            %length of velocity vector for swarm
    phiSwarm=0;             %angle of rotation for entire swarm
    wSwarm=0;               %change in rotation for entire swarm
    xDeltaR=0;              %change in x radius of bigR (dependant on time)
    yDeltaR=0;              %change in y radius of bigR (dependant on time)
    video=0;                %choose to make a video
    
    %make small rectangular obstacle 
    pos=xR*2;
    neg=xR;
    posS=xR/8;
    negS=-xR/8;
    xBound=[negS negS posS posS negS];
    yBound=[neg pos pos neg neg];

%    %make small diamond obstacle
%    xBound=[0 4 0 -4 0];
%    yBound=[xR xR+4 xR+8 xR+4 xR];

%    %make small circular obstacle
%    thetaBound=0:.1:2*pi;
%    xBound=4*cos(thetaBound);
%    yBound=(xR+4)+4*sin(thetaBound);

    num=1;
    while num==1
        %make random velocity directions for each member
        theta=rand(n,1)*2*pi;
        xVel=rV*cos(theta);
        yVel=rV*sin(theta);
    
%          %make a random velocity direction for the swarm
%          gamma=randi(6,1);
%          xVelSwarm=rVSwarm*cos(gamma);
%          yVelSwarm=rVSwarm*sin(gamma);

        %give swarm initial velocity
        xVelSwarm=0;
        yVelSwarm=rVSwarm;
  
        %make particles inside area by giving random places to start
        if xR>=yR
            newR=yR;
        else
            newR=xR;
        end
        thetaPositions=rand(n,1)*2*pi;
        rPositions=rand(n,1)*(newR-(1+r));
        xPos=rPositions.*cos(thetaPositions)+xCent;
        yPos=rPositions.*sin(thetaPositions)+yCent;
        
        %check distances between particles/swarm boundary
        %necessary?? since I don't show this frame?
        num=checkDistEllipse(n,r,xR,yR,xPos,yPos,xCent,yCent);
    end
    
    %Setup iteration and waitbar
    nextOne=1;
    h=waitbar(0,'Watch this...');
    
%--------------------------------------------------------------------------
%BEGIN MOVING PARTICLES
%--------------------------------------------------------------------------

%set iteration for video counter
vid=0;

%save initial conditions for the swarm as a whole
xR1=xR;
yR1=yR;
xDeltaR1=xDeltaR;
yDeltaR1=yDeltaR;
phiSwarm1=phiSwarm;
wSwarm1=wSwarm;

for z=0:dt:tFinal
    
    %create two arrays that will hold the previous values for (x,y)
    xxPos=xPos;
    yyPos=yPos;
    
    %move the particles
    xPos=xPos+xVel*dt;
    yPos=yPos+yVel*dt;
    
    %incorporating angular velocity to change direction of velocity vectors
    beta=w*dt;
    xx=xVel*cos(beta)-yVel*sin(beta);
    yy=xVel*sin(beta)+yVel*cos(beta);
    xVel=xx;
    yVel=yy;

    %move the swarm as a whole
    xCent=xCent+xVelSwarm*dt;
    yCent=yCent+yVelSwarm*dt;
    
    %changing the size of bigR
    xR=xR+xDeltaR*dt;
    yR=yR+yDeltaR*dt;
    
    %changing the rotation of the swarm
    phiSwarm=phiSwarm+wSwarm*dt;
    
    %make initial swarm boundary
    theta1=0:0.01:2*pi; 
    xS = xCent+(xR*cos(theta1)*cos(phiSwarm)-yR*sin(theta1)*sin(phiSwarm));
    yS = yCent+(yR*sin(theta1)*cos(phiSwarm)+xR*cos(theta1)*sin(phiSwarm));
    
%checks for collisions

    %check distances between centers to detect particle collisions
    for k=1:n-1                   
        for k1=k+1:n            
            distance=sqrt((xPos(k1)-xPos(k))^2+(yPos(k1)-yPos(k))^2);
            if (distance<=2*r)  
                %space out the agents that overlap
                [xPos(k),yPos(k),xPos(k1),yPos(k1)]=fixSwarm(xPos(k),yPos(k),xPos(k1),yPos(k1),r);
                %change resulting velocities after agent-agent collision
                [xVel(k),yVel(k),xVel(k1),yVel(k1)]=particleCollision(xVel(k),yVel(k),m(k),xVel(k1),yVel(k1),m(k1));
            end
        end
    end 
  
    %check for agents crossing swarm boundary & and change (x,y),velocities
    %(swarm boundary collisions)
    [xVel,yVel,xPos,yPos]=boundCollisionEllipse(n,r,xR,yR,xPos,yPos,xVel,yVel,xCent,yCent,phiSwarm);
    
    %check for collisions between agents and wall/obstacle boundaries
    [xVel,yVel]=wallCollisions(xVel,yVel,xPos,yPos,r,xBound,yBound,xxPos,yyPos,n,xS,yS);
    
    %check for collisions between agents and corners of wall/obstacles*
    %*somewhat quick fix, doesn't work exactly the way I want to sometimes
    [xVel,yVel]=cornerCollisions(xxPos,yyPos,xPos,yPos,xVel,yVel,xBound,yBound,xS,yS,r);
    
    %%%%%***************************************************************************************************************************
    %check for stray agents, wall/obstacle boundaries that hold agents back
    [xR,yR,xDeltaR,yDeltaR,phiSwarm,wSwarm]=moldSwarm(xR,yR,xPos,yPos,r,xCent,yCent,xBound,yBound,xDeltaR,yDeltaR,xS,yS,dt,phiSwarm,wSwarm);
    
    %program that will change the swarm back to it's previous state once
    %moldSwarm has done its job
    
    
    %include another checkDistEllipse?
    
    %when to show next frame    
    nextOne = nextOne+1;
    cam = mod(nextOne,100);

    %draw particles & boundary in one frame
    if (cam==0)    
        vid=makeSwarmEllipse(n,xR,yR,xPos,yPos,r,xVel,yVel,rVSwarm,xCent,yCent,xBound,yBound,xS,yS,video,vid);
    end  
    
    %change waitbar
    waitbar(z/tFinal,h)  
end

end