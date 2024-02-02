function [LL, LS, SL, SS] = relative_amplitudes(geom, transducer, pipe, fluid, f, theta0, contactType)
    % A function which uses all of the others to track the acoustic
    % propagation through the flowmeter and calculate the amplitudes.
    %
    % Inputs:
    % geom: A struct representing the meter geometry with fields:
    %   t: wall thickness
    % transducer: A struct representing the transducer material with fields
    % matching m1 and m2 in other function defs
    % pipe: struct representing pipe wall material, see m1,m2
    % fluid: material properties struct for the fluid
    % f: frequency
    % theta0: angle of incidence into wall
    % contactType: takes values "rigid" or "slip" to represent boundary
    % between transducer and pipe. "rigid" if transducer bonded to surface,
    % "slip" if using liquid couplant e.g. gel.

    % set function for transducer-pipe boundary
    if contactType == "rigid"
        transducer_contact = @solid_solid_boundary;
    elseif contactType == "slip"
        transducer_contact = @solid_solid_with_coupling;
    else
        error("Incorrect contactType in relative_amplitudes function call.");
    end

    % modify for PEEK - PVC boundary
    [A, theta] = transducer_contact(transducer, pipe, theta0, f, 'long');
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
    [A, theta] = liquid_solid_boundary(fluid, pipe, thetaShear(3), f); % thetaLong(3) = thetaShear(3) => same for both incident waves, but thetaLong might be NaN if beyond critical angle
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
    [Along, thetaLong] = transducer_contact(pipe, transducer, theta(2), f, 'long');
    [Ashear, thetaShear] = transducer_contact(pipe, transducer, theta(3), f, 'shear');
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