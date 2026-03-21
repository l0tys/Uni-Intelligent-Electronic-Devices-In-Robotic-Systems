function [pointCloudA, pointCloudB] = exampleHelperInitializeSensorVisualization(ax, plotFrames)
%EXAMPLEHELPERINITIALIZESENSORVISUALIZATION initialize lidar sensor visualization

%   Copyright 2021 The MathWorks, Inc.

hold(ax,"on")
colormap("jet");
pointCloudA = pointCloud(nan(1,1,3));
scatterplotA = scatter3(nan, nan, nan, 1, [0.3020 0.7451 0.9333],...
    "Parent", plotFrames.MobileRobotA.LidarA);
scatterplotA.XDataSource = "reshape(pointCloudA.Location(:,:,1), [], 1)";
scatterplotA.YDataSource = "reshape(pointCloudA.Location(:,:,2), [], 1)";
scatterplotA.ZDataSource = "reshape(pointCloudA.Location(:,:,3), [], 1)";
scatterplotA.CDataSource = "reshape(pointCloudA.Location(:,:,3), [], 1) - min(reshape(pointCloudA.Location(:,:,3), [], 1))";

colormap("jet");
pointCloudB = pointCloud(nan(1,1,3));
scatterplotB = scatter3(nan, nan, nan, 1, [0.3020 0.7451 0.9333],...
    "Parent", plotFrames.MobileRobotB.LidarB);
scatterplotB.XDataSource = "reshape(pointCloudB.Location(:,:,1), [], 1)";
scatterplotB.YDataSource = "reshape(pointCloudB.Location(:,:,2), [], 1)";
scatterplotB.ZDataSource = "reshape(pointCloudB.Location(:,:,3), [], 1)";
scatterplotB.CDataSource = "reshape(pointCloudB.Location(:,:,3), [], 1) - min(reshape(pointCloudB.Location(:,:,3), [], 1))";
hold(ax,"off")

end

