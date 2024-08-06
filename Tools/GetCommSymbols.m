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


function Symbols = GetCommSymbols(mode, rows, cols, P)
    % Get transmitted signals, the average power of which is unity, that is, Symbols*Symbols'/cols = eye(rows)
    mode = upper(mode);
    switch mode
        case 'QPSK'
            Q = 4;
            data    = randi([0 Q-1], rows, cols);    % Binary data
            Symbols = pskmod(data, Q, pi/Q);         % QPSK symbols

        case 'QAM'
            No      = 64;                            % Number of points in a QAM constellation, typical values are 16, 64
            data    = randi([0 No-1], rows, cols);   % Generate random QAM symbols
            Symbols = qammod(data, No, 'UnitAveragePower', true);              % Modulate the symbols to QAM signal

        case 'GAUSSIAN'
            Symbols = (sqrt(2)/2) * (randn(rows, cols) + 1j*randn(rows, cols));

        otherwise
            error('GetCommuSymbols :: Error in Modulation Mode :: Non-existing !');
    end
    
    Symbols = (chol(P))' * Symbols;
end