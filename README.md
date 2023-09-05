# PVC-Amplitudes

## Overview

The MATLAB code in this repository accompanies an article [insert link]. The primary purpose is to enable the calculation of relative amplitudes of different ultrasonic paths in a clamp-on flowmeter, and 
calculate the error introduced by setting the transducers for the wrong path.

It is comprised of the following files:
1. solid_solid_boundary.m
2. solid_liquid_boundary.m
3. liquid_solid_boundary.m
4. attenuate.m
5. relative_amplitudes.m
6. PVC_amplitudes.m
7. ErrorCalculation.m
9. c_water.m
10. c_PEEK.m
11. c_PEEK_shear.m

Files 1 to 3 calculate the amplitudes of longitudinal and shear waves that are reflected and refracted when a longitudinal or shear wave ***of amplitude 1*** is incident on a material interface at an oblique angle. 

File 4 calculates the amplitude of a wave after attenuation in a medium over a given distance.

File 5 combines files 1 to 4 to calculate the relative amplitudes of the different paths through a clamp-on ultrasonic flowmeter. The paths considered all have longitudinal waves in both transducers, 
but are allowed to be longitudinal or shear in both transits through the pipe walls, so there are four paths considered in total, listed below:
1. Longitudinal in both wall transits.
2. Longitudinal in the first wall transit, but shear in the other.
3. Shear in the first wall transit, but longitudinal in the other.
4. Shear in both wall transits.
Effects of material attenuation in the wall transits are accounted for.

File 6 uses file 5 to calculate the relative amplitudes of the four ultrasonic paths for a range of transducer wedge angles for two different pipes - one PVC and one steel for comparison.

File 7 computes the error introduced to a flow measurement by setting the transducers for path 4 on a PVC pipe, in which the longitudinal wave dominates in both walls.

Files 9 to 11 take the temperature in degrees C and return the speeds of sound in PEEK and water based on experimental data.

The mathematics and physics involved are documented in the corresponding article, so will not be covered here.

## Individual File Documentation

**All inputs to functions should be SI units unless otherwise specified, and all angles are in degrees.**

### solid_solid_boundary.m

`[A, theta] = solid_solid_boundary(m1, m2, theta0, f, inType)`

Calculates the amplitudes and angles of the reflected and refracted longitudinal and shear waves for a material interface where both media are solids.

**Inputs**
- m1, m2 are structs representing the two materials. They must contain the following fields:
   - clong: The longitudinal wave speed of sound.
   - cshear: The shear wave speed of sound.
   - rho: The mass density.
   - G: The shear modulus.
- theta0 is the angle of incidence measured with respect to the interface normal.
- f is the frequency of the wave.
- inType is a string which indicates whether the incident wave is longitudinal ("long") or shear ("shear").

**Outputs**
- A is a vector of amplitudes, A = [Reflected longitudinal, Reflected shear, Refracted longitudinal, Refracted shear].
- theta is a vector of angles of outgoing waves, in the same order as A.

### solid_liquid_boundary.m

`[A, theta] = solid_liquid_boundary(m1, m2, theta0, f, inType)`

Calculates the amplitudes and angles of the reflected longitudinal and shear waves, and refracted longitudinal wave at a material interface when the incidence medium is solid and the refraction medium is a liquid.

The inputs and outputs to this function are the same as for solid_solid_boundary, only any shear quantities relating to the liquid are omitted.

### liquid_solid_boundary.m

`[A, theta] = liquid_solid_boundary(m1, m2, theta0, f)`

Calculates the amplitudes of reflected longitudinal and refracted longitudinal and shear waves at a material interface when the incidence medium is a liquid and the refraction medium is a solid.

The inputs and outputs to this function are the same as for solid_solid_boundary, only any shear quantities relating to the liquid are omitted and only longitudinal incident waves are possible.

### attenuate.m

`A2 = attenuate(A1, alpha, d)`

Calculates the amplitude of a wave after having travelled some distance through an attenuating medium.

**Inputs**
- A1 is the amplitude of the wave when it first enters the medium after any boundary effects have been accounted for.
- alpha is the attenuation coefficient of the medium in dB/m
- d is the distance travelled in the attenuating medium.

**Outputs**
- A2 is the amplitude of the wave after attenuation.

### relative_amplitudes.m

`[LL, LS, SL, SS] = relative_amplitudes(geom, transducer, pipe, fluid, f, theta0)`

Uses the above functions to calculate the relative amplitudes of the four different paths through a clamp-on ultrasonic flowmeter. It assumes that the amplitude of the wave in the wedge of the driven transducer is 1.

**Inputs**
- geom is a struct representing the geometry of the pipe, with a single field:
   - t: The pipe wall thickness
- transducer is a struct representing the wedge material of the transducer. It must have the following fields:
   - clong: The longitudinal wave speed of sound.
   - cshear: The shear wave speed of sound.
   - rho: The mass density.
   - G: The shear modulus.
- pipe is a struct representing the pipe material with the same fields as transducer.
- fluid is a struct representing the fluid inside the pipe, with the following fields:
   - clong: The longitudinal speed of sound.
   - rho: The mass density.
- f is the frequency of ultrasound used.
- theta0 is the transducer wedge angle, measured between the active element and the pipe surface.

**Outputs**
The outputs are the relative amplitudes in the reception wedge of the 4 paths listed above, in that order.

### PVC_amplitudes.m

This file contains a script that produces one of the figures in the paper. It uses `relative_amplitudes` to calculate the amplitudes of the four paths through an example flow meter for steel and PVC pipes.

### ErrorCalculation.m

A script that calculates the error introduced by setting the transducers in the right location for the shear-shear path when the longitudinal-longitudinal path is detected. It follows the mathematics in the paper with reference to the equations there.

### c_water.m

`c = c_water(T)`

Calculates the longitudinal speed of sound c in water at a given temperature, T, from a quadratic fit of experimental data. For reference please see the article.

### c_PEEK.m

`c = c_PEEK(T)`

Calculates the longitudinal speed of sound, c, in polyether-ether ketone (PEEK) at temperature T. Calculated using a fit of experimental data obtained by the authors.

### c_PEEK_shear.m

`c = c_PEEK_shear(T)`

Calculates the shear speed of sound, c, in polyether-ether ketone (PEEK) at temperature T. Calculated using a fit of experimental data obtained by the authors.
