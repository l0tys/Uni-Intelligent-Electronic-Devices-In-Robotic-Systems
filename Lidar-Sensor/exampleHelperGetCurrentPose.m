function [robotCurrentPose, isUpdated, stopSimulation, pointCloud] = ...
    exampleHelperGetCurrentPose(controller, robotDiff, vfh, lidar, LidarSensorParam, ...
    robotCurrentPose, robotGoal, stopSimulation)
%EXAMPLEHELPERGETCURRENTPOSE estimate current robot pose and lidar sensor data
%   This function estimates current pose of robot based on lidar sensor,
%   controller and VFH inputs. Further, it returns current lidar sensor
%   data required in the visualization.

%   Copyright 2021 The MathWorks, Inc.

sampleTime = 0.1;

% Compute the controller outputs, i.e., the inputs to the robot.
[v, omega] = controller(robotCurrentPose);

% Get the robot's velocity using controller inputs.
vel = derivative(robotDiff, robotCurrentPose, [v omega]);

% Update the current pose.
robotCurrentPose = robotCurrentPose + vel*sampleTime;

% Re-compute the distance to the unloadingPosition.
distanceToGoal = norm(robotCurrentPose(1:2) - robotGoal(:));

if distanceToGoal < 0.1
    % stop simulation if robot reaches to goal position
    stopSimulation = true;
end

% Get lidar sensor readings.
[isUpdated, ~, pointCloud] = lidar.read();

steeringDir = 0;
if isUpdated
    % Get steering angle.
    steeringDir = getSteeringDirection(vfh, pointCloud, LidarSensorParam);
end

if isnan(steeringDir)
    % Stop simulation, if steering angle is NaN value.
    stopSimulation = true;
end

% Add sterring angle with robot heading angle.
robotCurrentPose(3) = robotCurrentPose(3) + steeringDir;

end

function steeringDir = getSteeringDirection(vfh, pointCloud, LidarSensorParam)
%GETSTEERINGDIRECTION returns steering angle based on lidar sensor readings

% Get range values from point cloud.
ranges = sqrt(pointCloud.Location(:,:,1).^2 + pointCloud.Location(:,:,2).^2);

% Get angles in radian.
angles = linspace(LidarSensorParam.angleLower*pi/180, ...
    LidarSensorParam.angleUpper*pi/180, numel(ranges));

% Create a lidarScan object from the ranges and angles.
scan = lidarScan(ranges, angles);

% Call VFH object to computer steering direction.
steeringDir = vfh(scan,0);

end

