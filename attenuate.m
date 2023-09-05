function A2 = attenuate(A1, alpha, d)
    % Calcuates the amplitude of a wave after travelling some distance
    % through an attenuating medium. The input arguments are:
    % A1: the initial amplitude
    % alpha: the attenuation coefficient
    % d: the distance travelled in the medium (in dB/m)
    % It ouputs the amplitude after having travelled the distance through
    % the medium.

    alpha = alpha*d; % actual attenuation over d in dB

    A2 = A1*10^(alpha/20);
end

