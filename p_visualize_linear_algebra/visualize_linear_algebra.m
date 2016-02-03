%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This program creates a GUI (graphical user interface). It allows the
%    user to visualize several concepts in linear algebra, including
%    
%    1. Matrix norm
%    2. Eigenvalues and eigenvectors
%    3. Singular value decomposition
%    
%    You can create your own matrices and norms (the code works for any p
%    between 1 and infinity) by modifying the list of matrices and norms
%    that you can find immediately below.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    visualize_linear_algebra
%    
%--------------------------------------------------------------------------
function visualize_linear_algebra()
    clc;
    clear all;
    close all;
    
    global matrices norms;
    global matrixIndex normIndex;
    global handle_gui;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Define the matrices and norms
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Create a list of 2 x 2 matrices
    matrices = {'[   3    0;    0    2]', ...
                '[   1   -1;    3    2]', ...
                '[   2   -1;   -1    2]', ...
                '[   1    0;    0    1]', ...
                '[   0    1;   -1    0]', ...
                '[ 1/4  1/3;    1  1/2]', ...
                '[   1    1; -1/4  1/2]', ...
                '[   1    1;    1    1]', ...
                '[   1    2;    1    2]', ...
                '[ 0.7  0.3; -0.6 -0.4]'};
    
    % Create a list of induced matrix norms
    norms = {1, 1.5, 2, 3, 10, 'inf'};
    
    % Set the matrix and norm indices to the first position
    matrixIndex = 1;
    normIndex   = 1;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Create the handle to the GUI
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    gui_backgroundColor = [0.902 0.898 0.901];
    
    handle_gui = ...
    figure('Name'             , 'Visualize Linear Algebra', ...
           'Units'            , 'normalized', ...
           'Position'         , [0.00 0.00 0.60 0.60], ...
           'Color'            , gui_backgroundColor, ...
           'DockControls'     , 'off', ...
           'InvertHardcopy'   , 'off', ...
           'MenuBar'          , 'none', ...
           'NumberTitle'      , 'off', ...
           'Resize'           , 'on', ...
           'PaperUnits'       , 'points', ...
           'PaperPosition'    , [0 0 800 600], ...
           'PaperPositionMode', 'auto', ...
           'ToolBar'          , 'none');
    
    movegui(handle_gui, 'center');
    
    % Display the GUI
    drawGUI();
end


function drawGUI()
    global handle_gui;
    global handle_title;
    
    % Call the GUI handle and clear the screen
    figure(handle_gui);
    clf;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Create a menu
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    menu(1) = uimenu(handle_gui, 'Label', 'File');
    menu(2) = uimenu(handle_gui, 'Label', 'Tools');
    menu(3) = uimenu(handle_gui, 'Label', 'Help');
    
    % File
    uimenu(menu(1), 'Label'      , 'Return to main screen', ...
                    'Accelerator', 'n', ...
                    'Callback'   , @newWorkspace);
    
    uimenu(menu(1), 'Label'      , 'Take screenshot', ...
                    'Accelerator', 's', ...
                    'Callback'   , @saveWorkspace);
    
    uimenu(menu(1), 'Label'      , 'Close program', ...
                    'Accelerator', 'w', ...
                    'Separator'  , 'on', ...
                    'Callback'   , @closeWorkspace);
    
    % Tools
    uimenu(menu(2), 'Label'      , 'Matrix norm', ...
                    'Accelerator', '1', ...
                    'Callback'   , {@vla_matrix_norm, 'main_menu'});
    
    uimenu(menu(2), 'Label'      , 'Singular value decomposition', ...
                    'Accelerator', '2', ...
                    'Callback'   , {@vla_singular_values, 'main_menu'});
    
    uimenu(menu(2), 'Label'      , 'Eigenvalues and eigenvectors', ...
                    'Accelerator', '3', ...
                    'Callback'   , {@vla_eigenvalues, 'main_menu'});
    
    % Help
    uimenu(menu(3), 'Label'      , 'Matrix norm', ...
                    'Callback'   , {@showHelp, 'Matrix norm'});
    
    uimenu(menu(3), 'Label'      , 'Singular value decomposition', ...
                    'Callback'   , {@showHelp, 'Singular value decomposition'});
    
    uimenu(menu(3), 'Label'      , 'Eigenvalues and eigenvectors', ...
                    'Callback'   , {@showHelp, 'Eigenvalues and eigenvectors'});
    
    uimenu(menu(3), 'Label'      , 'Credits', ...
                    'Separator'  , 'on', ...
                    'Callback'   , @showCredits);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Create a background image
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    handle_background = axes('Units'   , 'normalized', ...
                             'Position', [-0.02 -0.15 1.10 0.50]);
    
    uistack(handle_background, 'bottom');
    
    imagesc(imread('banner.png'));
    
    set(handle_background, 'HandleVisibility', 'off', 'Visible', 'off');
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Create the title
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Set the colors
    backgroundColor = handle_gui.Color;
    foregroundColor = [0.50 0.10 0.10];
    
    handle_title = ...
    uicontrol('Parent'             , handle_gui, ...
              'Style'              , 'text', ...
              'String'             , '', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.90 0.96 0.08], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontAngle'          , 'italic', ...
              'FontSize'           , 30, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left');
