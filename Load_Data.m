classdef Load_Data %< Run_Categorisation
    %   LOAD_DATA This class contains the functions to load the data into the
    %   app, whether it is in CTR or CSV format

    properties
          DATA  % Holds the data which is loaded 
          fileType  % Holds the types of file to be used (in this case CSV or CTR)
          path  % Holds the path to the files in question on your device
          numsamples
    end

    methods (Static)
        function obj = Find_Path(fileType)
            %   Opens a dialogue box which can be used to navigate to and select the folder with the data
            %   fileType should be '/*ctr' or '/*csv' depending on the type of file to be used
            %   path outputs the location of the folder on your computer
            obj.fileType = fileType;
            obj.path = [uigetdir('Select the folder containing the contour files') obj.fileType]; %uigetdir() opens the navigator box and asks users to choose the folder 
        end

        function obj = Data_Loader(fileType, path)
            %This function simplifies the use of this class since it
            %combines the ARTwarp_Load_CSV_Data and ARTwarp_Load_CTR_Data
            %into one function, with the output dependent on the fileType
            if fileType == '/*ctr' %#ok<*BDSCA> (this comment just tells MATLAB that this line of code is okay)
                data = Load_Datatype.ARTwarp_Load_CTR_Data(path);
                obj.DATA = data.data;
                obj.numsamples = data.numSamples;
            elseif fileType == '/*csv'
                data = Load_Datatype.ARTwarp_Load_CSV_Data(path);
                obj.DATA = data.data;
                obj.numsamples = data.numSamples;
            end
        end
    end
end