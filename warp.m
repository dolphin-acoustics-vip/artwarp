function X = warp(u1, u2)

% This algorithm determines a warping function to minimize the sum square difference of two frequency contours. 
% The algorithm is similar to that of Itakura (1975). The maximum number of consecutive horizontal steps (2 in 
% Itakura 1975) is 'warpFactorLevel' in this version (determined by variable 'warpFactorLevel' the statement 
% 'if k(i-1,j)+1 >= warpFactorLevel'). The function also allows vertical jumps of 3 rather than 2. The function
% yields an array that contains the sum square difference of the original and the warped contour in cell {1,1},
% as well as the warping function in cell {1,2}

global warpFactorLevel; % maximum number of allowed consecutive horizontal steps, or the warp factor level

%TEST FOR DIFFERENCES IN LENGTH GREATER THAN THREE
m = length(u1);
n = length(u2);
if max([m n])/(min([m n])-1) >= 3
    %disp('The length of the two contours differs by more than a factor of 3');
    X = {0, []}; return;
end


%DEFINE MATRICES
M = zeros(m, n);
N = NaN*zeros(m, n);
r1 = [0 1 0];
r2 = [-1 0 -2 -3];
p = zeros(m, n);
k = ones(m, n);




%CALCULATE SIMILARITY MATRIX M
parfor i = 1:m
    e1 = u1(i);
    for j = 1:n
        e2 = u2(j);
        M(i,j) = min(e1,e2)/max(e1,e2)*100;        
    end
end

%CALCULATE COST MATRIX N
N(1,1) = M(1,1);
k(1,1) = 1;
for i = 2:min([11 m])
    if round(i/3) <=1;
        j = 1;
        if k(i-1,j) > warpFactorLevel
            y = NaN;
        else
            y = N(i-1,j);
        end
        k(i,j) = 1+k(i-1,j);
        N(i,j) = M(i,j)+y;
        p(i,j) = 0;
    end
    if round(i/3) <=2;
        j = 2;
        if k(i-1,j) >= warpFactorLevel
            y = N(i-1,j-1);
            x = 1;
        else
            [y x] = max([N(i-1,j-1) N(i-1,j)]);
        end
        ks = [1 1+k(i-1,j)];
        k(i,j) = ks(x);
        N(i,j) = M(i,j)+y;
        p(i,j) = r2(x);
    end
    if round(i/3) <=3;
        j = 3;
        if k(i-1,j) >= warpFactorLevel
            [y x] = max([N(i-1,j-1) NaN N(i-1, j-2)]);
        else
            [y x] = max([N(i-1,j-1) N(i-1,j) N(i-1, j-2)]);
        end
        ks = [1 1+k(i-1,j) 1];
        k(i,j) = ks(x);
        N(i,j) = M(i,j)+y;
        p(i,j) = r2(x);
    end
    for j = 4:min([3*i round((i-m)/3+n)])
        if k(i-1,j) >= warpFactorLevel
            [y x] = max([N(i-1,j-1) NaN N(i-1, j-2) N(i-1, j-3)]);
        else
            [y x] = max([N(i-1,j-1) N(i-1,j) N(i-1, j-2) N(i-1, j-3)]);
        end
        ks = [1 1+k(i-1,j) 1 1];
        k(i,j) = ks(x);
        N(i,j) = M(i,j)+y;
        p(i,j) = r2(x);
    end    
end
for i = 12:1:m
    for j = max([round(i/3) (i-m)*3+n]):min([3*i round((i-m)/3+n)])
        if k(i-1,j) >= warpFactorLevel
            y = max(max(N(i-1,j-1), NaN), max(N(i-1, j-2), N(i-1, j-3)));
            ks = 1;
            if y == N(i-1,j-1)
                x = 1;
            elseif isnan(y)
                x = 2;
                ks = 1 + k(i-1,j);
            elseif y == N(i-1, j - 2)
                x = 3;
            elseif y == N(i-1, j -3)
                x = 4;
            end
        else
            y = max(max(N(i-1,j-1), N(i-1,j)), max(N(i-1, j-2), N(i-1, j-3)));
            ks = 1;
            if y == N(i-1,j-1)
                x = 1;
            elseif y == N(i-1,j)
                x = 2;
                ks = 1 + k(i-1,j);
            elseif y == N(i-1, j - 2)
                x = 3;
            elseif y == N(i-1, j -3)
                x = 4;
            end
        end
        % Avoiding repetitive array creation ( ks = [1 1+k(i-1,j) 1 1]; ) while computing k(i,j)
        k(i,j) = ks;
        N(i,j) = M(i,j)+y;
        p(i,j) = r2(x);
    end
end

% RETRACE PATH TO GET WARPING FUNCTION
j = n;    
for i = m:-1:1
    warpfun(i)=j;
    dj = p(i,j);
    j = j+dj;
end
% PLOT OUTPUT
% plot(u1, 'b');
% hold on
% plot(u2, 'g');
% plot(u2(warpfun), 'r');
drawnow
D = N(m, n)/length(warpfun);
X = {D, warpfun};
clear N M p;