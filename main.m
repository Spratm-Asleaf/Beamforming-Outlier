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


%% NB: The paper is marginal to the area because the performance improvement is not significant; cf. Fig. 2.
%      But the paper is not a rubbish because at least there are some benefits. 

rng(28);    % To guarantee my results are reproducible; just because I am 28 year old this year; no other reasons.

clear all;
clc;


%% Load Dependencies
addpath('Tools\');


%% Basic Settings
BasicSettings_Scenario;

Pilot_Size_Cnt = length(Pilot_Size);
Pilot_Size_Iter = 0;

%% Data Space
% Test Errors on Test Data
Test_error_Wiener          = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Wiener_DL       = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Wiener_OA_DL    = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Wiener_OA_DL_2  = zeros(Pilot_Size_Cnt, MC_RUN);
Test_error_Wiener_OA_DL_3  = zeros(Pilot_Size_Cnt, MC_RUN);

%% Monte-Carlo Loop
% Simulate Channel
H = randn(N, M) + 1j * randn(N, M);

for Train_L = Pilot_Size
    disp(['Pilot Size: ' num2str(Train_L)]);
    Pilot_Size_Iter = Pilot_Size_Iter + 1;

    for mc = 1:MC_RUN
        disp(['    MC: ' num2str(mc)]);
        
        % Transmitting power covariance
        P = sqrt(Transmit_Power) * eye(M);
        
        % Channel noise covariance
        Noise_Power = Transmit_Power/SNR;
        R = sqrt(Noise_Power)    * eye(N);
        
        %% Beamforming (Training Stage)
        % Transmitted pilot
        Train_S = GetCommSymbols(Communication_Modulation_Mode, M, Train_L, P);
        
        % Channel noise
        Train_V = GetChannelNoise(N, Train_L, 'Gaussian', R);        % Channel_Noise_Mode in training stage
        
        % Signal transmission (Frame-Flat Channel Assumption)
        Train_X = H*Train_S + Train_V;
        
        % Get Rx and Rxs
        [Wiener_Rxs, Wiener_Rx] = GetRxRxs(Train_X, Train_S);

        %% Communication (Testing Stage)
        % Transmitted data
        Test_S = GetCommSymbols(Communication_Modulation_Mode, M, Test_L, P);
        
        % Channel noise
        % To show robustness against distributional deviation, we let noise modes be different in training and testing stages
        Test_V = GetChannelNoise(N, Test_L, Channel_Noise_Mode, R);  % Channel_Noise_Mode in testing stage; Change it to 'Gaussian' if no outliers
        
        % Signal transmission
        Test_X = H*Test_S + Test_V;
    
        % Evaluation mode (MSE, SER, SINR)
        EvaluationParams.mode = Performance_Evaluation_Mode;
        EvaluationParams.demod_mode = Communication_Modulation_Mode;
        EvaluationParams.channel_noise = R;
        
        % Beamforming and Signal Estimation
        Test_X_RealSpace = [real(Test_X); imag(Test_X)];

        % Diagnal Loading (DL)
        theta = 0.05;  % NB: As a diagonal loading parameter, it cannot be overly large. Otherwise, the performance significantly reduces as Train_L gets larger.
        
        % Wiener
        Test_S_hat_Wiener = zeros(M, Test_L);
        for i = 1:Test_L
            Test_S_hat = Wiener_Rxs' * Wiener_Rx^(-1) * Test_X_RealSpace(:, i);
            Test_S_hat_Wiener(:, i) = Test_S_hat(1:M) + 1j*Test_S_hat(M+1:end);
        end
        Test_error_Wiener(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_Wiener, EvaluationParams);

        % Wiener-DL
        Test_S_hat_Wiener_DL = zeros(M, Test_L);
        for i = 1:Test_L
            Test_S_hat = Wiener_Rxs' * (Wiener_Rx + theta)^(-1) * Test_X_RealSpace(:, i);
            Test_S_hat_Wiener_DL(:, i) = Test_S_hat(1:M) + 1j*Test_S_hat(M+1:end);
        end
        Test_error_Wiener_DL(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_Wiener_DL, EvaluationParams);

        % Wiener-OA-DL-3 (K = 2)
        Test_S_hat_WienerOA_DL_3 = zeros(M, Test_L);
        params.Type = 1; 
        params.K = 2; 
        for i = 1:Test_L
            Test_S_hat = Wiener_Rxs' * (Wiener_Rx + theta)^(-1/2) * psi_u((Wiener_Rx + theta)^(-1/2) * Test_X_RealSpace(:, i), params);
            Test_S_hat_WienerOA_DL_3(:, i) = Test_S_hat(1:M) + 1j*Test_S_hat(M+1:end);
        end
        Test_error_Wiener_OA_DL_3(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerOA_DL_3, EvaluationParams);

        % Wiener-OA-DL (K = 4)
        Test_S_hat_WienerOA_DL = zeros(M, Test_L);
        params.Type = 1; 
        params.K = 4; 
        for i = 1:Test_L
            Test_S_hat = Wiener_Rxs' * (Wiener_Rx + theta)^(-1/2) * psi_u((Wiener_Rx + theta)^(-1/2) * Test_X_RealSpace(:, i), params);
            Test_S_hat_WienerOA_DL(:, i) = Test_S_hat(1:M) + 1j*Test_S_hat(M+1:end);
        end
        Test_error_Wiener_OA_DL(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerOA_DL, EvaluationParams);

        % Wiener-OA-DL-2 (K = 6)
        Test_S_hat_WienerOA_DL_2 = zeros(M, Test_L);
        params.Type = 1; 
        params.K = 6; 
        for i = 1:Test_L
            Test_S_hat = Wiener_Rxs' * (Wiener_Rx + theta)^(-1/2) * psi_u((Wiener_Rx + theta)^(-1/2) * Test_X_RealSpace(:, i), params);
            Test_S_hat_WienerOA_DL_2(:, i) = Test_S_hat(1:M) + 1j*Test_S_hat(M+1:end);
        end
        Test_error_Wiener_OA_DL_2(Pilot_Size_Iter, mc) = Performance(Test_S, Test_S_hat_WienerOA_DL_2, EvaluationParams);
    end
end

%% Show results
PlotResults;

