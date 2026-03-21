function exampleHelperPlotDetectionPoint(scenario, pointOnTarget, sensorName, pose)
%EXAMPLEHELPERPLOTDETECTIONPOINT Plot detection point as red sphere

detectionPtWRTSensor = pointOnTarget; %wrt sensor
sensorENUTform = scenario.TransformTree.getTransform("ENU", sensorName);
R = eul2rotm(quat2eul(pose(10:13))); %rotm of the platform
detectionPtWRTPlatform = R*detectionPtWRTSensor; %wrt platform
detectionPtWRTENU = sensorENUTform(1:3,4) + detectionPtWRTPlatform; %wrt world frame

[X,Y,Z] = sphere;
r = 0.1;
X2 = X * r;
Y2 = Y * r;
Z2 = Z * r;

surf(X2+detectionPtWRTENU(1), ...
    Y2+detectionPtWRTENU(2), ...
    Z2+pose(3)+.25, FaceColor='r', EdgeColor='r');
end
 
