function dist = featureDistPTD(varargin)

t1_feature = varargin{1};
t2_feature = varargin{2};
[h, b1] = size(t1_feature);
b1 = b1 / 2;
[w, b2] = size(t2_feature);
b2 = b2 / 2;

algo = 1;
if nargin == 3
    algo = varargin{3};
end


dist = zeros(h,w);
for i = 1:h
    for j = 1:w
        v1_g = t1_feature(i, 1:b1);
        v1_c = t1_feature(i, b1+1:2*b1);
        v2_g = t2_feature(j, 1:b2);
        v2_c = t2_feature(j, b2+1:2*b2);

        if algo == 1
            dist(i, j) = 1 - 2 * mean(min(v1_g, v2_g) ./ (v1_g + v2_g + eps));
            
%             dist(i, j) = norm(v1_g - v2_g, 2) ./ (max([v1_g(:); v2_g(:)]) + eps) / b1;
%             dist2 = 1 - 2 * mean(min(v1_g, v2_g) ./ (v1_g + v2_g + eps));
%             dist(i, j) = 2 * (dist1 * dist2) ./ (dist1 + dist2);
        else
            dist1 = norm(v1_g - v2_g, 2) ./ (max([v1_g(:); v2_g(:)]) + eps) / b1;
            dist2 = 1 - 2 * mean(min(v1_g, v2_g) ./ (v1_g + v2_g + eps));
            dist(i, j) = 2 * (dist1 * dist2) ./ (dist1 + dist2);
        end
    end
end


end