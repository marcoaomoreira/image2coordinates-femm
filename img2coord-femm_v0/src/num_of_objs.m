function num_of_objs(img,handles_ax_data,handles_number_obj)


RGB = img;
if size(RGB,3)==3
   img = rgb2gray(img);
   RGB = imbinarize(img);
   RGB = imcomplement(RGB);
end

assignin('base','RGB',RGB)
bw = RGB;
[B2,L ,num , A] = bwboundaries(bw);
string1 = sprintf('%.1f',num);

blobMeasurements = regionprops(bw, 'all');
numberOfBlobs = size(blobMeasurements, 1);
hold on;

handles.number_obj = handles_number_obj;
handles.ax_original = handles_ax_data;

boundaries = bwboundaries(bw);
set(handles.number_obj,'String',string1);
numberOfBoundaries = size(num, 1);

axes(handles.ax_original)
textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
labelShiftX = -7;
blobECD = zeros(1, numberOfBlobs);
    for k = 1 : numberOfBlobs           % Loop through all blobs.
        % Find the mean of each blob.  (R2008a has a better way where you can pass the original image
        % directly into regionprops.  The way below works for all versions including earlier versions.)
        %thisBlobsPixels = blobMeasurements(k).PixelIdxList;  % Get list of pixels in current blob.
    % 	meanGL = mean(originalImage(thisBlobsPixels)); % Find mean intensity (in original image!)
    % 	meanGL2008a = blobMeasurements(k).MeanIntensity; % Mean again, but only for version >= R2008a

        blobArea = blobMeasurements(k).Area;		% Get area.
    % 	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
        blobCentroid = blobMeasurements(k).Centroid;		% Get centroid one at a time
    % 	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
        %fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k));
        %fprintf(2,'#%2d %11.1f \n', k, blobArea);
        % Put the "blob number" labels on the "boundaries" grayscale image.
        text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight',  'Bold','Color','c');
    end
hold off