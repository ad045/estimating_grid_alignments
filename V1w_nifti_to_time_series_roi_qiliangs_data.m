%% Working nii to csv extractor with MULTIPLE TIME SERIES FOR MULTIPLE VOXEL! 
% This code can produce a csv file with all time series from the different voxels 
% in the ROI. This is a convenient method to store the relevant information and 
% not anything more than that. 

%% Stuff that has changed: This code ...
% ... is now adapted for Qilang's fmri data. 
% ... is now useable as function to quickly work through big data
% collections (needed for deep learning) 

%% CHANGE THESE PARAMETERS
run_number = '3_test'; 
input_file_folder = 'E:\Grid_cell_research\Qilang_s_data_fmri\Participant_5\'; %folder needs to have name "\run1_test". 
output_file_folder = 'E:\Grid_cell_research_working_folder\Quilang_participant_5\';

%% Add SPM to the MATLAB path
addpath('C:\Users\Dendorfer\Documents\Matlab_GT\spm12')


%% Itterate through all runs and generate the time series files for them: 
% Get all run_numbers: 
subfolders = dir('E:\Grid_cell_research\Qilang_s_data_fmri\Participant_5');

% Initialize an empty cell array to store the valid subfolder names
validSubfolders = {};

% Loop through each item in the 'subfolders' struct
for i = 1:length(subfolders)
    name = subfolders(i).name;
    
    % Check if it's a directory and starts with "run" and not with "run_"
    % (this excludes a few folders ("run_BA" and "run_OF") where I am
    % unsure about the use)
    if subfolders(i).isdir && strncmp(name, 'run', 3) && ~strncmp(name, 'run_', 4)
        validSubfolders{end+1} = name;
    end
end

% Display the list of valid subfolder names
% disp('Valid subfolders:');
% disp(validSubfolders);

for i = 1:length(validSubfolders)
    run_number = validSubfolders{i};
    disp(run_number)
    output_file_path = append(output_file_folder,'time_series_',run_number,'_ROI.csv'); %'voxel_45_32_24.csv'); 
    disp(output_file_path)
    disp(input_file_folder)
    % Call the function
    extract_time_series_of_roi_from_nifti_files(run_number, input_file_folder, output_file_path);
    
    disp(['Processed ' run_number]);
end



%%%%%%% DEFINED FUNCTIONS %%%%%%%%

%% Defined function: The heart of this script
function extract_time_series_of_roi_from_nifti_files (run_number, input_file_folder, output_file_path)
    %% Get all .nii files
    % Set the file extension for the input files
    input_extension = '.nii';
    
    % Get the file paths for the 4D NIfTI files
    % previously: 
    % file_paths = dir([append(input_file_folder,run_number,'\s8*'), input_extension]);
    %file_paths = dir([append(input_file_folder,run_number,'s*'), input_extension]);
    file_paths = dir([append(input_file_folder, run_number, '\s*')]);
    file_paths = {file_paths.name};
    disp(file_paths)
    
    %% extract the ROI mask out of the static fMRI file
    roi_path = load_untouch_nii('E:\Grid_cell_research\Qilang_s_data_fmri\Participant_5\T1\rREC.nii'); 
        % Previously: E:\ROI\rREC_diagpost.nii');
    % Load the 3D NIfTI file
    ROI_V = spm_vol(roi_path);
    
    ROI_indizes = find(ROI_V.img); 
    
    %% Set up a counter for the rows in the output CSV file
    row_counter = 1;
    
    % Loop over each file path in the array
    for i = 1:numel(file_paths)
        % Get the file path
        % old: file_path = fullfile(append('E:\IW03_runs7-12_funct\run',run_number), file_paths{i});
        file_path = fullfile(append('E:\Grid_cell_research\Qilang_s_data_fmri\Participant_5\',run_number,'\'), file_paths{i});
        
        disp(file_path);
    
        % Load the 4D NIfTI file
        V = spm_vol(file_path);
        Y = spm_read_vols(V);
        
        % Get a 1xm matrix of values from the nifti image 
        Y_voxel = Y(ROI_indizes)';
        
        % Write the output matrix to the output CSV file
        writematrix(Y_voxel, output_file_path, 'WriteMode','append');
    end
end