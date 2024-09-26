%% Matlab script to extract the relevant voxel time series of the fMRI data

%% Add SPM to the MATLAB path
addpath('C:\Users\Dendorfer\Documents\Matlab_GT\spm12');

%%
% Set the file path of the output CSV file
output_file_path = '/path/to/output.csv';

% Set the file extension for the input files
input_extension = '.nii';

% Get the file paths for the 4D NIfTI files
file_paths = dir(['/path/to/folder/*', input_extension]);
file_paths = {file_paths.name};

% Set up a counter for the rows in the output CSV file
row_counter = 1;

% Loop over each file path in the array
for i = 1:numel(file_paths)
    % Get the file path
    file_path = fullfile('/path/to/folder', file_paths{i});
    
    % Load the 4D NIfTI file
    V = spm_vol(file_path);
    Y = spm_read_vols(V);
    
    % Reshape the 4D data into a 2D matrix, where each row represents a voxel time series
    Y_reshape = reshape(Y, [], size(Y, 4));
    
    % Add the file path as the first column of the output matrix
    output_matrix = [repmat({file_path}, size(Y_reshape, 1), 1) num2cell(Y_reshape)];
    
    % Write the output matrix to the output CSV file
    cell2csv(output_file_path, output_matrix, ',', row_counter);
    
    % Increment the row counter
    row_counter = row_counter + size(output_matrix, 1);
end
