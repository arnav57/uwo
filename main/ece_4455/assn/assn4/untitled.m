% 1. Define the Input Image (Figure 7)
I = [
    0 0 0 0 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 0 0 0 0
];

% 2. Define the Structuring Element
% The problem gives [1 0 1] with the origin at the center.
% MATLAB treats non-zero elements as the shape.
SE = [1 0 1];

% 3. Perform Morphological Opening
% Method A: Step-by-Step (Erosion then Dilation)
% This helps confirm your intermediate logic.
I_eroded = imerode(I, SE);
I_opened_manual = imdilate(I_eroded, SE);

% Method B: Using the built-in function
% This should yield the exact same result.
I_opened_builtin = imopen(I, SE);

% 4. Display the Results
disp('--- Input Image ---');
disp(I);

disp('--- Step 1: Erosion Result (I (minus) SE) ---');
% Expected: Vertical line of 1s in the middle column
disp(I_eroded);

disp('--- Step 2: Dilation Result (Eroded (plus) SE) ---');
% Expected: Two vertical lines (cols 2 and 4), center is 0
disp(I_opened_manual);

% 5. Verification Check
if isequal(I_opened_manual, I_opened_builtin)
    disp('Verification Successful: Manual steps match built-in imopen.');
else
    disp('Verification Failed.');
end