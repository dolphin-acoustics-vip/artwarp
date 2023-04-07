folder_name = uigetdir('C:\Projects\Valencia\results\ctr\ctr_subset_results','Select folder to save reference contours in');
if (~folder_name); return; end;
cd (folder_name);

% workspace MUST contain the NET variable for this to work
contours=NET.weight;
[~,numContours]=size(contours);
for i=1:numContours
    outputFile = [folder_name '//refContour_' num2str(i) '.csv'];
    fileID = fopen(outputFile,'w');
    oneContour=contours(:,i);
    oneContour(isnan(oneContour))=[];
    fprintf(fileID,'%7.1f\n',oneContour);
    fclose(fileID);
end