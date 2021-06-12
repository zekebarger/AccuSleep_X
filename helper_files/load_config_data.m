function [config] = load_config_data()
% load_config_info Load configuration data
% Zeke Barger 021321

%   This function loads configuration data and performs basic checks on it.
%   If there is an issue with the config data, the function returns
%   a string containing an error message. Otherwise, it returns a structure
%   called config with three fields:
%       cfg_names: a cell array of brain state names
%                  example: {'REM','Wake','NREM'}
%                  DO NOT INCLUDE AN 'UNDEFINED' STATE
%       cfg_colors: a cell array of colors corresponding to each state
%                   Each color is a 3-element array of RGB values
%                  example: {[0 0 1], [0 1 0], [1 0 0]}
%                  DO NOT USE WHITE OR BLACK ([1 1 1] or [0 0 0])
%       cfg_weights: a cell array of expected amounts of each state
%                    Matching this to the typical values in your data is
%                    best, but it DOES NOT need to be exact and these
%                    values MUST MATCH the values used when a network was
%                    trained. Should sum to 1.
%                  example: [.1, .35, .55]

% get path to this script
code_fname = mfilename('fullpath');
% get path to the config file
config_fname = [code_fname(1:end-29), 'AS_config.mat'];

% check if contents of AS_config.mat are present
if length(whos('-file',config_fname,'cfg_colors','cfg_names','cfg_weights')) < 3
    config = 'Config file is missing a variable';
    return
end

% load configuration file
config = load('AS_config.mat','cfg_colors','cfg_names','cfg_weights');

% make sure length is the same
if (length(config.cfg_colors) ~= length(config.cfg_names)) || ...
        (length(config.cfg_colors) ~= length(config.cfg_weights))
    config = 'All config variables must have the same length.';
    return
end

% make sure there are at least 2 states
if length(config.cfg_colors) < 3
    config = 'Config file must have at least 2 states';
    return 
end

% but not more than 8
if length(config.cfg_colors) > 8
    config = 'Config file must have fewer than 9 states';
    return 
end

% make sure every variable is a column, not a row
if ~iscolumn(config.cfg_colors)
    config.cfg_colors = config.cfg_colors';
end
if ~iscolumn(config.cfg_names)
    config.cfg_names = config.cfg_names';
end
if ~iscolumn(config.cfg_weights)
    config.cfg_weights = config.cfg_weights';
end

return