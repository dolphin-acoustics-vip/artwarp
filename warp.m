function X = warp(u1, u2)

% From ARTwarp_Activate_Categories call of 'warp' function, u1 = the reference contour
% ('weight(i,j)') and u2 = the active contour that's being compared ('input' or
% 'DATA(c1).contour')

% This algorithm determines a warping function to minimize the sum square difference of two frequency contours. 
% The algorithm is similar to that of Itakura (1975). The maximum number of consecutive horizontal steps (2 in 
% Itakura 1975) is 'warpFactorLevel' in this version (determined by variable 'warpFactorLevel' the statement 
% 'if k(i-1,j)+1 >= warpFactorLevel'). The function also allows vertical jumps of 3 rather than 2. The function
% yields an array that contains the sum square difference of the original and the warped contour in cell {1,1},
% as well as the warping function in cell {1,2}

global warpFactorLevel; % maximum number of allowed consecutive horizontal steps, or the warp factor level

%TEST FOR DIFFERENCES IN LENGTH GREATER THAN THREE
m = length(u1); %the number of data points in the reference contour
n = length(u2); %the number of data points in the comparison contour
if max([m n])/(min([m n])-1) >= 3
    %disp('The length of the two contours differs by more than a factor of 3');
    X = {0, []}; return; 
end


%DEFINE MATRICES
% 6 matrices total: 
    %4 of size reference-contour-datapoints x active-contour-datapoints
        %2 filled with zeros (M and p)
        %1 filled with NaNs (N)
        %1 filled with ones (k)
    %1x3 with headers 0, 1, 0 (r1)
    %1x4 with headers -1, -, -2, -3 (r2)
M = zeros(m, n); %SIMILARITY MATRIX: create a matrix of zeros of length of reference contour (rows) x length of comparison contour (columns)
N = NaN*zeros(m, n); %COST MATRIX: create a 2nd matrix of the same size but filled with NaN
r1 = [0 1 0]; %a 1x3 matrix with values of 0, 1, and 0
r2 = [-1 0 -2 -3]; %a 1x4 matrix with values of -1, 0, -2, and -3
p = zeros(m, n); %another reference x active contour datapoints matrix, filled with zeros
k = ones(m, n); %another reference x active contour datapoints matrix, filled with ones

% -- fill in what these matrices are used for once it becomes apparent --




%CALCULATE SIMILARITY MATRIX M
% moving through reference and active contours one point at a time, calculate (smaller
% value/larger value)*100 to place a similarity score of each point in the
% diagonals of matrix M. 
parfor i = 1:m
    e1 = u1(i);
    for j = 1:n
        e2 = u2(j);
        M(i,j) = min(e1,e2)/max(e1,e2)*100;        
    end
end

%CALCULATE COST MATRIX N
N(1,1) = M(1,1); %set the value of N at 1,1 to be the same as M at 1,1
k(1,1) = 1; %set the value of k at 1,1 to be 1 (which it already was?)
% for reference contour points from 2 (not 1!) through the smaller of 11 or
% the length of the contour...
for i = 2:min([11 m])
    if round(i/3) <=1; %if the active datapoint of the reference contour divided by 3 is <= 1....
        j = 1; %index of active contour is 1
        if k(i-1,j) > warpFactorLevel
            y = NaN; %AND the value stored at i-1,j is greater than 3, temporary variable 'y' is NaN
        else
            y = N(i-1,j); %otherwise, 'y' is the value stored in matrix N at i-1,j
        end
        k(i,j) = 1+k(i-1,j); %now adjust the value of k(i,j) to equal 1+ the value from line 58 (k(i-1,j)
        N(i,j) = M(i,j)+y; %now adjust the value of N(i,j) to equal M(i,j) + nothing or + k(i-1,j)
        p(i,j) = 0; %now adjust p(i,j) to zero (which it already was?)
    end
    if round(i/3) <=2; %if the active datapoint of the reference contour divided by 3 is less than 2...
        j = 2; %index of active contour is 2
        if k(i-1,j) >= warpFactorLevel
            y = N(i-1,j-1); %AND the value stored at i-1,j is greater than 3, temporary variable 'y' is the value stored in N at i-1,j-1
            x = 1; %and temporary variable 'x' is 1
        else
            [y x] = max([N(i-1,j-1) N(i-1,j)]); %otherwise, the value of 'y' the maximum of N(i-1,j-1) OR N(i-1,j) and the value of 'x' is which of those two expressions is the largest (1 or 2)
        end
        ks = [1 1+k(i-1,j)]; %create 1x2 matrix with values of 1 and (1+the value of k(i-1,j)) to be used in a downstream comparison
        k(i,j) = ks(x); %now adjust the value of k(i,j) to equal either the 1st or 2nd term of ks as indicated by whether 'x' equals 1 or 2
        N(i,j) = M(i,j)+y; %now adjust the value of N(i,j) to equal M(i,j)+'y', which is either N(i-1,j-1) or N(i-1,j) depending on whether k(i-1,j) >3 and which is larger
        p(i,j) = r2(x); %now adjust the value of p(i,j) to equal one of the 3 terms in r2; which term is determined by whether line 71 is true or false
    end %Lines 58-81 step through up to 11 rows and 3 corresponding columns (j=1, 2, and 3) to set values in matrices N, p, and k
    if round(i/3) <=3; %if the active datapoint of the reference contour divided by 3 is less than 3...
        j = 3; %index of active contour is 3
        if k(i-1,j) >= warpFactorLevel
            [y x] = max([N(i-1,j-1) NaN N(i-1, j-2)]); %AND value stored at k(i-1,j) > 3, the value of 'y' is the max of N(i-1, j-1 OR j-2) or NaN and 'x' is which of the 3 terms is the max
        else
            [y x] = max([N(i-1,j-1) N(i-1,j) N(i-1, j-2)]); %otherwise, the value of 'y' is the max of i-1, j OR j-1 OR j-2 and 'x' is which location is max
        end
        ks = [1 1+k(i-1,j) 1]; %now adjust ks to 1x3 matrix to be 1, 1+k(i-1,j), or 1
        k(i,j) = ks(x); %now adjust k(i,j) to be the 'x'th value stored in matrix 'ks'
        N(i,j) = M(i,j)+y; %now adjust the value of N(i,j) to be M(i,j)+y
        p(i,j) = r2(x); %now adjust p(i,j) to equal one of the 3 terms in r2 (dependent on whether k(i-1,j) > 3 was true or false
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