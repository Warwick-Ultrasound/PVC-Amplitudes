function c_l = c_water(T)
    % A function which calculates the speed of sound in water based on a
    % fit of data from The Journal of the Acoustical Society of America
    % 1993 between 0 and 60 degrees celcius
    c_l = zeros(length(T), 1);
    for ii = 1:length(T)
        if T(ii) < 0 || T(ii) > 60
            warning("T outside of range of fitted data. Result will be extrapolated.");
            disp("Valid T range is 0 to 60 degrees C.");
        end
        
        p1 = 0.0001866;
        p2 = -0.05278;
        p3 = 4.97;
        p4 = 1403;
        
        c_l = p1*T(ii)^3 + p2*T(ii)^2 + p3*T(ii) + p4;
    end

end