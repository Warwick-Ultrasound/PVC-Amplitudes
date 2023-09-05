%{
Did some maths on 18/08/23 to work out how in the error is that you
introduce by putting the transducers in the correct location for an SS path
when you're actually getting the LL path.If I put all the matsh together
it'll look horrific so I'm programming it instead to give some insight as
to how it behaves whenyou change different parameters.
%}

clear;
clc; 
close all;

% INPUTS

% transducers
T.cl = c_PEEK(20); % longitudinal velocity in wedge
T.theta = 38; % wedge angle in degrees

% pipe
P.t = 4.7E-3; % wall thickness
P.cl = 2351; % longitudinal speed in wall (currently PVC)
P.cs = 1140; % shear speed in wall (currently PVC)
P.OD = 63E-3;
P.ID = P.OD - 2*P.t; % interior diameter

% water
W.cl = c_water(20); % longitudinal speed in water

% vary wall thickness
wall = linspace(1E-3, 20E-3, 100);
E_wall = zeros(size(wall));
org_t = P.t; % save original pipe wall thickness to change it back later
for ii = 1:length(wall)
    P.t = wall(ii);
    E_wall(ii) = calc_error(T,P,W);
end
P.t = org_t; % reinstate original wall thickness

% Now vary ID
diam = linspace(20E-3, 300E-3, 100);
E_diam = zeros(size(diam));
org_ID = P.ID;
for ii = 1:length(diam)
    P.ID = diam(ii);
    E_diam(ii) = calc_error(T,P,W);
end
P.ID = org_ID; % reinstate original diameter

% plot results
figure;
t = tiledlayout(2,1);

nexttile;
plot(wall/1E-3, E_wall*100);
set(gca, 'FontName', 'Times');
set(gca, 'FontSize', 12);
xlim([wall(1), wall(end)]/1E-3);
xlabel("Wall Thickness /mm");

nexttile;
plot(diam/1E-3, E_diam*100);
set(gca, 'FontName', 'Times');
set(gca, 'FontSize', 12);
xlim([diam(1), diam(end)]/1E-3);
xlabel("Interior Diameter /mm");
ylabel(t, "Error /%", 'FontName', 'Times', 'FontSize', 14);


function E = calc_error(T, P, W)
    % takes three structs representing the Transducer, Pipe and Water, and
    % gives you the error as a fraction that is introduced by having the
    % transducers at the SS position when they should be at the LL
    % position.

    % Need L_LL, L_SS, theta_wLL and theta_wSS to get error

    % First do the SS path geometry
    theta_wSS = asind( W.cl/T.cl*sind(T.theta) ); % equation 14
    L_SS = 2*P.ID/cosd(theta_wSS); % equation 15
    theta_pSS = asind( P.cs/T.cl * sind(T.theta) ); % Snell's law for shear wave into wall

    % Now the LL path geometry using equations derived in paper
    theta_pLL = asind( P.cl/T.cl * sind(T.theta) ); % Snell's law for longitudinal wave into wall
    Z_wLL = 2*P.t*( tand(theta_pSS) - tand(theta_pLL) ) + 2*P.ID*tand(theta_wSS); % equation 18
    L_LL = sqrt( 4*P.ID^2 + Z_wLL^2 ); % equation 19
    theta_wLL = acosd(2*P.ID/L_LL);


    E = L_LL*sind(theta_wLL)/(L_SS*sind(theta_wSS)) - 1;
    

end

