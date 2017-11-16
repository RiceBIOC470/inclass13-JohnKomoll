%Inclass 13
%GB comments
1a 70 To use this method, it is best to use a larger radial value in the morphological structuring element. Change 60 to 130+ and the resulting image is much more reasonable. 
1b 100 
1c 100
1d 100
2a 100
2b 100
2c 100
overall: 96


%Part 1. In this directory, you will find an image of some cells expressing a 
% fluorescent protein in the nucleus. 
% A. Create a new image with intensity normalization so that all the cell
% nuclei appear approximately eqully bright. 
% B. Threshold this normalized image to produce a binary mask where the nuclei are marked true. 
% C. Run an edge detection algorithm and make a binary mask where the edges
% are marked true.
% D. Display a three color image where the orignal image is red, the
% nuclear mask is green, and the edge mask is blue. 

% Define location of image and open the raw image
imgfile = 'Dish1Well8Hyb1Before_w0001_m0006.tif';
img = imread(imgfile);
imshow(img,[])

% A. Turn image to double, dilate the image, then normalize it based on the
% dilation
img = im2double(img);
img = img .* (img > 0.05);
img_dilate = imdilate(img, strel('disk', 40));
img_norm = img./img_dilate;
figure
imshow(img_norm,[])

% B. Apply a mask to the normalized image
mask = img_norm > 0.2;
figure
imshow(mask)

% C. Use the canny method to create a binary mask for the cell edges (looks
% better than sobel). Fill the holes in the edges.
edge_img = imdilate(edge(img, 'canny', [0.03 0.1]), strel('disk', 1));
figure
imshow(edge_img,[])

% D. Put it all together in an RGB image
img_all = cat(3, im2double(imadjust(img)), mask, edge_img);
figure
imshow(img_all)

%Part 2. Continue with your nuclear mask from part 1. 
%A. Use regionprops to find the centers of the objects
%B. display the mask and plot the centers of the objects on top of the
%objects
%C. Make a new figure without the image and plot the centers of the objects
%so they appear in the same positions as when you plot on the image (Hint: remember
%Image coordinates). 

% A. Get centers of objects
cell_props = regionprops(mask, 'Centroid');

% B. Show centroids over mask
figure
imshow(mask)
hold on
data = [cell_props.Centroid];
% Iterate over each centroid and plot it
for center = 1:2:length(data)

    plot(data(center), data(center+1), 'bo')
    hold on
    
end

% C. Plot centroids without mask, adjusting indices
figure
% Get size of image to adjust accordingly
[~, ysize] = size(mask);

% Iterate over each centroid and plot with adjusted coordinates
for center = 1:2:length(data)
    
    plot(data(center), ysize - data(center+1), 'bo')
    hold on
    
end
