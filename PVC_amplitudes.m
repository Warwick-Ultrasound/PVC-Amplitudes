% A script which calculates the amplitudes of all of the different pathways 
% ultrasound can take in a clamp-on meter on a PVC pipe. Considers all combinations 
% of shear and longitudinal in the pipe wall: long-long, long-shear, shear-long
% and shear-shear
%
% MATERIAL PROPERTY REFS (CORRESPOND TO LABELS IN LATEX)
% [1] PEEK_G
% [2] PVC_1
% [3] PVC_2
% [4] PVC_shear*
% [5] water_sos
% [6] water_density
% [7] PVC_density
% [8] steel_G
% [9] steel_c
% [10] steel_density
% [11] steel_alphalong
% [12] steel_alphashear
% * Estimate based on figure, but limited experimental data availible

clear;
clc;
close all;

theta0 = linspace(0, 55, 1000); % transducer angle
f = 1E6; % frequency

% Enter material parameters

T = 20; % temperature /degrees C

% PEEK
PEEK.clong = c_PEEK(T);
PEEK.cshear = c_PEEK_shear(T);
PEEK.G = 1.52E9; % shear modulus [1]
PEEK.rho = 1.285E3; % density [1]

% PVC
PVC.clong = 2351; % [2]
PVC.cshear = 1140; % [2]
PVC.G = 1.83E9; % [2]
PVC.rho = 1380; % [7]
PVC.alphaLong = 239*(f/1E6); % attenuation in dB/m  [3]
PVC.alphaShear = 875; % [4]

% Steel SS316
steel.clong = 5790; % [10]
steel.cshear = 3220; % [9]
steel.G = 79.2E9; % [8]
steel.rho = 7870; % [10]
steel.alphaLong = 8; % estimated from plot [12]
steel.alphaShear = 8; % estimated from plot [12]

% water
water.clong = c_water(T); % [5]
water.rho = 1000; % [6]

% pipe geometry struct
geom.OD = 63E-3;
geom.t = 4.7E-3;
geom.ID = geom.OD - 2*geom.t;

% start calculating amplitudes
A_steel = zeros(length(theta0), 4);
A_PVC = A_steel;

for ii = 1:length(theta0)

    [LL,LS, SL, SS] = relative_amplitudes(geom, PEEK, steel, water, f, theta0(ii));
    A_steel(ii,1) = LL;
    A_steel(ii,2) = LS;
    A_steel(ii,3) = SL;
    A_steel(ii,4) = SS;

    [LL,LS, SL, SS] = relative_amplitudes(geom, PEEK, PVC, water, f, theta0(ii));
    A_PVC(ii,1) = LL;
    A_PVC(ii,2) = LS;
    A_PVC(ii,3) = SL;
    A_PVC(ii,4) = SS;

end

% create composite figure with both panels
figure;
t = tiledlayout(2, 1, 'TileSpacing', 'none');
%t.FontName = 'Times';

nexttile;
plot(theta0, A_PVC);
ylabel(t, "Relative Amplitude", 'FontName', 'Times', 'FontSize', 14);
legend('LL', 'LS', 'SL', 'SS');
set(gca, 'Xticklabel', []); % turn off tick labels for top plot
set(gca, 'FontName', 'Times');
set(gca, 'FontSize', 12);
ylim([-0.05, 0.8]); % shift up slightly so you can see all lines
xlim([theta0(1), theta0(end)]);

nexttile;
plot(theta0, A_steel);
set(gca, 'FontName', 'Times');
set(gca, 'FontSize', 12);
xlabel("Wedge Angle /^\circ");
legend('LL', 'LS', 'SL', 'SS');
xlim([theta0(1), theta0(end)]);
ylim([-0.002, 0.065]);