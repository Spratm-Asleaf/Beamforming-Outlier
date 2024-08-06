%{
    Online Supplementary Materials of the paper titled:
        "Distributionally Robust Outlier-Aware Receive Beamforming"
    By
        Shixiong Wang, Wei Dai, and Geoffrey Ye Li
    From 
        Intelligent Transmission and Processing Laboratory, Imperial College London
    
    @Author: Shixiong Wang (s.wang@u.nus.edu; wsx.gugo@gmail.com)
    @Date  : 8 April 2024
    @Site  : https://github.com/Spratm-Asleaf/Beamforming-Outlier
%}


%% Plot Fig. 1

addpath('Tools\');

x = -2.5:0.01:2.5;

%% Type 1: Sub-fig (a)
figure;
params.Type = 1; 
params.K = 1.399; 
y = psi_u(x, params);
plot(x, y, 'r', 'linewidth', 2)
xline(0,'k--')
yline(0,'k--')
set(gca, 'fontsize', 16)
axis([-2.5 2.5 -2 2])
xlabel('$\mu$', 'interpreter', 'latex')
ylabel('$\psi(\mu)$', 'interpreter', 'latex')

%% Type 2: Sub-fig (b)
figure;
params.Type = 2;
params.a = 1.0564;   
params.c = 1.2953; 
params.b = 1.7241; 
y = psi_u(x, params);
plot(x, y, 'r', 'linewidth', 2)
axis([-2.5 2.5 -2 2])
set(gca, 'fontsize', 16)
xline(0,'k--')
yline(0,'k--')
xlabel('$\mu$', 'interpreter', 'latex')
ylabel('$\psi(\mu)$', 'interpreter', 'latex')

%% Type 3: Sub-fig (c)
figure;
params.Type = 3;
params.a = 1.3216; 
params.c = 1.1788; 
params.b = 1.1637; 
y = psi_u(x, params);
plot(x, y, 'r', 'linewidth', 2)
axis([-2.5 2.5 -2 2])
set(gca, 'fontsize', 16)
xline(0,'k--')
yline(0,'k--')
xlabel('$\mu$', 'interpreter', 'latex')
ylabel('$\psi(\mu)$', 'interpreter', 'latex')