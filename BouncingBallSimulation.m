% Define the radius of the circle
radius = 5;

% Generate the angles for the circle
theta = linspace(0, 2*pi, 100);

% Generate the x and y coordinates for the circle
x = radius * cos(theta);
y = radius * sin(theta);

% Create a figure for the animation
figure('color','black', 'units', 'normalized','outerposition',[0 0 1 1]); % Full screen figure
plot(x, y, 'white','LineWidth', 2);
hold on;
axis equal;
axis off; % Turn off the axis numbers
grid off; % Turn off the grid

% Ball parameters
ballSpeed = 0.3;
initialPos = [0, 3];
initialDir = 2 * (rand(1, 2) - 0.5);

% Normalize the initial direction
initialDir = initialDir / norm(initialDir);

% Colors for the ball
colors = ['r', 'g', 'b', 'c', 'm', 'y'];
colorIndex = 1;

% Create the ball plot
hBall = plot(initialPos(1), initialPos(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', colors(colorIndex));

% Animation parameters
tolerance = 1e-6; % Small tolerance to handle numerical inaccuracies

% Ball state
balls = struct('pos', initialPos, 'dir', initialDir, 'handle', hBall);

% Collision counter
collisionCounter = 0;

% Frame rate control
frameRate = 30;
pauseTime = 1 / frameRate;

% Animate the circle and the ball indefinitely
while true
    % Update ball positions
    for i = 1:length(balls)
        balls(i).pos = balls(i).pos + ballSpeed * balls(i).dir;
        
        % Calculate the norm of the position vector once
        posNorm = norm(balls(i).pos);
        
        % Check for collision with the circle
        if posNorm >= radius - tolerance
            % Reflect the ball direction
            normal = balls(i).pos / posNorm;
            balls(i).dir = balls(i).dir - 2 * dot(balls(i).dir, normal) * normal;
            
            % Change ball color
            colorIndex = mod(colorIndex, length(colors)) + 1;
            set(balls(i).handle, 'MarkerFaceColor', colors(colorIndex));
            
            % Correct ball position to be exactly on the circle
            balls(i).pos = normal * (radius - tolerance);
            
            % Increment collision counter
            collisionCounter = collisionCounter + 1;
            
            % Check if it's time to add a new ball
            if mod(collisionCounter, 3) == 0
                newBallPos = initialPos;
                newBallDir = -1 + 2 * rand(1, 2);
                newBallDir = newBallDir / norm(newBallDir);
                newBallHandle = plot(newBallPos(1), newBallPos(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', colors(colorIndex));
                balls(end+1) = struct('pos', newBallPos, 'dir', newBallDir, 'handle', newBallHandle);
            end
        end
        
        % Update the ball plot
        set(balls(i).handle, 'XData', balls(i).pos(1), 'YData', balls(i).pos(2));
    end
    
    drawnow;
    pause(pauseTime); % Control the frame rate
end
