function c = c_PEEK(T)
    % A function which calculates the speed of sound in PEEK from a
    % quadratic fit of experimental data taken in February 2022 by the authors. 
    c = zeros(length(T), 1);
    for ii = 1:length(T)
        if T(ii) < 12 || T(ii) > 70
            warning("T out of range for c_PEEK, values extrapolated.");
            disp("Valid range is 12 - 70 degrees C");
        end
        
        p1 = 0.005498;
        p2 = -2.371;
        p3 = 2627;
        c(ii) = p1*T(ii)^2 + p2*T(ii) + p3;
    end
end