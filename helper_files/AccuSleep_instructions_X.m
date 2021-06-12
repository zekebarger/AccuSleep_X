function AccuSleep_instructions_X
% AccuSleep X user manual
% Updated 02/13/2021
% 
% Section 0: AccuSleep vs. AccuSleep X
% Section 1: Overview of the GUI
% Section 2: AccuSleep data structures
% Section 3: Manually assigning sleep stage labels
% Section 4: Automatically assigning sleep stage labels
%
% 
% ----------------------------------------------------------------------- 
% Section 0: AccuSleep vs. AccuSleep X
% ----------------------------------------------------------------------- 
% 
% AccuSleep was designed to help detect three brain states: REM, NREM, and
% wakefulness. AccuSleep X is a modified version that allows a user to 
% classify up to eight states. While classification is still only possible
% if the states have distinct patterns of EEG/EMG activity, this version
% opens up the possibility of sleep staging for NHPs or other organisms.
%
% Before you begin using AccuSleep X, you will need to store information
% about the brain states you want to detect in a configuration file.
% If at all possible, you should not modify this file more than once--doing
% so can make your trained networks, calibration files, and label files
% incompatible or out of sync. If you do modify the calibration file, I 
% recommend deleting or quarantining any existing trained networks, 
% calibration files, and label files.
%
% With that in mind, here is how to set up the calibration file:
% 1. Locate the file named AS_config.mat in the AccuSleep_X folder. 
% 2. Drag it into the Matlab workspace or command window to load its 
%    contents. 
% 3. You will see three new variables: cfg_names, cfg_colors, and
%    cfg_weights. Double-click on each variable in the workspace to make
%    changes to it.
% 3A. cfg_names should be a cell array where each entry is the name of a 
%     brain state. For example, {'REM'; 'Quiet wake'; 'Active wake'; 
%     'Light sleep'; 'Deep sleep'}. The order is up to you, but it should 
%     be consistent with the other two variables. You can store between two
%     and eight states in the array. Do not create an "undefined" state--
%     this already exists.
% 3B. cfg_colors should be a cell array where each entry is an array of 
%     length 3 with RGB values associated with each state. For example,
%     [1,0,0] would be red. These are the colors that will appear in the 
%     visual interface when reviewing you data. Avoid using black, since
%     this is how undefined epochs are displayed.
% 3C. cfg_weights is an array where each value is the expected proportion 
%     of each state. The values should sum to 1. These don't have to be 
%     perfect, just approximations. For example, the expected proportions
%     of REM, wakefulness, and NREM might be [0.1, 0.35, 0.55].
% 4. Select the three variables (on Windows, ctrl+click each one),
%    right-click on one of them, and choose "Save As". In the window that
%    appears, navigate to the AS_config.mat file in the AccuSleep_X folder,
%    click on it, and click "Save" to overwrite the existing configuration
%    file.
%
%
% ----------------------------------------------------------------------- 
% Section 1: Overview of the GUI
% ----------------------------------------------------------------------- 
% 
% This interface allows a user to assign sleep stage labels to 1-channel 
% electroencephalogram (EEG) and electromyogram (EMG) data.
%
% The overall workflow when using AccuSleep_GUI_X looks like this:
% 1. Enter the sampling rate and epoch length for all recordings from
%    one subject
% 2. For each recording from this subject, add it to the recording list, 
%    load the EEG/EMG data, and determine where to save the sleep stage 
%    labels (or load the labels if they already exist)
% (At this stage, you can score the recordings manually)
% 3. Choose a representative recording that has some epochs of each state
%    labeled and use it to create a calibration data file (or load the
%    calibration data file if it already exists)
% 4. Choose a trained neural network file, with a matching epoch size
% 5. Score all recordings for this subject automatically
% 6. Start over for the next subject
% 
% Please read Section 2 for information on how to structure the inputs to
% this program. Five inputs are required for manual labeling, and seven 
% are required for automatic labeling. To the right of each input is a 
% colored indicator. If an input is required by a function listed on the
% left side of the interface, its indicator will also be shown there. The
% indicators can have several forms:
% 
% Red X: the input is missing or is not in the required format. 
% Green check: the input has the correct format.
% Yellow !: the input is not in the recommended range.
% Orange !!: there may be a serious problem with the input.
% Gray ?: the state of the input is unknown, and may or may not be correct. 
% 
% 
% ----------------------------------------------------------------------- 
% Section 2: AccuSleep data structures
% ----------------------------------------------------------------------- 
% 
% There are six types of files associated with AccuSleep_X:
%
% Configuration file: a file called AS_config.mat containing information
%    about the brain states to be scored. See Section 0 for details.
% 
% EEG file: a .mat file containing a variable named 'EEG' that is a 1-D
%    numeric matrix. No filtering or other preprocessing is necessary. 
%    This should be a 1-channel electroencephalogram signal.
% 
% EMG file: same format as EEG, but the variable is named 'EMG'. The EEG
%    and EMG data must be the same length. This should be a 1-channel 
%    electromyogram signal.
% 
% Label file: a .mat file containing a variable called 'labels' that is
%    a 1-D numeric matrix. If there are n states defined in the 
%    configuration file, then the range of values will be 1:n+1. Entries 
%    with the value n+1 are in the "undefined" state.
% 
% Calibration data file: required for automatic labeling. See Section 4 
%    for details.
% 
% Trained network file: required for automatic labeling. See Section 4 
%    for details.
% 
% 
% ----------------------------------------------------------------------- 
% Section 3: Manually assigning sleep stage labels
% ----------------------------------------------------------------------- 
% 
% 1. Select the recording you wish to modify from the recording list, or
%    add a new one. Make sure the sampling rate (in Hz) and epoch length
%    (in seconds) are set. The epoch length determines the time 
%    resolution of the labels. Typical values for mice are 2.5, 4, and 5.
%
% 2. Click the 'Select EEG file' button to set the location of the EEG data.
% 
% 3. Click the 'Select EMG file' button to set the location of the EMG data.
% 
% 4. Click 'Set / load label file' and enter a filename for saving the
%    sleep stage labels. You can also select an existing label file if
%    you wish to view or modify its contents.
% 
% 5. Click 'Score selected manually' to launch an interactive figure 
%    window for manual sleep stage labeling. Click the 'help' button in
%    the upper right of the figure for instructions. Click the save 
%    button at any time to save the sleep stage labels to the file 
%    specified in step 4, and close the window when you are finished.
% 
% 
% ----------------------------------------------------------------------- 
% Section 4: Automatically assigning sleep stage labels using a trained
%    neural network
% ----------------------------------------------------------------------- 
% 
% Automatic sleep stage labeling requires the five inputs described in 
% Section 3, as well as a calibration data file and a trained network
% file. If you already have both of these files, proceed to Section 4C.
% 
% 
% Section 4A: Creating a calibration data file
% 
% You must create a new calibration data file for each subject. If you
% record from the same subject using different recording equipment, you
% must create a new calibration data file for each combination of 
% subject + recording setup. This ensures that inputs to the neural
% network are in the same range as its training data. 
% 
% Instructions for creating a calibration data file using this GUI are 
% below. You can also run createCalibrationData.m and save the output 
% in a .mat file in a variable called 'calibrationData'.
% 
% 1. Complete steps 1-4 of Section 3 (specifying the EEG file, EMG file,
%    label file, sampling rate, and epoch length).
% 
% 2. The label file must contain at least some labels for each brain state 
%    defined in the calibration file. It is recommended to label at
%    least several minutes of each stage, and more calibration data can
%    improve classification accuracy. If the label file already meets this 
%    condition, continue to step 3. Otherwise, click 
%    'score selected manually', assign some sleep stage labels to the 
%    recording, and save the labels. 
% 
% 3. Click 'Create calibration data file'.
% 
% 4. Enter a filename for the calibration data file.
% 
% 
% Section 4B: Creating a trained network file
% 
% Pre-trained neural networks are provided with AccuSleep for epoch 
% lengths of 2.5, 4, 5, 10, 15, and 30 seconds. However, these networks are
% only trained to recognize REM, NREM, and wakefulness in mice. If you 
% wish to train your own network to score additional brain states or you
% are using a different organism, see AccuSleep_train.m for details. You 
% will need to create a cell array containing filenames of EEG, EMG, and 
% label files in the training set. The file called fileList_template.mat is
% an example of how to structure this array. AccuSleep_train produces a 
% SeriesNetwork object. Name this variable 'net' and save it in a .mat 
% file. You can then load it in step 3 of Section 4C.
% 
% 
% Section 4C: Automatic labeling
% 
% Instructions for automatic labeling using this GUI are below. To
% batch process recordings from multiple subjects, see 
% AccuSleep_classify.m
% 
% 1. Set the sampling rate and epoch length, and complete steps 1-4 of
%    Section 3 (specifying the EEG file, EMG file, and label file) for
%    each recording from one subject. Since each subject requires its
%    own calibration file, only recordings from one subject can be 
%    scored at a time. If the recording conditions are different in
%    some recordings (e.g., a different amplifier was used), remove 
%    these recordings from the recording list and process them 
%    separately with their own calibration file.
% 
% 2. If you completed the steps in Section 4A, a calibration data file 
%    has already been specified. Otherwise, click 
%    'Load calibration file' to load the calibration data file.
% 
% 3. Click 'Load trained network file' to load the trained neural
%    network. The epoch length used when training this network should be
%    the same as the current epoch length.
% 
% 4. If you wish to preserve any existing labels in the label file, and
%    only overwrite undefined epochs, check the box labeled
%    'Only overwrite undefined epochs'.
% 
% 5. Set the minimum bout length, in seconds. A typical value for mice is 
%    5. Following automatic labeling, any sleep stage bout shorter than 
%    this duration will be reassigned to the surrounding stage (if the
%    stages on either side of the bout match). 
% 
% 6. Click 'Score all automatically' to score all recordings in the
%    recording list. Labels will be saved to the file specified by 
%    the 'Set / load label file' field of each recording. You can click 
%    'Score selected manually' to visualize the results. Note that unless
%    the ‘Only overwrite undefined epochs' box is checked, any other
%    contents (e.g., other variables) in the existing label file will 
%    be automatically overwritten.
% 
doc AccuSleep_instructions_X
