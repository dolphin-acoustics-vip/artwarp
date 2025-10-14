function X = warp(u1, u2)

% From ARTwarp_Activate_Categories call of 'warp' function, u1 = the reference contour
% ('weight(i,j)') and u2 = the active contour that's being compared ('input' or
% 'DATA(c1).contour')

% This algorithm determines a warping function to minimize the sum square difference of two frequency contours. 
% The algorithm is similar to that of Itakura (1975). The maximum number of consecutive horizontal steps (2 in 
% Itakura 1975) is 'warpFactorLevel' in this version (determined by variable 'warpFactorLevel' the statement 
% 'if k(i-1,j)+1 >= warpFactorLevel'). The function also allows vertical jumps of 'warpFactorLevel' rather than 2. The function
% yields an array that contains the normalised cumulative similarity score between the original and the warped contour in cell {1,1},
% as well as the warping function in cell {1,2}

global warpFactorLevel; % maximum number of allowed consecutive vertical steps, or the warp factor level

%TEST FOR DIFFERENCES IN LENGTH GREATER THAN WARPFACTORLEVEL
m = length(u1); %the number of data points in the reference contour
n = length(u2); %the number of data points in the comparison contour
if max([m n])/(min([m n])-1) >= warpFactorLevel
    %disp('The length of the two contours differs by more than a factor of warpFactorLevel');
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
N = NaN*zeros(m, n); %CUMULATIVE SIMILARITY MATRIX: create a 2nd matrix of the same size but filled with NaN
r1 = [0 1 0]; %a 1x3 matrix with values of 0, 1, and 0
r2 = 0:-1:-warpFactorLevel ; %a 1x(warpFactorLevel + 1) matrix with values of 0 to -warpFactorLevel, stores possible steps in j-direction
p = zeros(m, n); %PATH MATRIX - another reference x active contour datapoints matrix, filled with zeros
k = ones(m, n); %LOCAL EXPANSION FACTOR MATRIX - another reference x active contour datapoints matrix, filled with ones to indicate no initial expansion

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
for i = 2:min([(warpFactorLevel*(warpFactorLevel + 1) - 1) m]) % For the indexes in u1 where if maximum local compression was applied, the warping path would break the Itakura constraint: 
    for z = 1:warpFactorLevel % For some increment variable z from 1 to warpFactorLevel:
        
        if round(i/warpFactorLevel) <=z %if the active datapoint of the reference contour divided by warpFactorLevel is <= z....
        j = z; %index of active contour is z

        if z == 1
            condition = (k(i-1,j) > warpFactorLevel);
        else
            condition = (k(i-1,j) >= warpFactorLevel);
        end
        if condition
            [y, x] = max([N(i-1,j+(r2(2:z))) NaN]); %AND the value stored at i-1,j is greater than warpFactorLevel, disqualify the vertical step (i.e choose only a diagonal or horizontal step)
            p(i,j) = r2(x+1); % Update the path matrix to show the horizontal component of the step taken (i.e. -1, -2, ..., -warpFactorLevel)
            k(i,j) = 1; % Reset the number of consecutive vertical steps to 1
        else
            [y, x] = max(N(i-1,j+(r2(1:z)))); %otherwise, choose the maximum previous value from any previous possible step (including the vertical)
            if x == 1 % CHECK THIS IS CORRECT INDEXING OF above line - if the maximum previous value came from a vertical step:
                k(i,j) = 1+k(i-1,j); % increment the number of consecutive vertical steps taken at k(i,j) from k(i-1,j)
            else
                k(i,j) = 1; % Otherwise, reset the number of consecutive vertical steps to 1
            end
            p(i,j) = r2(x); % Update the path matrix to show the horizontal component of the step taken (i.e. 0, -1, ..., -warpFactorLevel)
        end
        N(i,j) = M(i,j)+y; %now adjust the value of N(i,j) to equal M(i,j) + nothing or + k(i-1,j)
        end
    end

    for j = (warpFactorLevel + 1):min([warpFactorLevel*i round((i-m)/warpFactorLevel+n)])
        if k(i-1,j) >= warpFactorLevel
            [y, x] = max([N(i-1,j+(r2(2:warpFactorLevel+1))) NaN]); 
            p(i,j) = r2(x+1);
            k(i,j) = 1;
        else
            [y, x] = max(N(i-1,j+r2));
            if x == 1 % CHECK THIS IS CORRECT INDEXING OF above line - if the maximum previous value came from a vertical step:
                k(i,j) = 1+k(i-1,j); % increment the number of consecutive vertical steps taken at k(i,j) from k(i-1,j)
            else
                k(i,j) = 1; % Otherwise, reset the number of consecutive vertical steps to 1
            end
            p(i,j) = r2(x); % Update the path matrix to show the horizontal component of the step taken (i.e. 0, -1, ..., -warpFactorLevel)
        end
        N(i,j) = M(i,j)+y;
    end    
end
for i = warpFactorLevel*(warpFactorLevel+1):1:m
    for j = max([round(i/warpFactorLevel) (i-m)*warpFactorLevel+n]):min([warpFactorLevel*i round((i-m)/warpFactorLevel+n)])
        if k(i-1,j) >= warpFactorLevel
            [y, x] = max([N(i-1,j+(r2(2:warpFactorLevel+1))) NaN]); 
            p(i,j) = r2(x+1);
            k(i,j) = 1;
        else
            [y, x] = max(N(i-1,j+r2));
            if x == 1 % CHECK THIS IS CORRECT INDEXING OF above line - if the maximum previous value came from a vertical step:
                k(i,j) = 1+k(i-1,j); % increment the number of consecutive vertical steps taken at k(i,j) from k(i-1,j)
            else
                k(i,j) = 1; % Otherwise, reset the number of consecutive vertical steps to 1
            end
            p(i,j) = r2(x); % Update the path matrix to show the horizontal component of the step taken (i.e. 0, -1, ..., -warpFactorLevel)
        end
        N(i,j) = M(i,j)+y;
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