function yy=GenerateGaussians(tt,yy,t0,AA,sigT,AM,tOn)
    if ( ~exist('AM','var') ), AM=missing(); end
    for ii=1:length(sigT)
        if (~exist('tOn','var')), nSig=5; tOn=nSig*sigT(ii); end
        for jj=1:length(t0)
            myIndices=(t0(jj)-tOn<tt & tt<=t0(jj)+tOn);
            % update signal array only in case of non-zero indices
            if ( sum(myIndices)>0 )
                % update value at lower extreme only in case of first
                %    Gaussian
                if ( tt(1)==t0(jj)-tOn ), myIndices(1)=true; end
                mySig=AA(ii)/(sqrt(2*pi)*sigT(ii))*exp(-0.5*((tt(myIndices)-t0(jj))/sigT(ii)).^2);
                if ( ~ismissing(AM) ), mySig=mySig*AM(jj); end
                yy(myIndices,ii)=yy(myIndices,ii)+mySig;
            end
        end
    end
end
