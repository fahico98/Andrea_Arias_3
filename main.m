
clear all;
clc;

strSigMatrix = 's0010_rem';

sigMatrix = load(strcat(strSigMatrix, '.mat'));
sigMatrix = sigMatrix.val;

fprintf('***** BIENVENIDO *****\n\n');

fprintf('El siguieten programa le ofrece una serie de opciones a realiza en base a un grupo de\n');
fprintf('sañales electrocardiográficas obtenidas de https://physionet.org/content/ptbdb/1.0.0/\n');
fprintf('con fines educativos.\n');

while(true)
    in = input('\nDesea ver dicho grupo de señales ?\n   1. Si.\n   2. No.\n\n>>> ', 's');
    if(isnan(str2double(in)))
        fprintf("\nEl valor ingresado no es valido.\nPor favor intentelo de nuevo...!\n");
        continue;
    else
        opcion = str2double(in);
        break;
    end
end

if opcion == 1
    plotATM(strSigMatrix);
end

while(true)
    fprintf('\nOpciones del programa.\n\n');
    fprintf('   a) Filtrar una señal.\n');
    fprintf('   b) Comparar dos señales.\n');
    fprintf('   c) Investigar patologias de una señal.\n');
    fprintf('   d) Aplicar el metodo de las ventanas a una señal.\n\n');
    in = input('>>> ', 's');
    if in == 'a' || in == 'b' || in == 'c' || in == 'd' || in == 'A' || in == 'B' || in == 'C' || in == 'D'
        break;
    else
        fprintf("\nEl valor ingresado no es valido.\nPor favor intentelo de nuevo...!\n");
        continue;
    end
end

if in == 'a' || in == 'A'
    
    while(true)
        fprintf('\nLa señal que seleccione sera filtrada con un filtro pasa banda. Ingrese el indice de la\n');
        fprintf('señal que desea filtrar (entre 1 y 15).\n\n');
        in = input('>>> ', 's');
        if isnan(str2double(in))
            fprintf("\nEl valor ingresado no es valido.\nPor favor intentelo de nuevo...!\n");
            continue;
        else
            index = str2double(in);
            break;
        end
    end
    
    x = sigMatrix(index, :);
    
    Fs = 1000;
    t = linspace(0, 10, length(x));
    f = linspace(-Fs/2, Fs/2, length(x));
    
    X = fft(x);
    X_cent = fftshift(X);
    
    X_mag = abs(X_cent);
    X_phase = unwrap(angle(X_cent));
    
    subplot(3, 1, 1);
    plot(t, x, 'k');
    grid on;
    xlabel('Tiempo (s)'), ylabel('Voltaje (mV)');

    subplot(3, 1, 2);
    plot(f, X_mag, 'r');
    grid on;
    xlabel('Frecuencia (Hz)'), ylabel('Magnitud (dB)');

    subplot(3, 1, 3);
    plot(f, X_phase, 'b');
    grid on;
    xlabel('Frecuencia (Hz)'), ylabel('Fase (rad)');
    
    while(true)
        fprintf('\nIngrese la mínima frecuencia de corte para el filtro (en Hz).\n\n');
        in = input('>>> ', 's');
        if isnan(str2double(in))
            fprintf("\nEl valor ingresado no es valido.\nPor favor intentelo de nuevo...!\n");
            continue;
        else
            omegaLess = str2double(in);
            break;
        end
    end
    
    while(true)
        fprintf('\nIngrese la máxima frecuencia de corte para el filtro (en Hz).\n\n');
        in = input('>>> ', 's');
        if isnan(str2double(in))
            fprintf("\nEl valor ingresado no es valido.\nPor favor intentelo de nuevo...!\n");
            continue;
        else
            omegaHight = str2double(in);
            break;
        end
    end
    
    X_mag_filt = bandPassFilter(X_mag, f, omegaLess, omegaHight);
    X_phase_filt = bandPassFilter(X_phase, f, omegaLess, omegaHight);
    
    x_filt = real(ifft(X_mag_filt .* exp(1j * X_phase_filt)));
    
    subplot(3, 1, 1);
    plot(t, x_filt, 'k');
    grid on;
    xlabel('Tiempo (s)'), ylabel('Voltaje (mV)');

    subplot(3, 1, 2);
    plot(f, X_mag_filt, 'r');
    grid on;
    xlabel('Frecuencia (Hz)'), ylabel('Magnitud (dB)');

    subplot(3, 1, 3);
    plot(f, X_phase_filt, 'b');
    grid on;
    xlabel('Frecuencia (Hz)'), ylabel('Fase (rad)');
    
end






















