function boxes = find_bounding_boxes_25(binaryImage)
    
    % ensure at least one object is present in the img
    binaryImage = binaryImage ~= 0;
    [rows, cols] = size(binaryImage);
    % create a matrix of values for visited pixels, this helps with DFS
    visited = false(rows, cols);
    boxes = [];  % Each row: [minRow, minCol, maxRow, maxCol] for a bbox

    directions = [0 1; 1 0; 0 -1; -1 0];  % 4-connected (edge neighbours of each pixel)

    % loop over all pixels
    for r = 1:rows
        for c = 1:cols
            % if current pixel is '1' and not visited yet
            if binaryImage(r, c) && ~visited(r, c)

                % this is the start of an object set the box coords here
                minRow = r; maxRow = r;
                minCol = c; maxCol = c;
                
                % add this to the stack
                stack = [r, c];
                visited(r, c) = true;

                while ~isempty(stack)
                    currR = stack(end, 1);
                    currC = stack(end, 2);
                    stack(end, :) = [];

                    % update bbox limits
                    minRow = min(minRow, currR);
                    maxRow = max(maxRow, currR);
                    minCol = min(minCol, currC);
                    maxCol = max(maxCol, currC);
                    
                    % check each of the 4 neighbrs
                    for d = 1:size(directions, 1)
                        newR = currR + directions(d, 1);
                        newC = currC + directions(d, 2);

                           % check boundary and go to unvisited pixels
                        if newR >= 1 && newR <= rows && newC >= 1 && newC <= cols
                            if binaryImage(newR, newC) && ~visited(newR, newC)
                                visited(newR, newC) = true;
                                stack(end+1, :) = [newR, newC]; %#ok<AGROW>
                            end
                        end
                    end
                end
                % store the bbox
                boxes(end+1, :) = [minRow, minCol, maxRow, maxCol]; %#ok<AGROW>
            end
        end
    end
end

%%%%%%%%% Example Usage + Plot
% Parameters
rows = 500;
cols = 500;
centerRow = -50;
centerCol = 50;
radius = 180;

% Initialize image
circleImage = zeros(rows, cols);

% Generate circle 1
for r = 1:rows
    for c = 1:cols
        dist = sqrt((r - centerRow)^2 + (c - centerCol)^2);
        if dist <= radius
            circleImage(r, c) = 1;
        end
    end
end

% Generate circle 2
centerRow2 = 300;
centerCol2 = 300;
radius2 = 25;

for r = 1:rows
    for c = 1:cols
        dist = sqrt((r - centerRow2)^2 + (c - centerCol2)^2);
        if dist <= radius2
            circleImage(r, c) = 1;
        end
    end
end

% Display
imagesc(circleImage); colormap(gray); axis image;


img = circleImage;  % Use the generated circle image as input


% Get bounding box coordinates
boxes = find_bounding_boxes_25(img);

% Display original image
imagesc(img); colormap(gray); axis image; hold on;

% Overlay thin rectangles
for i = 1:size(boxes, 1)
    r1 = boxes(i,1); c1 = boxes(i,2);
    r2 = boxes(i,3); c2 = boxes(i,4);
    rectangle('Position', [c1 - 0.5, r1 - 0.5, c2 - c1 + 1, r2 - r1 + 1], ...
          'EdgeColor', 'b', 'LineWidth', 1);
end