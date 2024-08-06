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


clf;
hold on;

% % Wiener
%     plot(Pilot_Size, nanmean(Test_error_Wiener, 2), 'k-+', 'linewidth', 1.5, 'markersize', 6);
%     legend_label{1} = 'Wiener';

% Wiener-DL
    plot(Pilot_Size, nanmean(Test_error_Wiener_DL, 2), 'b-o', 'linewidth', 1.5, 'markersize', 6);
    legend_label{1} = 'Wiener-DL';

% Wiener-OA-DL
    plot(Pilot_Size, nanmean(Test_error_Wiener_OA_DL_2, 2), 'r-x', 'linewidth', 1.5, 'markersize', 8);
    legend_label{2} = 'Wiener-OA-DL (K = 4)';

    % plot(Pilot_Size, nanmean(Test_error_Wiener_OA_DL_2, 2), 'b-s', 'linewidth', 1.5, 'markersize', 8);
    % legend_label{4} = 'Wiener-OA-DL (K = 6)';

    % plot(Pilot_Size, nanmean(Test_error_Wiener_OA_DL_3, 2), 'r-x', 'linewidth', 1.5, 'markersize', 8);
    % legend_label{2} = 'Wiener-OA-DL (K = 2)';

legend_label = legend_label(~cellfun('isempty',legend_label)); 
legend(legend_label);

xlabel('Pilot Size');
ylabel(Performance_Evaluation_Mode);
set(gca, 'fontsize', 16);
box on;
axis([10 100 0.0 0.6])
