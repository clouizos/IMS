function result = color_spaces(fileToConvert, color_space, show)
% color_spaces: Convert an RGB image to a different colorspace and 
%               visualize each of the channels. It takes two arguments,
%               fileToConvert and color_space.
%
%   fileToConvert : Takes the path of the RGB image.
%   color_space   : Choose the color space you want to convert to. 
%                   Available options are: 
%                       'opponent': for the opponent color space
%                       'rgb'     : for the normalized rgb color space
%                       'hsv'     : for the HSV color space
%
%   HSV uses the built-in function rgb2hsv().

im = imread(fileToConvert);
%original_fig = figure;
%set(original_fig, 'name', 'Original Image')
%imshow(im)

% get red, green and blue channels from the original image
R = im2double(im(:,:,1));
G = im2double(im(:,:,2));
B = im2double(im(:,:,3));

% R = im(:,:,1);
% G = im(:,:,2);
% B = im(:,:,3);

switch color_space
    % for the opponent color space
    case 'opponent'
        O1 = double(R - G)./sqrt(2);
        O2 = double(R + G - (2*B))./sqrt(6);
        O3 = double(R + G + B)./sqrt(3);
        if show == 1
            o1 = figure;
            set(o1, 'name', 'O1 channel for opponent color space');
            imshow(O1)
            o2 = figure;
            set(o2, 'name', 'O2 channel for opponent color space');
            imshow(O2)
            o3 = figure;
            set(o3, 'name', 'O3 channel for opponent color space');
            imshow(O3)
        end
        
        result = cat(3,O1,O2,O3);
        % uncomment in order to show the full image consisting
        % of three channels
%         im2 = cat(3, O1,O2,O3);
%         fig = figure;
%         set(fig, 'name', 'actual figure');
%         imshow(im2);
    
    % for the normalized rgb color space    
    case 'rgb'
        normalize = double(R + G + B);
        r = double(R)./normalize;
        g = double(G)./normalize;
        b = double(B)./normalize;
        
        if show == 1
            r_ = figure;
            set(r_, 'name', 'r channel for rgb color space');
            imshow(r)
            g_ = figure;
            set(g_, 'name', 'g channel for rgb color space');
            imshow(g)
            b_ = figure;
            set(b_, 'name', 'b channel for rgb color space');
            imshow(b)
        end
        % uncomment in order to show the full image consisting
        % of three channels
%         im2 = cat(3, r,g,b);
%         fig = figure;
%         set(fig, 'name', 'actual figure');
%         imshow(im2);
    
        result = cat(3,r,g,b);
    % for the HSV color space
    case 'hsv'
        HSV = rgb2hsv(im);
        
        if show == 1
            h = figure;
            set(h, 'name', 'hue channel for HSV color space');
            imshow(HSV(:,:,1));
            s = figure;
            set(s,'name','saturation channel for HSV color space');
            imshow(HSV(:,:,2));
            v = figure;
            set(v,'name','value channel for HSV color space');
            imshow(HSV(:,:,3));
        end
        result = HSV;
        % uncomment in order to show the full image consisting
        % of three channels
%         fig = figure;
%         set(fig, 'name', 'actual figure');
%         imshow(HSV);
    
    
    % if not a valid option
    otherwise
        disp('Not a valid color space. Available choices: opponent, rgb, hsv');
end