% A script which calculates the amplitudes of all of the different pathways 
% ultrasound can take in a clamp-on meter on a (U)PVC pipe. Considers all combinations 
% of shear and longitudinal in the pipe wall: long-long, long-shear, shear-long
% and shear-shear

clear;
clc;
close all;

theta0 = linspace(0, 55, 1000); % transducer angle
f = 1E6; % frequency

% set contact type between transducer and pipe
% uncomment this for a solid bond e.g. epoxied to surface:
contactType = "rigid";
% uncomment this for a slip bond e.g. gel couplant:
%contactType = "slip";

% Enter material parameters
T = 20; % temperature /degrees C

% PEEK
PEEK.clong = c_PEEK(T);
PEEK.cshear = c_PEEK_shear(T);
PEEK.G = 1.52E9;
PEEK.rho = 1.285E3; 

% PVC
PVC.clong = 2352; 
PVC.cshear = 1093; 
PVC.G = 1.80E9; 
PVC.rho = 1505; 
PVC.alphaLong = 267;
PVC.alphaShear = 553;

% Steel SS316
steel.clong = 5790;
steel.cshear = 3220; 
steel.G = 79.2E9;
steel.rho = 7870; 
steel.alphaLong = 8;
steel.alphaShear = 8;

% water
water.clong = c_water(T);
water.rho = 1000;

% pipe geometry struct
geom.OD = 63E-3;
geom.t = 4.7E-3;
geom.ID = geom.OD - 2*geom.t;

% start calculating amplitudes
A_steel = zeros(length(theta0), 4);
A_PVC = A_steel;

for ii = 1:length(theta0)

    [LL,LS, SL, SS] = relative_amplitudes(geom, PEEK, steel, water, f, theta0(ii), contactType);
    A_steel(ii,1) = LL;
    A_steel(ii,2) = LS;
    A_steel(ii,3) = SL;
    A_steel(ii,4) = SS;

    [LL,LS, SL, SS] = relative_amplitudes(geom, PEEK, PVC, water, f, theta0(ii), contactType);
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
plot(theta0, A_PVC*100);
ylabel(t, "Relative Amplitude /%", 'FontName', 'Times', 'FontSize', 14);
legend('LL', 'LS', 'SL', 'SS', 'Location', 'west');
set(gca, 'Xticklabel', []); % turn off tick labels for top plot
set(gca, 'FontName', 'Times');
set(gca, 'FontSize', 12);
ylim([-5, 70]); % shift up slightly so you can see all lines
xlim([theta0(1), theta0(end)]);

nexttile;
plot(theta0, A_steel*100);
set(gca, 'FontName', 'Times');
set(gca, 'FontSize', 12);
xlabel("Wedge Angle /^\circ");
%legend('LL', 'LS', 'SL', 'SS');
xlim([theta0(1), theta0(end)]);
maxA = 100*max(A_steel(~isinf(A_steel)), [],'all');
set(gca, 'YTick', round([0,0.5,1]*maxA, 2, 'significant'));
%ylim([-0.002, 0.02]);