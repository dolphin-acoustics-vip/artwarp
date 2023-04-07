function ARTwarp_Assess_Net
[filename path] = uigetfile('*.mat');
eval (['cd ' path]);
eval(['load ' filename]);
spp = ['Locu'; 'Lole'; 'Lopy'; 'Losc']
error = 0;
for category = 1:NET.numCategories
    tally = [0 0 0 0];
    i = find([DATA.category] == category); 
    names = reshape([DATA(i).name], 21, length(i))';
    names = names(:, 1:4)
    for sp = 1:4
        i = find(names == spp(sp, 3));
        tally(sp)=length(i);
    end
    error = error + sum(tally)-max(tally);
end
disp(sprintf('Number of misclassifications for %s: %d  of %d', filename, error, length([DATA.category])));
    