end



%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to return to main screen
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function newWorkspace(~, ~)
    drawGUI();
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to save a screenshot
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function saveWorkspace(~, ~)
    global handle_gui;
    global handle_external;
    
    % Close the external window if it exists already
    if (ishandle(handle_external))
        close(handle_external);
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Let the user select where to save the screenshot
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    [fileName, fileDirectory, fileExtension] = ...
    uiputfile({'*.png', 'PNG file'; '*.jpg', 'JPEG file'}, ...
              'Save the screenshot as', ...
              'vls_screenshot');
    
    % Save to file
    switch fileExtension
        case 1
            print('-dpng', '-r0', strcat(fileDirectory, fileName));
        
        case 2
            print('-djpeg', '-r0', strcat(fileDirectory, fileName));
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Provide the user feedback
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Set the colors
    backgroundColor = [0.76 0.82 0.73];
    foregroundColor = [0.14 0.12 0.20];
    
    % Create the feedback window
    handle_external = ...
    figure('Name'        , 'Success', ...
           'Units'       , 'normalized', ...
           'Position'    , [0.00 0.00 0.26 0.15], ...
           'Color'       , backgroundColor, ...
           'DockControls', 'off', ...
           'MenuBar'     , 'none', ...
           'NumberTitle' , 'off', ...
           'Resize'      , 'off', ...
           'ToolBar'     , 'none');
    
    movegui(handle_external, 'center');
    
    uicontrol('Parent'             , handle_external, ...
              'Style'              , 'text', ...
              'String'             , sprintf('Your screenshot has been created. Enjoy!'), ...
              'Units'              , 'normalized', ...
              'Position'           , [0.06 0.30 0.88 0.44], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 13.5, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'center');
    
    handle_button_ok = ...
    uicontrol('Parent'             , handle_external, ...
              'Style'              , 'pushbutton', ...
              'String'             , 'OK', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.43 0.10 0.14 0.16], ...
              'BackgroundColor'    , handle_gui.Color, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 12, ...
              'FontWeight'         , 'bold', ...
              'Callback'           , @close_prompt);
    
    % Set focus on the OK button
    uicontrol(handle_button_ok);
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to close the program
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function closeWorkspace(~, ~)
    close all;
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to show help message
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function showHelp(~, ~, topic)
    global handle_gui handle_external;
    
    % Close the external window if it exists already
    if (ishandle(handle_external))
        close(handle_external);
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Customize the tutorial according to the topic
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    switch topic
        case 'Matrix norm'
            help_message = ['Recall that a matrix norm can be created from ('...
                            '"induced by") a vector norm:\n\n||A||_{p}  =   '...
                            '     max        ||Ax||_{p}\n                   '...
                            '||x||_{p} = 1\nIn the plot window, the orange ' ...
                            'points represent vectors x on the unit ball, '  ...
                            'while the blue points represent their linear '  ...
                            'transformations A*x.\n\nSee if you can find the'...
                            ' matrix norm ||A||_{p} by maximizing the vector'...
                            ' norm ||Ax||_{p}!'];
            
        case 'Singular value decomposition'
            help_message = ['The singular value decomposition of a matrix A' ...
                            ' takes the following form:\nA = U * S * V^{T}'  ...
                            '\nThe plot window shows two orthogonal vectors' ...
                            ' x1, x2 and their linear transformations A*x1, '...
                            'A*x2.\nWhen A*x1 and A*x2 are also orthogonal, '...
                            'we know that x1, x2 are the right singular vec' ...
                            'tors (the columns of V) and A*x1, A*x2 the left'...
                            ' singular vectors (the columns of U).\n\nSee if'...
                            ' you can set the angle between A*x1 and A*x2 to'...
                            ' be 90 degrees. How can we find (how does the ' ...
                            'GUI know) what the singular values are?'];
            
        case 'Eigenvalues and eigenvectors'
            help_message = ['Recall that lambda (a scalar) and x (a vector)' ...
                            ' are an eigenvalue and an eigenvector of the '  ...
                            'matrix A, if the following equation holds:\n\n' ...
                            'A * x = lambda * x\n\nThat is, when the vectors'...
                            ' x and A*x are parallel to each other!\n\nSee ' ...
                            'if you can set the angle between x and A*x to ' ...
                            'be 0 or 180 degrees. How can we find (how does' ...
                            ' the GUI know) what the eigenvalue is?'];
            
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Display the help message
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Set the colors
    backgroundColor = [0.76 0.82 0.73];
    foregroundColor = [0.14 0.12 0.20];
    
    % Create the help window
    handle_external = ...
    figure('Name'        , sprintf('Tutorial: %s', topic), ...
           'Units'       , 'normalized', ...
           'Position'    , [0.00 0.00 0.31 0.42], ...
           'Color'       , backgroundColor, ...
           'DockControls', 'off', ...
           'MenuBar'     , 'none', ...
           'NumberTitle' , 'off', ...
           'Resize'      , 'off', ...
           'ToolBar'     , 'none');
    
    movegui(handle_external, 'center');
    
    uicontrol('Parent'             , handle_external, ...
              'Style'              , 'text', ...
              'String'             , sprintf(help_message), ...
              'Units'              , 'normalized', ...
              'Position'           , [0.06 0.15 0.88 0.80], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 13.5, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left');
    
    handle_button_ok = ...
    uicontrol('Parent'             , handle_external, ...
              'Style'              , 'pushbutton', ...
              'String'             , 'OK', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.43 0.06 0.14 0.06], ...
              'BackgroundColor'    , handle_gui.Color, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 12, ...
              'FontWeight'         , 'bold', ...
              'Callback'           , @close_prompt);
    
    % Set focus on the OK button
    uicontrol(handle_button_ok);
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to show credits
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function showCredits(~, ~)
    global handle_gui handle_external;
    
    % Close the external window if it exists already
    if (ishandle(handle_external))
        close(handle_external);
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Display the credits
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Set the colors
    backgroundColor = [0.76 0.82 0.73];
    foregroundColor = [0.14 0.12 0.20];
    
    % Create the credits window
    handle_external = ...
    figure('Name'        , 'Credits', ...
           'Units'       , 'normalized', ...
           'Position'    , [0.00 0.00 0.26 0.15], ...
           'Color'       , backgroundColor, ...
           'DockControls', 'off', ...
           'MenuBar'     , 'none', ...
           'NumberTitle' , 'off', ...
           'Resize'      , 'off', ...
           'ToolBar'     , 'none');
    
    movegui(handle_external, 'center');
    
    uicontrol('Parent'             , handle_external, ...
              'Style'              , 'text', ...
              'String'             , sprintf(['This GUI has been brought to you'...
                                              ' by Isaac Lee.\n\nCome visit his'...
                                              ' blog at crunchingnumbers.live !']), ...
              'Units'              , 'normalized', ...
              'Position'           , [0.06 0.20 0.88 0.64], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 13.5, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'center');
    
    handle_button_ok = ...
    uicontrol('Parent'             , handle_external, ...
              'Style'              , 'pushbutton', ...
              'String'             , 'OK', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.43 0.10 0.14 0.16], ...
              'BackgroundColor'    , handle_gui.Color, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 12, ...
              'FontWeight'         , 'bold', ...
              'Callback'           , @close_prompt);
    
    % Set focus on the OK button
    uicontrol(handle_button_ok);
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to close an external prompt window
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function close_prompt(~, ~)
    global handle_external;
    
    close(handle_external);
end