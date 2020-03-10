
% Filtro pasa banda.

function [ X_filter ] = bandPassFilter(X, f, omegaLess, omegaHigher)
    H = ((f < -omegaLess) | (f > omegaLess)) & ((f > -omegaHigher) & (f < omegaHigher));
    X_filter = X .* H;
end