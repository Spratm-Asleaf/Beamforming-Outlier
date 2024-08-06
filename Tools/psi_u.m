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


function ret = psi_u(U, params)
    ret = zeros(size(U));
    len = length(U);
    for i = 1:len
        u = U(i);
        switch params.Type
            case 1  
                K = params.K;

                if u <= -K
                    ret(i) = -K;
                elseif u >= K
                    ret(i) = K;
                else
                    ret(i) = u;
                end

            case 2
                a = params.a;
                b = params.b;
                c = params.c;

                if u >= 0
                    if u >= b
                        ret(i) = b;
                    elseif u >= a && u < b
                        ret(i) = u;
                    elseif u >= 0 && u < a
                        ret(i) = c*tan(0.5*c*u);
                    else
                        error('psi_u :: Type = 2 :: Error in u >= 0');
                    end
                else
                    if u <= -b
                        ret(i) = -b;
                    elseif u <= -a && u > -b
                        ret(i) = u;
                    elseif u > -a && u < 0
                        ret(i) = c*tan(0.5*c*u);
                    else
                        error('psi_u :: Type = 2 :: Error in u < 0');
                    end 
                end

            case 3
                a = params.a;
                b = params.b;
                c = params.c;

                if u >= 0
                    if u >= a
                        ret(i) = b;
                    elseif u >= 0 && u < a
                        ret(i) = c*tan(0.5*c*u);
                    else
                        error('psi_u :: Type = 3 :: Error in u >= 0');
                    end
                else
                    if u <= -a
                        ret(i) = -b;
                    elseif u > -a && u < 0
                        ret(i) = c*tan(0.5*c*u);
                    else
                        error('psi_u :: Type = 3 :: Error in u < 0');
                    end 
                end

        end
    end
end

