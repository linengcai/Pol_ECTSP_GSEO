function [upperW, lowerW] = GausGamma_Window_PolSAR(sab, lf, df, p, direction, wType)

% x = im;
sigx = sab(1);
sigy = sab(1);
alpha = sab(2);
beta = sab(3);


N = direction;  % number of directions
cta = 0:pi/N:pi-pi/N;

w = lf;
upperW = zeros(2*w+1, 2*w+1);
lowerW = upperW;
%     sigma = 3;
%     rou = 3;
theta = cta(p);
for x = -w:w
    for y = -w:w
        rx = [cos(theta) sin(theta)]*[x; y];
        ry = [-sin(theta) cos(theta)]*[x; y];
        if wType == 1
        % 高斯gamma窗
            weight = abs(rx)^(alpha-1) * exp(-abs(rx) / beta) * 1 / sigx * exp(-(ry)^2 / (2*sigx^2));
        else
        % 传统高斯窗，在中间那条缝不为0
            weight = 1/(sigx*sigy)*exp(-(rx)^2/(2*sigx^2))*exp(-(ry)^2/(2*sigy^2));
        end
        
        if rx > 0.5 + df % && sqrt(rx^2 + ry^2) <= lf+df+eps
            upperW(x+w+1, y+w+1) = weight;
        end
        if rx < -0.5 - df % && sqrt(rx^2 + ry^2) <= lf+df+eps
            lowerW(x+w+1, y+w+1) = weight;
        end
    end
end


upperW = upperW/sum(sum(upperW));
lowerW = lowerW/sum(sum(lowerW));
