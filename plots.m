
clear all
clf
close all
clc


%================================
%======== CONST M=2 =============
%================================
c=5;
figure(1)
% Symbolerna
scatter([-c c],[0 0],50,'filled')
hold on

% Grid
plot([-10 10],[0 0],'black')
%plot([0 0],[-5 5],'black')

% Boundaries - Vill vi ha detta?
%plot([-10 0],[0 0],'r','linewidth',1.5)
%plot([0 10],[0 0],'g','linewidth',2)

% Boundarie points
plot([0 0],[-0.2 0.2],'black','linewidth',2)
title('Signal constellation, M=2')
axis equal
axis([-10 10 -2 2])
set(gcf,'color','w')

% Skriver ut c
annotation('textbox',[0.75 0.5 .1 .1],'String','c=5','FitBoxToText','on','FontSize',16);


% Text
text(-5,-0.7,'-c','FontSize',16,'HorizontalAlignment','center') 
text(5,-0.7,'c','FontSize',16,'HorizontalAlignment','center')
text(0,-0.7,'0','FontSize',14,'HorizontalAlignment','center') % Decision point


%================================
%======== CONST M=4 =============
%================================
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
set(gcf,'color','w')
axis equal
axis([-10 10 -2 2])


% Skriver ut c
annotation('textbox',[0.75 0.5 .1 .1],'String','c=5/3','FitBoxToText','on','FontSize',16);


% Text
text(-5,-0.7,'-3c','FontSize',16,'HorizontalAlignment','center') 
text(-5/3,-0.7,'-c','FontSize',16,'HorizontalAlignment','center')
text(5/3,-0.7,'c','FontSize',16,'HorizontalAlignment','center')
text(5,-0.7,'3c','FontSize',16,'HorizontalAlignment','center')

% Decision point
text(-2*5/3,-0.7,'-2c','FontSize',14,'HorizontalAlignment','center')
text(0,-0.7,'0','FontSize',14,'HorizontalAlignment','center')
text(2*5/3,-0.7,'2c','FontSize',14,'HorizontalAlignment','center')


%% Plotta transmit pulse

Nsm2=6;
Nsm4=51;

figure(1)
stem(rectpulse(1,Nsm2))
title('g(t) for M=2')


figure(2)
stem(rectpulse(1,Nsm4))
title('g(t) for M=4')
axis([-2 Nsm4+9 0 1.1])

