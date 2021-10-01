%
clear all

% query the user for the spreadsheet, and load the data
[datasetFilename, datasetPath, fileSelected] = uigetfile('*.xlsx', 'Select Data File to analyse','C:\Projects\MarieCurie\Shared Whistle types\Analysis');
if (~fileSelected); return; end;
cd (datasetPath);
[~,~,rawData]=xlsread(datasetFilename);
[numRows, numCols] = size(rawData);

% ask user which column the category is in (catCol)
% tempVar = input('Enter the training column containing the species name (number or letter): ','s');
% [catCol status] = str2num(tempVar);
% if (~status || strcmp(tempVar,'i'))
%     catCol = ExcelCol(tempVar);
% end
catCol = 2; % the category is always in column 2

% get the species name
spName = input('Please enter the name of the species: ','s');

% main loop
storedCategories(1) = rawData{2,catCol};
rawData{1,numCols+1} = 'Number of Categories';
rawData{2,numCols+1} = 1;

for i=3:numRows %skip header row and first row (since that will be the first category)
   curCategory = rawData{i,catCol}; 
    
   % loop through the storedCategories and see if this one is already in it
   found = false;
   for j=1:length(storedCategories)
       if (curCategory == storedCategories(j))
           found = true;
           break;
       end
   end
   if (found)
       rawData{i,numCols+1} = rawData{i-1,numCols+1};
   else
       storedCategories(length(storedCategories)+1)=curCategory;
       rawData{i,numCols+1} = rawData{i-1,numCols+1}+1;
   end
end

% save the matrix to a new file
fileOut = datasetFilename(1:length(datasetFilename)-5);
fileOut = [fileOut '-output.xlsx'];
xlswrite(fileOut, rawData);
   
% plot the data
yVals = cell2mat(rawData(2:end,numCols+1));
xVals = 1:length(yVals);
plot(xVals,yVals);
title(spName);
xlabel('Number of Whistles');
ylabel('Number of Categories');



   