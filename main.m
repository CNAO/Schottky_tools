%script generating 4 signals (longitudinal and transversal) for a single
%particle case with RF and without RF (bunched and unbunched case
%respectively);

%here follows a list of machine and beam parameters used to visualize
%signals

%%configuration paramaters
fsamp=125*10^6; %sampling frequency of the signal
intTime=20*10^-6; %integration time
fs=1.173*10^3; %synchrotron frequency ~1kHz
friv=2.167*10^6; %revolution frequency
Triv=1/friv; %revolution period
dt=1/fsamp; %temporal step
t=time(intTime,dt); %time vector
w=80*10^-9; %100ns: width of impulse/rect < (1/(2*friv))
n=size(t,1); %number of samples
df=fsamp/n; %frequency step
f=(0:df:fsamp-df)'; %frequency vector

%comparing parametric curves in synchrotron frequency with values:
fsy=([0.5865, 1.173, 2.346]*10^3)';

%comparing parametric curves in horizontal tune with values:
qhv=[1.656, 1.666, 1.676];

%time modulation
taus=0.125*Triv; %width of space function (Triv!=cost.), must be <Triv/2=1/(2*friv)
%I choose tau/4 because it's 1st harmonic
tau=taus*sin(2*pi*fs*t);

%beatatron motion
qh=1.676; %horizontal tune (int+fract)
fb=qh*friv; %beatatron frequency
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid
y=(a0+a*cos(2*pi*fb*t+pi/2)); %modulation sinusoid: transverse position


x=rectpuls(t,w); %longi unbunched
x1=x; %longi bunched

%comparing parametric curves in synchrotron frequency, curves are:
[xx1,XX1] = compare_fsy(fsy,friv,t,taus,x,w,f);

for i=1:n
    x=x+rectpuls(t-i*Triv,w); %longi unbunched
end

%X=fftshift(fft(x));
X=fft(x);

if taus~=0 %need to add n*1/friv where n is the array position
    for k=1:n
        tau(k)=k/friv+tau(k);
    end
end

for j=1:n
    x1=x1+rectpuls(t-tau(j),w); %longi bunched
end

%comparing parametric curves in hoorizontal tune values, curves are:
[zz0,ZZ0,zz1,ZZ1] = compare_qh(qhv,a0,a,x,x1,friv,t,f);

%IMPeng: in this case I realize that to resolve the synchrotron frequency
%(~ 1kHz) I need much longer integration times than unbunched case
%IMPit: in questo caso mi rendo conto che per risolvere la freq. di
%sincrotrone (~1kHz) ho bisogno di tempi di integrazione molto maggiori
%rispetto all'unbunched

%X1=fftshift(fft(x1));
X1=fft(x1);

%trans unbunched e bunched: new signal modulated in phase by the tune
if qh~=0 && a~=0
    z=x.*y; %trans unbunched
    %Z=fftshift(fft(z));
    Z=fft(z);
    z1=x1.*y; %trans bunched
    %Z1=fftshift(fft(z1));
    Z1=fft(z1);
end

T=[t,x,x1,z,z1]; %matrix for time values
F=[f,X,X1,Z,Z1]; %matrix for frequency values

plotTimesFreqfig(T,F);
%title(['Intergration time=',num2str(T(end,1)+dt),'s']);
%title(['Sampling frequency=',num2str(fsamp),'Hz']);
%title(['Synchrotron frequency=',num2str(fs),'Hz']);
%title(['Betatron frequency @ (qh=1.676 & revolution frequency= 2.334 MHz)=',num2str(fb),'Hz']);
%title(['Avg. of the mod. sin=',num2str(a0),' maybe mA']);
%title(['Amp. of the mod. sin=',num2str(a),' maybe mA']);
%title(['Width of the spacing function=',num2str(taus),'s']);

%%comparing synchrotron frequency values, activate this section if you want 
%%to plot parametric curves with values expressed by 'fsy'
plotTimesFreqfig(xx1,XX1);
title('Curves with different synchrotron frequency values');
legend('Longi Bunched w/ fs(1)','Longi Bunched w/ fs(2)','Longi Bunched w/ fs(3)');

%%comparing horizontal tune values, activate this section if you want to
%%plot parametric curves with values expressed by 'qhv'
plotTimesFreqfig(zz0,ZZ0);
title('Transversal unbunched curves with different horizontal tune values');
legend('qh=1.656','qh=1.666','qh=1.676')
hold on;
plotTimesFreqfig(zz1,ZZ1);
title('Transversal bunched curves with different horizontal tune values');
legend('qh=1.656','qh=1.666','qh=1.676');

