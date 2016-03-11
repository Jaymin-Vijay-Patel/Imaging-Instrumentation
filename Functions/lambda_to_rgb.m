function rgb = lambda_to_rgb(wavelength, gamma=0.8):

    %This converts a given wavelength of light to an 
    % approximate RGB color value. The wavelength must be given
    % in nanometers in the range from 380 nm through 750 nm

    %Borrowed from http://www.noah.org/wiki/Wavelength_to_RGB_in_Python
    %Based on code by Dan Bruton
    % http://www.physics.sfasu.edu/astro/color/spectra.html

    if wavelength >= 380 && wavelength <= 440
        attenuation = 0.3 + 0.7 * (wavelength - 380) / (440 - 380)
        R = ((-(wavelength - 440) / (440 - 380)) * attenuation) ^ gamma
        G = 0.0
        B = (1.0 * attenuation) ^ gamma
    elseif wavelength >= 440 && wavelength <= 490
        R = 0.0
        G = ((wavelength - 440) / (490 - 440)) ^ gamma
        B = 1.0
    elseif wavelength >= 490 && wavelength <= 510
        R = 0.0
        G = 1.0
        B = (-(wavelength - 510) / (510 - 490)) ^ gamma
    elseif wavelength >= 510 && wavelength <= 580
        R = ((wavelength - 510) / (580 - 510)) ^ gamma
        G = 1.0
        B = 0.0
    elseif wavelength >= 580 && wavelength <= 645
        R = 1.0
        G = (-(wavelength - 645) / (645 - 580)) ^ gamma
        B = 0.0
    elseif wavelength >= 645 && wavelength <= 750
        attenuation = 0.3 + 0.7 * (750 - wavelength) / (750 - 645)
        R = attenuation ^ gamma
        G = 0.0
        B = 0.0
    else
        R = 0.0
        G = 0.0
        B = 0.0
    end

    rgb = [R G B];

