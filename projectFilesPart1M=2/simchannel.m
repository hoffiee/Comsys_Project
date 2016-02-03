function [r] = simchannel(s, noise_flag)
% r = simchannel(s,noise_flag)
% Simulates a noisy channel with clipping. The noise is additive, white 
% and Gaussian.  The input signal samples are clipped (constrained) in 
% amplitude to be in the interval [-5, +5]. 
%
% The input and output signal are assumed to be sampled at the sample rate 
% fs Hz. 
%
% Inputs:
%   s           = samples of transmitted signal (sample rate fs Hz)
%   noise_flag  = flag for noise [0: no noise, 1: noise]
%
% Outputs:
%   r           = samples of the received signal (sample rate fs Hz)
%
% Rev. B (VT 2015)

% Clip amplitude to +- 5 Volts
s(s > 5) = 5;
s(s < -5) = -5;

% Add Gaussian noise
sigma2 = 15;

% Note that the noise is 0 if noise_flag == 0
if noise_flag
    w =sqrt(sigma2) * randn(size(s));
else
    w=0;
end

r = s + w;