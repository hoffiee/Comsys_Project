
clear all
clf
close all
clc


% M=2
c=5;
figure(1)
% Symbolerna
scatter([-c c],[0 0],50,'filled')
hold on

% Grid
plot([-10 10],[0 0],'black')
plot([0 0],[-5 5],'black')

% Boundaries - Vill vi ha detta?
%plot([-10 0],[0 0],'r','linewidth',1.5)
%plot([0 10],[0 0],'g','linewidth',2)

% Boundarie points
plot([0 0],[-0.2 0.2],'black','linewidth',2)
title('Signal constellation, M=2')
axis([-10 10 -5 5])

% M=4
c=5/3;
figure(2)
% Symbolerna
scatter([-3*c -c c 3*c],[0 0 0 0],50,'filled')
hold on

% Grid
plot([-10 10],[0 0],'black')
%plot([0 0],[-5 5],'black')

% Boundaries - Vill vi ha detta?
%plot([-10 0],[0 0],'r','linewidth',1.5)
%plot([0 10],[0 0],'g','linewidth',2)

% Boundarie points
plot([0 0],[-0.2 0.2],'black','linewidth',2)
plot([2*c 2*c],[-0.2 0.2],'black','linewidth',2)
plot([-2*c -2*c],[-0.2 0.2],'black','linewidth',2)
title('Signal constellation, M=4')

