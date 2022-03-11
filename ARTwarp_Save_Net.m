function ARTwarp_Save_Net

global NET DATA

disp(NET);

disp(DATA);

save('ARTwarp_Results.mat', 'NET', 'DATA');

end