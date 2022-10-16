%% effects of the filter transition width

function [] = ftransitionwidth(fs, frange, frex, shape)

% range of transitions
transwidths = linspace(.01,.2,10);

% initialize
fkernX = zeros(length(transwidths),1000);
hz = linspace(0,fs,1000);

figure(3), clf
for ti=1:length(transwidths)
    
    % create filter kernel
    frex  = [ 0 frange(1)-frange(1)*transwidths(ti) frange(1) frange(2) frange(2)+frange(2)*transwidths(ti) (fs/2) ] / (fs/2);
    fkern = firls(400,frex,shape);
    n(ti) = length(fkern);

    % take its FFT
    fkernX(ti,:) = abs(fft(fkern,1000)).^2;
    
    % show in plot
    subplot(211), hold on
    plot((1:n(ti))-n(ti)/2,fkern+.01*ti,'linew',2)

    subplot(223), hold on
    plot(hz,fkernX,'linew',2)
    plot(frex*fs/2,shape,'k','linew',4)
    set(gca,'xlim',[(frange(1) - frange(1)*0.7) (frange(2)*1.5)])

    subplot(224)
    plot(hz,10*log10(fkernX),'linew',2)
    set(gca,'xlim',[(frange(1) - frange(1)*0.7) (frange(2)*1.5)])

    pause(2)
end
subplot(211)
xlabel('Time (ms)')
set(gca,'ytick',[])
title('Filter kernels with different transition widths')

subplot(223)
xlabel('Frequency (Hz)'), ylabel('Attenuation')
title('Frequency response of filter (firls)')

subplot(224)
xlabel('Frequency (Hz)'), ylabel('Attenuation (log)')
title('Frequency response of filter (firls)')