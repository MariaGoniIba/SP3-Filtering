clear; clc; close all

load('filtering_codeChallenge.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reproduce Mike proposal %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
legend('original signal','filtered signal')

% Since this is offline data, I will prefer to use a FIR filter instead of IIR
% 2 signals. One filtered 5-20Hz. Another 25-35. Then add them together 

%%%%%%%%%%%%%%%%%%%%
% filtered 5-20 Hz %
%%%%%%%%%%%%%%%%%%%%
frange  = [5 15];
transw  = .1; %10%
order   = round( 8*fs/frange(1) );

shape   = [ 0 0 1 1 0 0 ]; %gain
frex    = [ 0 frange(1)-frange(1)*transw frange frange(2)+frange(2)*transw (fs/2) ] / (fs/2); %divide by nyquist since they have to be fraction number from the nyquist frequency

% filter kernel
filtkern1 = firls(order,frex,shape);
%filtkern1 = firls(800,frex,shape);

% compute the power spectrum of the filter kernel
filtpow1 = abs(fft(filtkern1)).^2;
% compute the frequencies vector and remove negative frequencies
hz1      = linspace(0,fs/2,floor(length(filtkern1)/2)+1);
filtpow1 = filtpow1(1:length(hz1));

figure(2), clf
subplot(231)
plot(filtkern1,'linew',2)
xlabel('Time points')
title('Filter kernel (firls)')
axis square

% plot amplitude spectrum of the filter kernel
subplot(232), hold on
plot(hz1,filtpow1,'ks-','linew',2,'markerfacecolor','w')
plot(frex*(fs/2),shape,'ro-','linew',2,'markerfacecolor','w')

% make the plot look nicer
set(gca,'xlim',[0 frange(2)*2])
xlabel('Frequency (Hz)'), ylabel('Filter gain')
legend({'Actual';'Ideal'})
title('Frequency response of filter (firls)')
axis square

% It is the same black one as the previous plot but in the logarithmic
% domain
subplot(233), hold on
plot(hz1,10*log10(filtpow1),'ks-','linew',2,'markersize',10,'markerfacecolor','w') 
plot([1 1]*frange(1),get(gca,'ylim'),'k:')
set(gca,'xlim',[0 frange(1)*8],'ylim',[-80 2])
xlabel('Frequency (Hz)'), ylabel('Filter gain (dB)')
title('Frequency response of filter (firls)')
axis square

% inspect visually effect of filter kernel
%fkernelorder(fs, frange, frex, shape)
% inspect visually effect of transition width
%ftransitionwidth(fs, frange, frex, shape)

%%%%%%%%%%%%%%%%%%%%%
% filtered 28-35 Hz %
%%%%%%%%%%%%%%%%%%%%%
lower_bnd = 28; % Hz
upper_bnd = 35; % Hz
frange =  [lower_bnd upper_bnd];

lower_trans = 0.1;
upper_trans = 0.1;

filtorder = 30*round(fs/lower_bnd);

filt_shape = [ 0 0 1 1 0 0 ];
filt_freqs = [ 0 lower_bnd*(1-lower_trans) lower_bnd ...
                 upper_bnd upper_bnd+upper_bnd*upper_trans ...
                 (fs/2) ] / (fs/2);

filtkern2 = firls(filtorder,filt_freqs,filt_shape);
hz2 = linspace(0,fs/2,floor(length(filtkern2)/2)+1);
filtpow2 = abs(fft(filtkern2)).^2;
filtpow2 = filtpow2(1:length(hz2));

subplot(234)
plot(filtkern2,'linew',2)
xlabel('Time points')
title('Filter kernel (firls)')
axis square

% plot amplitude spectrum of the filter kernel
subplot(235), hold on
plot(hz2,filtpow2,'ks-','linew',2,'markerfacecolor','w')
plot(filt_freqs*(fs/2),filt_shape,'ro-','linew',2,'markerfacecolor','w')

% make the plot look nicer
set(gca,'xlim',[20 40])
xlabel('Frequency (Hz)'), ylabel('Filter gain')
legend({'Actual';'Ideal'})
title('Frequency response of filter (firls)')
axis square

% It is the same black one as the previous plot but in the logarithmic
% domain
subplot(236), hold on
plot(hz2,10*log10(filtpow2),'ks-','linew',2,'markersize',10,'markerfacecolor','w') 
plot([1 1]*frange(1),get(gca,'ylim'),'k:')
set(gca,'xlim',[10 60],'ylim',[-80 2])
xlabel('Frequency (Hz)'), ylabel('Filter gain (dB)')
title('Frequency response of filter (firls)')
axis square


% inspect visually effect of filter kernel
%fkernelorder(fs, frange, frex, shape)
% inspect visually effect of transition width
%ftransitionwidth(fs, frange, frex, shape)

%%%%%%%%%%%%%%%
% pass to time domain both filtered signals and add them up
sigfilt1 = filtfilt(filtkern1,1,x);
sigfilt2 = filtfilt(filtkern2,1,x);

% Lets explore the frequency domain
% power
sigfiltpow1 = abs( fft( sigfilt1 )/N ).^2;
sigfiltpow2 = abs( fft( sigfilt2 )/N ).^2;
hz = linspace(0,fs/2,floor(N/2)+1);

figure(3)
plot(hz,sigfiltpow1(1:length(hz)),'r')
hold on
plot(hz,sigfiltpow2(1:length(hz)),'k')
set(gca,'xlim',[0 80])

% add both filtered signals
sigfilt = sigfilt1 + sigfilt2;
sigfiltpow = abs( fft( sigfilt )/N ).^2;

figure(4)
plot(hz,xpow(1:length(hz)),'r')
hold on
plot(hz,sigfiltpow(1:length(hz)),'k')
set(gca,'xlim',[0 80])
