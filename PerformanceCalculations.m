%% This part calculates the performance for M=2
clear all
clc
format compact


% Given 
M=2
Pe=10e-3;


EsN0=qfuncinv(Pe*M/(2*(M-1)))^2*(M^2-1)/6


a=qfuncinv(Pe*M/(2*(M-1)))^2*(M^2-1)/6;
c=0:0.1:5;
Ns=3*a./(c.^2*(M^2-1));

loglog(c,Ns)


