%% imfindcircles GOOD vs BAD live demo
% Demonstrates how parameter choices affect circle detection
%
% Controls:
%   1 - GOOD case
%   2 - BAD: wrong radius range
%   3 - BAD: sensitivity too high
%   4 - BAD: noisy image
%   5 - GOOD: noisy image + preprocessing
%   q - quit
%
% Recommended sample image:
%   coins.png  (MATLAB sample)
%
% If coins.png is not found, replace with your own image path.

clc;
clear;
close all;

%% Load image
try
    img = imread('coins.png');
catch
    error(['Could not find coins.png. ', ...
           'Place coins.png in the current folder or change the file name in the script.']);
end

if size(img, 3) == 3
    gray0 = rgb2gray(img);
else
    gray0 = img;
end

%% Create figure
hFig = figure( ...
    'Name', 'imfindcircles GOOD vs BAD Demo', ...
    'NumberTitle', 'off', ...
    'Color', 'w', ...
    'Units', 'normalized', ...
    'Position', [0.12 0.12 0.76 0.76]);

disp('------------------------------------------');
disp('imfindcircles GOOD vs BAD Demo');
disp('Press a key in the figure window:');
disp('  1 - GOOD case');
disp('  2 - BAD: wrong radius range');
disp('  3 - BAD: sensitivity too high');
disp('  4 - BAD: noisy image');
disp('  5 - GOOD: noisy image + preprocessing');
disp('  q - quit');
disp('------------------------------------------');

showCase(img, gray0, 1);

while ishandle(hFig)
    waitforbuttonpress;
    if ~ishandle(hFig)
        break;
    end

    key = get(hFig, 'CurrentCharacter');

    switch lower(key)
        case '1'
            showCase(img, gray0, 1);
        case '2'
            showCase(img, gray0, 2);
        case '3'
            showCase(img, gray0, 3);
        case '4'
            showCase(img, gray0, 4);
        case '5'
            showCase(img, gray0, 5);
        case 'q'
            close(hFig);
        otherwise
            % ignore other keys
    end
end

