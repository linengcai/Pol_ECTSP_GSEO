function output_img = overlay_change_map(img, CM)
    % Overlay change map edges on the original image
    % img: Original image (grayscale or RGB)
    % CM: Binary change map (1 indicates change, 0 indicates no change)
    % output_img: Image with red edges overlaid on change regions
    
    % Compute edges of change regions
    edges = bwperim(CM);
    
    % Convert grayscale to RGB if necessary
    if size(img, 3) == 1
        img = repmat(img, [1, 1, 3]);
    end
    
    % Create a copy of the image for output
    output_img = img;
    
    % Set edge pixels to red (255,0,0)
    output_img(:,:,1) = output_img(:,:,1) + uint8(edges) * 255; % Red channel
    output_img(:,:,2) = output_img(:,:,2) .* uint8(~edges); % Zero out Green channel
    output_img(:,:,3) = output_img(:,:,3) .* uint8(~edges); % Zero out Blue channel
    
    % Ensure values are within valid range (0-255)
    output_img = uint8(min(output_img, 255));
    
    % Display the result
%     imshow(output_img);
end