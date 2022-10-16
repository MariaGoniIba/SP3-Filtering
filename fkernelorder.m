%% effects of the filter kernel order

function [] = fkernelorder(fs, frange, frex, shape)

ordersF = ( 10*fs/frange(1)) / (fs/1000);
ordersL = (18*fs/frange(1)) / (fs/1000);

orders = round( linspace(ordersF,ordersL,10) );

% initialize
fkernX = zeros(length(orders),1000);
hz = linspace(0,fs,1000);

figure(2), clf
for oi=1:length(orders)
    
    % create filter kernel
    fkern = firls(orders(oi),frex,shape);
    n(oi) = length(fkern);

    % take its FFT
    fkernX(oi,:) = abs(fft(fkern,1000)).^2;
    
    % show in plot
    subplot(211), hold on
    % shifted in the y axis for better visualization with fkern+0.1*oi
    plot((1:n(oi))-n(oi)/2,fkern+.01*oi,'linew',2)

    subplot(223), hold on
    set(gca,'xlim',[(frange(1) - frange(1)*0.7) (frange(2)*1.5)])
    plot(hz,fkernX,'linew',2)
    plot(frex*fs/2,shape,'k','linew',4)

    subplot(224)
    plot(hz,10*log10(fkernX),'linew',2)
    set(gca,'xlim',[(frange(1) - frange(1)*0.7) (frange(2)*1.5)])

    pause(2)
end
subplot(211)
xlabel('Time (ms)')
set(gca,'ytick',[])
title('Filter kernels with different orders')

subplot(223)
xlabel('Frequency (Hz)'), ylabel('Attenuation')
title('Frequency response of filter (firls)')

subplot(224)
xlabel('Frequency (Hz)'), ylabel('Attenuation (log)')
title('Frequency response of filter (firls)')