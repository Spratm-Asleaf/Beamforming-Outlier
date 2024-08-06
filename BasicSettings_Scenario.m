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


%% The transmission signal model undergoes the impulse channel noises

M = 4;              % Number of transmiting antenna        
N = 8;              % Number of receiving antenna (for fixed M, the larger N, the better due to receiver diversity or data diversity)

Test_L  = 100;      % Data length; test data (NB: a frame is composed of [Pilot, Data])
Transmit_Power = 1; % Watt (this is not a sensitive parameter, no need to tune; only SNR matters)

% NB: The method is good only for small SNR, e.g., -10dB and 0dB. 
%     This is because when SNR is high, outliers introduce limited impacts in constellation-point recognition.
SNR = 1;          % 0.1 (-10dB), 1 (0dB), 10 (10dB), 100 (20dB), 316 (25dB), 1000 (30dB)

Communication_Modulation_Mode   = 'QPSK';       % 'QPSK', 'QAM' (i.e., QAM64), 'Gaussian'
Channel_Noise_Mode              = 'Epsilon-Gaussian';   % 'Gaussian', 'Laplacian', 'T' (i.e., Student T), 'Epsilon-Gaussian'
Performance_Evaluation_Mode     = 'SER';        % 'MSE', 'SER'

Pilot_Size = 10:5:100;                   % Pilot Size Used for Training Beamformers

%% Number of Monte-Carlo (MC) episodes in each simulation
MC_RUN = 25;        % or 100, no much difference           
