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


function [Rxs, Rx] = GetRxRxs(Train_X, Train_S)
% Wiener Outlier-Aware (OA) Beamformer
% eps_DL: epsilon coefficient of Diagonal Loading

    [~, Train_L] = size(Train_X);

    X = [
        real(Train_X)
        imag(Train_X)
    ];

    S = [
        real(Train_S)
        imag(Train_S)
    ];

    L = Train_L;

    Rx  = X*X'/L;

    Rxs = X*S'/L;
end

