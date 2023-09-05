function c = c_PEEK_shear(T)
    % A function which returns the shear wave velocity in PEEK. It does so
    % using a quadratic fit of experimental data from 25th oct '22 which is
    % in agreement with the values in Method for Acoustic Characterization 
    % of Materials in Temperature
    % (https://www.ndt.net/article/wcndt2016/papers/we3d3.pdf)
    p1 = 0.0043;
    p2 = -1.335;
    p3 = 1161;
    c = p1*T.^2 + p2*T + p3;
end