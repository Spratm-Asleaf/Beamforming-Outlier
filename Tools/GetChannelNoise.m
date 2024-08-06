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


function V = GetChannelNoise(N, L, mode, R)
% Simulate channel noise with dimensions of N times L
% mode: Noise type (Gaussian, Uniform, Laplacian, Student-T, Epsilon-Gassian-Uniform mixture, Epsilon-Gassian-Gassian mixture)

    mode = upper(mode);
    switch mode
        case 'GAUSSIAN'
            V = sqrt(1/2) * (randn(N, L) + 1j*randn(N, L));
            
            V = (chol(R))' * V;

        case 'LAPLACIAN'
            V = sqrt(1/2) * (laprnd(N, L) + 1j*laprnd(N, L));
            
            V = (chol(R))' * V;

        case 'T'
            dof = 3;
            var = dof/(dof - 2);
            V = sqrt(1/(2*var)) * (trnd(dof, N, L) + 1j*trnd(dof, N, L));
            
            V = (chol(R))' * V;

        case 'EPSILON-GAUSSIAN'  % Epsilon-contamination: N(0, 1) + eps*N(0, Var) where Var is the variance
            V = (chol(R))' * sqrt(1/2) * (randn(N, L) + 1j*randn(N, L));
            V_RE = real(V);
            V_IM = imag(V);

            eps = 0.1;
            No = round(L * eps);
            Var = 100;
            for i = 1:N
                outlier_location = randi(L, 1, No);     % Several outliers can be added onto the same location because
                                                        %    different interference sources work independently
                V_RE(i, outlier_location) = V_RE(i, outlier_location) + sqrt(Var) * randn(1, No);
                V_IM(i, outlier_location) = V_IM(i, outlier_location) + sqrt(Var) * randn(1, No);
            end

            V = V_RE + 1j * V_IM;

        otherwise
            error('GetChannelNoise :: Error in Channel Noise Mode :: Non-existing !');
    end
end
