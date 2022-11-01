newPrefix = 'sub7_';

folder_name = uigetdir('C:\Projects\Valencia\results\ctr\ctr_subset_results','Select folder containing files to rename');
if (~folder_name); return; end;
cd (folder_name);

% loop through the txt files in the folder
fileList = dir([folder_name '\\*.csv']);
for i=1:length(fileList)
    [status,msg,msgID] = movefile(fileList(i).name, [newPrefix fileList(i).name]);
    if (~status)
        disp(['Error renaming file ' fileList(i).name]);
    end
end

        
