clear; clc; close all

load('filtering_codeChallenge.mat')

% Plotting the signal to obtain
figure(1)
subplot(2,1,1)
plot(x,'r')
hold on
plot(y,'k')
title('Time domain')
legend('original signal','filtered signal')

% Lets explore the frequency domain
% power
N = length(x);
xpow = abs( fft( x )/N ).^2;
ypow = abs( fft( y )/N ).^2;
hz = linspace(0,fs/2,floor(N/2)+1);

subplot(2,1,2)
plot(hz,xpow(1:length(hz)),'r')
hold on
plot(hz,ypow(1:length(hz)),'k')
set(gca,'xlim',[0 80])
title('Frequency domain')
legend('original signal','filtered signal')

%%%%%%%%%%%%%%%%%%
% Low-pass 30 Hz %
%%%%%%%%%%%%%%%%%%

fcutoff = 30;
transw  = .2;
order   = round( 5*fs/fcutoff );
shape   = [ 1 1 0 0 ];
frex    = [ 0 fcutoff fcutoff+fcutoff*transw fs/2 ] / (fs/2);
 
% apply filter 
filtkern = firls(order,frex,shape);
y = filtfilt(filtkern,1,x);

% inspect visually effect of filter kernel
% fkernelorder(fs, frange, frex, shape)
% inspect visually effect of transition width
% ftransitionwidth(fs, frange, frex, shape)

%%%%%%%%%%%%%%%%%%
% High-pass 5 Hz %
%%%%%%%%%%%%%%%%%%
 
fcutoff = 5;
transw  = .05;
order   = round( 5*fs/fcutoff );
shape   = [ 0 0 1 1 ];
frex    = [ 0 fcutoff fcutoff+fcutoff*transw fs/2 ] / (fs/2);
 
% apply filter
filtkern = firls(order,frex,shape);
y = filtfilt(filtkern,1,y);

% inspect visually effect of filter kernel
% fkernelorder(fs, frange, frex, shape)
% inspect visually effect of transition width
% ftransitionwidth(fs, frange, frex, shape)
 
%%%%%%%%%%%%%%%%%%%%%%
% Notch out 18-24 Hz %
%%%%%%%%%%%%%%%%%%%%%%

fcutoff = [ 18 24 ];
transw  = .1;
order   = round( 5*fs/fcutoff(1) );
shape   = [ 1 1 0 0 1 1 ];
frex    = [ 0 fcutoff(1)*(1-transw) fcutoff fcutoff(2)+fcutoff(2)*transw fs/2 ] / (fs/2);
 
% apply filter 
filtkern = firls(order,frex,shape);
y = filtfilt(filtkern,1,y);

% inspect visually effect of filter kernel
% fkernelorder(fs, frange, frex, shape)
% inspect visually effect of transition width
% ftransitionwidth(fs, frange, frex, shape)
 
% Plot results
figure(2)
clf
subplot(211), hold on
plot(x,'r')
plot(y,'k')
title('Time domain')
 
yX = abs(fft(y)).^2;
xX = abs(fft(x)).^2;
hz = linspace(0,fs,N);
 
subplot(212), hold on
plot(hz,xX,'r');
plot(hz,yX,'k');
set(gca,'xlim',[0 80])
title('Frequency domain')
legend({'X';'Y'})

