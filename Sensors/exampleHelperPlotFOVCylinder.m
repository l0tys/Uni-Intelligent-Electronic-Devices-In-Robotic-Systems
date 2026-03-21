function exampleHelperPlotFOVCylinder(pose,maxDetectionRange)
%EXAMPLEHELPERPLOTFOVCYLINDER Plot cylinder showing the field of view of
%the sensor

[X,Y,Z]=cylinder([0 1], 50);
yrot = quat2eul(pose(10:13));
M=makehgtform(translate=[pose(1),pose(2),pose(3)+0.25], xrotate=pi/2, yrotate=pi/2+yrot(1), ...
    scale=[1,1, maxDetectionRange]);
surf(X,Y,Z, Parent=hgtransform(Matrix=M), LineStyle='none', FaceAlpha=0.4);
end

