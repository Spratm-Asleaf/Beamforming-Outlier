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


function ret = Performance(S, S_hat, params)
% Communication Performance Evaluation

    mode = upper(params.mode);
    switch mode
        case 'MSE'      % mean-squared error
            ret = (norm(S - S_hat, 'fro'))^2;

        case 'SUM_RATE' % achivable sum rate
            ret = GetAvrgSumRate(S, S_hat, params.channel_noise);

        case 'SINR' % signal-to-interference-plus-noise ratio
            SINR = GetSINR(S, S_hat, params.channel_noise);
            ret = mean(SINR);

        case 'SER'  % symbol error rate
            demod_mode = upper(params.demod_mode);
            switch demod_mode
                case 'QPSK'
                    Q = 4;
                    data       = pskdemod(S, Q, pi/Q);
                    data_hat   = pskdemod(S_hat, Q, pi/Q);
                    [~, ret] = symerr(data, data_hat);

                case 'QAM'
                    No = 64;
                    data       = qamdemod(S, No);
                    data_hat   = qamdemod(S_hat, No);
                    [~, ret] = symerr(data, data_hat);

                otherwise
                    error('Performance :: Error in Demodulation Mode :: Non-existing !');
            end

        otherwise
            error('Performance :: Error in Performance Evaluaiton Mode :: Non-existing !');
    end
end

function SumRate = GetAvrgSumRate(S, S_hat, Rv)
% Calculate Average Achievable Sum-Rate 

    SINR = GetSINR(S, S_hat, Rv);
    SumRate = mean(log2(1 + SINR));
end

function SINR = GetSINR(S, S_hat, Rv)
% Calculate SINR

    [M, L] = size(S);
    SINR = zeros(M, 1);
    for i = 1:M
        signal_power        = 0;
        interference_power  = 0;
        for j = 1:L
            signal_power        = signal_power + (abs(S(i, j)))^2;

            if i ~= j
                interference_power  = interference_power + (abs(S_hat(i, j) - S(i, j)))^2;
            end
        end
        signal_power        = signal_power/L;
        interference_power  = interference_power/(L - 1);
        noise_power         = Rv(i, i);

        SINR(i) = signal_power/(interference_power + noise_power);
    end
end