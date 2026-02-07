scenario = robotScenario(UpdateRate=5);

floorColor = [0.5882 0.2941 0];
addMesh(scenario, "Plane", Position=[5 5 0], Size=[9 5], Color=floorColor);

wallHeight = 1;
wallWidth = 0.25;
wallLength = 10;
wallColor = [1 1 0.8157];

% Add outer walls
addMesh(scenario, "Box", Position=[wallWidth/2, wallLength/2, wallHeight/2], ...
    Size=[wallHeight, wallLength, wallHeight], Color=wallColor, IsBinaryOccupied=true);

% Add inner walls
addMesh(scenario, "Box", Position=[wallLength/8, wallLength/3, wallHeight/2],...
    Size=[wallLength/4, wallWidth, wallHeight], Color=wallColor, IsBinaryOccupied=true);

% Visualize the scenario
show3D(scenario);
lightangle(-45, 30);
view(60, 50);