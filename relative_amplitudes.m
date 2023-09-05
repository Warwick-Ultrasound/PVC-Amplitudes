function [LL, LS, SL, SS] = relative_amplitudes(geom, transducer, pipe, fluid, f, theta0)
    % modify for PEEK - PVC boundary
    [A, theta] = solid_solid_boundary(transducer, pipe, theta0, f, 'long');
    LL = A(3); % transmitted longitudinal
    LS = A(3);
    SL = A(4); % transmitted shear
    SS = A(4);

    % attenuate through thickness of PVC
    L_PVC_long = geom.t*tand(theta(3)); % path length in PVC for longitudinal
    L_PVC_shear = geom.t*tand(theta(4));
    LL = attenuate(LL, pipe.alphaLong, L_PVC_long);
    LS = attenuate(LS, pipe.alphaLong, L_PVC_long);
    SL = attenuate(SL, pipe.alphaShear, L_PVC_shear);
    SS = attenuate(SS, pipe.alphaShear, L_PVC_shear);

    % PVC - water boundary
    [Along, thetaLong] = solid_liquid_boundary(pipe, fluid, theta(3), f, 'long');
    [Ashear, thetaShear] = solid_liquid_boundary(pipe, fluid, theta(4), f, 'shear');
    LL = LL*Along(3); % multiply by transmitted factor
    LS = LS*Along(3);
    SL = SL*Ashear(3);
    SS = SS*Ashear(3);

    % water - PVC boundary
    [A, theta] = liquid_solid_boundary(fluid, pipe, thetaLong(3), f); % thetaLong(3) = thetaShear(3) => same for both incident waves
    LL = LL*A(2); % transmitted longitudinal (no reflected shear)
    SL = SL*A(2); % transmitted longitudinal
    LS = LS*A(3); % transmitted shear
    SS = SS*A(3); % transmitted shear

    % PVC attenuation - 2nd wall encounter
    L_PVC_long = geom.t*tand(theta(2)); % longitudinal angle in PVC
    L_PVC_shear = geom.t*tand(theta(3)); % shear angle in PVC
    LL = attenuate(LL, pipe.alphaLong, L_PVC_long);
    SL = attenuate(SL, pipe.alphaLong, L_PVC_long);
    SS = attenuate(SS, pipe.alphaShear, L_PVC_shear);
    LS = attenuate(LS, pipe.alphaShear, L_PVC_shear);

    % refract both waves to longitudinal in PEEK - thats what we detect
    [Along, thetaLong] = solid_solid_boundary(pipe, transducer, theta(2), f, 'long');
    [Ashear, thetaShear] = solid_solid_boundary(pipe, transducer, theta(3), f, 'shear');
    LL = LL*Along(3); % refracted longitudinal coefficient for incident longitudinal
    SL = SL*Along(3); % refracted longitudinal coefficient for incident longitudinal
    LS = LS*Ashear(3); % refracted longitudinal coefficient for incident shear
    SS = SS*Ashear(3); % refracted longitudinal coefficient for incident shear

    % take absolute to get amplitude
    LL = abs(LL);
    LS = abs(LS);
    SL = abs(SL);
    SS = abs(SS);

end