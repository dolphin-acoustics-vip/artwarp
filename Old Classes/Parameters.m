classdef Parameters
    %PARAMETERS This class loads the parameters to run the ARTwarp
    %classification (warp factor, vigilance level, etc...). Detailed
    %descriptions of each parameter can be found below.

    properties
        bias {mustBeNumeric} = 1.0000e-06
        learningRate {mustBeNumeric} = 0.1000            
        maxNumCategories {mustBeNumeric} = 56               
        maxNumIterations {mustBeNumeric} = 100
        resample {mustBeNumeric} = 0
        sampleInterval {mustBeNumeric} = 0.0100
        vigilance {mustBeNumeric} = 90
        warpFactor {mustBeNumeric} = 3
    end

    methods
        function obj = AssignParameters(inputParameters)
                    obj.bias = inputParameters.bias;
                    obj.learningRate = inputParameters.learningRate;
                    obj.maxNumCategories = inputParameters.maxNumCategories;
                    obj.maxNumIterations = inputParameters.maxNumIterations;
                    obj.resample = inputParameters.resample;
                    obj.sampleInterval = inputParameters.sampleInterval;
                    obj.vigilance = inputParameters.vigilance;
                    obj.warpFactor = inputParameters.warpFactor;
        end
    end
end