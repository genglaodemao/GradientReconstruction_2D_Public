function [res,PosStep,derHistory,senario] = GoldenSectionSearch_Gradient(imgr,gr,PosGuess,Rcut,PosStep)
%initial condition
imsize=size(imgr.X);
[imgrR] = Reconstruct(imsize,gr,PosGuess,Rcut);
[er,~]=CompareGradient(imgr,imgrR);
er0=er;
N=length(PosGuess(:,1)); %number of particles
u=length(PosGuess(1,:)); %number of parameter
Sid=0; %Search index
derHistory=[];
BigNum = N*u;
ifContinue = true;
golden=0.618;
stepcut=10^-6;
%start search
while ifContinue
% find out which parameter to change
    idBig = floor(Sid/BigNum);
    id=(Sid-idBig*BigNum)+1;
    Nid=floor((id-1)/u)+1;
    uid=id-(Nid-1)*u;
 % optimization for this parameter
    step=PosStep(Nid,uid);
    NewGuess=PosGuess;
    NewGuess(Nid,uid)=NewGuess(Nid,uid)+step;
    [imgrR] = Reconstruct(imsize,gr,NewGuess,Rcut);
    [er,~]=CompareGradient(imgr,imgrR);
    loop=1;
    if er < er0
        step=step*(1+golden);
        PosStep(Nid,uid)=step;
        PosGuess=NewGuess;
        der=er0-er;
        er0=er;
    else
        while er >= er0
            loop=loop+1;
            if loop == 2
                step=-step*golden^2;
            else
                step=-step*golden;
            end
            NewGuess=PosGuess;
            NewGuess(Nid,uid)=NewGuess(Nid,uid)+step;
            [imgrR] = Reconstruct(imsize,gr,NewGuess,Rcut);
            [er,~]=CompareGradient(imgr,imgrR);
            if abs(step) < stepcut*0.01
                ifupdate = false;
                break
            else
                ifupdate = true;
            end
        end
        if ifupdate
            step=step*(1+golden);
            PosStep(Nid,uid)=step;
            PosGuess=NewGuess;
            der=er0-er;
            er0=er;
        else
            der=0;
        end
    end
    Sid=Sid+1;
    derHistory(Sid)=der;
    if Sid < 8
        der8=inf;
    else
        der8=mean(derHistory(Sid-7:Sid));
    end
    %criteria to stop
    if der8 < 10^-10
    ifContinue=false;
    senario = 1;
%     disp('Minimum found.') %debug
    end
    if idBig>100
    ifContinue=false;
    senario = 2;
%     disp('maximal iteration reached.') %debug
    end
    maxstep=max(abs(PosStep(:)));
    if maxstep<stepcut
    ifContinue=false;
    senario = 3;
%     disp('minimal searching step reached.')
    end
    
end
res=PosGuess;
res(:,5)=er;
end