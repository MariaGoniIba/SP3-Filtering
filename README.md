# Signal Processing (SP) project 3: Filtering

# Credit
The dataset and proposal of the exercise is from the Udemy course [Signal Processing Problems, solved in Matlab and in Python](https://www.udemy.com/course/signal-processing/). 
I highly recommend this course for those interested in signal processing.

# Exercise
Given the original noisy signal (red) in the following figure, filter it to get the filtered result (black).

<p align="center">
    <img width="600" src="https://github.com/MariaGoniIba/SP3-Filtering/blob/main/SignalToObtain.png">
</p>

# Solution
The procedure to filter time series data is:

Step 1) Define frequency-domain shape and cut-offs

Step 2) Generate filter kernes (firls, fir1, butter or other)

Step 3) Evaluate kernel and its power spectrum

Step 4) Apply filter kernel to data

First, I analyse the signal to obtain in the frequency-domain, to define the frequency-domain shape and cut-offs.
<p align="center">
    <img width="400" src="https://github.com/MariaGoniIba/SP3-Filtering/blob/main/SignalToObtainFrequency.png">
</p>

I will be applying finite impulse response least squares (firls) filters. 
It is normally recommended to apply several separate filters rather than a single wide filter kernel. 
When plotting the frequency response of filter (firls) you always get some ripple effects, particularly with a relatively wide filter. 

To choose the best parameters of the kernel, such as the order or the transition width, I evaluate the power spectrum.
Functions _fkernelorder.m_ and _ftransitionwidth.m_ help understand how different parameters affect the functioning of the kernel and choose the best parameters of the filter, as per the example of the following figure.
<p align="center">
    <img width="1000" src="https://github.com/MariaGoniIba/SP3-Filtering/blob/main/ExampleDifferentKernels.png">
</p>

Finally, I chose to apply a  low-pass filter with cut-off at 30 Hz, followed by a high-pass filter at 5 Hz and finally to notch-out frequencies between 18-24 Hz. 

And voilà!

<p align="center">
    <img width="600" src="https://github.com/MariaGoniIba/SP3-Filtering/blob/main/Results.png">
</p>