%% ===== Local function =====
function showCase(img, gray0, caseID)

    clf;

    switch caseID
        case 1
            % GOOD: reasonable radius + moderate sensitivity
            gray = gray0;
            titleText = 'GOOD: correct radius range + moderate sensitivity';
            explanation = sprintf([ ...
                'Why it works well:\\n', ...
                '- radius range matches object size\\n', ...
                '- edges are clear\\n', ...
                '- sensitivity is balanced']);
            paramsText = sprintf([ ...
                '[centers, radii] = imfindcircles(gray, [20 60], ...\\n', ...
                '    ''Sensitivity'', 0.88, ''EdgeThreshold'', 0.10);']);
            [centers, radii, metric] = imfindcircles(gray, [20 60], ...
                'Sensitivity', 0.88, 'EdgeThreshold', 0.10);

        case 2
            % BAD: wrong radius range
            gray = gray0;
            titleText = 'BAD: wrong radius range';
            explanation = sprintf([ ...
                'Why detection fails:\\n', ...
                '- MATLAB searches only tiny circles\\n', ...
                '- actual objects are much larger\\n', ...
                '- correct circles are missed']);
            paramsText = sprintf([ ...
                '[centers, radii] = imfindcircles(gray, [5 12], ...\\n', ...
                '    ''Sensitivity'', 0.88, ''EdgeThreshold'', 0.10);']);
            [centers, radii, metric] = imfindcircles(gray, [5 12], ...
                'Sensitivity', 0.88, 'EdgeThreshold', 0.10);

        case 3
            % BAD: sensitivity too high
            gray = gray0;
            titleText = 'BAD: sensitivity too high (false positives)';
            explanation = sprintf([ ...
                'Why detection becomes bad:\\n', ...
                '- weak evidence is accepted\\n', ...
                '- false circles appear\\n', ...
                '- clutter/noisy edges are treated as circles']);
            paramsText = sprintf([ ...
                '[centers, radii] = imfindcircles(gray, [20 60], ...\\n', ...
                '    ''Sensitivity'', 0.99, ''EdgeThreshold'', 0.05);']);
            [centers, radii, metric] = imfindcircles(gray, [20 60], ...
                'Sensitivity', 0.99, 'EdgeThreshold', 0.05);

        case 4
            % BAD: noisy image, no preprocessing
            gray = imnoise(gray0, 'gaussian', 0, 0.01);
            titleText = 'BAD: noisy image without preprocessing';
            explanation = sprintf([ ...
                'Why detection becomes unstable:\\n', ...
                '- noise creates fake edges\\n', ...
                '- the algorithm gets confused\\n', ...
                '- false or missing circles may appear']);
            paramsText = sprintf([ ...
                'gray = imnoise(gray, ''gaussian'', 0, 0.01);\\n', ...
                '[centers, radii] = imfindcircles(gray, [20 60], ...\\n', ...
                '    ''Sensitivity'', 0.88, ''EdgeThreshold'', 0.10);']);
            [centers, radii, metric] = imfindcircles(gray, [20 60], ...
                'Sensitivity', 0.88, 'EdgeThreshold', 0.10);

        case 5
            % GOOD: noisy image but smoothed first
            grayNoisy = imnoise(gray0, 'gaussian', 0, 0.01);
            gray = imgaussfilt(grayNoisy, 1.2);
            titleText = 'GOOD: noisy image + Gaussian smoothing';
            explanation = sprintf([ ...
                'Why this improves results:\\n', ...
                '- smoothing removes random noise\\n', ...
                '- edges become more stable\\n', ...
                '- true circles stand out better']);
            paramsText = sprintf([ ...
                'gray = imnoise(gray, ''gaussian'', 0, 0.01);\\n', ...
                'gray = imgaussfilt(gray, 1.2);\\n', ...
                '[centers, radii] = imfindcircles(gray, [20 60], ...\\n', ...
                '    ''Sensitivity'', 0.88, ''EdgeThreshold'', 0.10);']);
            [centers, radii, metric] = imfindcircles(gray, [20 60], ...
                'Sensitivity', 0.88, 'EdgeThreshold', 0.10);

        otherwise
            return;
    end

    % Left: image used for detection
    subplot(1,2,1);
    imshow(gray, []);
    title('Image used for detection', 'FontWeight', 'bold');

    % Right: overlay on original-ish display
    subplot(1,2,2);
    imshow(gray, []);
    hold on;
    if ~isempty(centers)
        viscircles(centers, radii, 'LineWidth', 1);
        plot(centers(:,1), centers(:,2), 'r+', 'MarkerSize', 8, 'LineWidth', 1.5);
    end
    hold off;
    title('Detection result', 'FontWeight', 'bold');

    % Figure-level annotation
    sgtitle(titleText, 'FontSize', 16, 'FontWeight', 'bold');

    % Detection stats
    n = size(centers, 1);
    if isempty(metric)
        metricText = 'No circles detected';
    else
        metricText = sprintf('Detected circles: %d   |   strongest metric: %.3f', ...
            n, max(metric));
    end

    % Text box with explanation + parameters
    annotation('textbox', [0.06 0.01 0.88 0.16], ...
        'String', sprintf('%s\n\n%s\n\n%s', explanation, metricText, paramsText), ...
        'FitBoxToText', 'off', ...
        'EdgeColor', [0.2 0.2 0.2], ...
        'BackgroundColor', [0.98 0.98 0.98], ...
        'FontName', 'Consolas', ...
        'FontSize', 10);

    drawnow;

    % Also print to Command Window for teaching
    fprintf('\n=== %s ===\n', titleText);
    fprintf('%s\n', strrep(explanation, '\n', '\n'));
    fprintf('%s\n', metricText);
end