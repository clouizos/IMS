function create_vocabulary(sample_images, voc_size, type)
% Function to create the vocabulary
% Arguments:
%     sample_images: how many images to use in order to create it
%     voc_size: how many visual words 
%     type: 'intensity', 'rgb', 'RGB', 'opponent', 'hsv'

% training sets
air_train = './data/airplanes_train/';
car_train = './data/cars_train/';
face_train = './data/faces_train/';
motor_train = './data/motorbikes_train/';

% get the filenames, same for every folder
dirInfo = dir(air_train); 
% remove directories
dirInfo = dirInfo(~[dirInfo.isdir]);

files = cell(size(dirInfo,1),1);
for K = 1:size(dirInfo,1)
  files{K} = dirInfo(K).name;
end

D = [];
for i=1:sample_images
    i
    % airplane
    if ~strcmp(type, 'RGB') && ~strcmp(type, 'rgb') && ~strcmp(type, 'opponent') && ~strcmp(type, 'hsv')
        im_air = imread(strcat(air_train,files{i}));
        if size(im_air,3) == 3 
            im_air = im2single(rgb2gray(im_air));
        else
            im_air = im2single(im_air);
        end
    else
        path = strcat(air_train,files{i});
    end
   
    if strcmp(type, 'intensity')
        [F_air,D_air] = vl_sift(im_air);
    elseif strcmp(type, 'dense')
        [F_air, D_air] = vl_dsift(im_air);
    else
        D_air = calc_sift_color(path, type);
    end
    
    % car
    if ~strcmp(type, 'RGB') && ~strcmp(type, 'rgb') && ~strcmp(type, 'opponent') && ~strcmp(type, 'hsv')
        im_car = imread(strcat(car_train,files{i}));
        if size(im_car,3) == 3 
            im_car = im2single(rgb2gray(im_car));
        else
            im_car = im2single(im_car);
        end
    else
        path = strcat(car_train,files{i});
    end
    if strcmp(type, 'intensity')
        [F_car,D_car] = vl_sift(im_car);
    elseif strcmp(type, 'dense')
        [F_car, D_car] = vl_dsift(im_car);
    else
        D_car = calc_sift_color(path,type);
    end
    
    % face
    if ~strcmp(type, 'RGB') && ~strcmp(type, 'rgb') && ~strcmp(type, 'opponent') && ~strcmp(type, 'hsv')
        im_face = imread(strcat(face_train,files{i}));
        if size(im_face,3) == 3 
            im_face = im2single(rgb2gray(im_face));
        else
            im_face = im2single(im_face);
        end
    else
        path = strcat(face_train, files{i});
    end
    if strcmp(type, 'intensity')
        [F_face,D_face] = vl_sift(im_face);
    elseif strcmp(type, 'dense')
        [F_face,D_face] = vl_dsift(im_face);
    else
        D_face = calc_sift_color(path, type);
    end
    
    % motorbike
    if ~strcmp(type, 'RGB') && ~strcmp(type, 'rgb') && ~strcmp(type, 'opponent') && ~strcmp(type, 'hsv')
        im_motor = imread(strcat(motor_train,files{i}));
        if size(im_motor,3) == 3 
            im_motor = im2single(rgb2gray(im_motor));
        else
            im_motor = im2single(im_motor);
        end
    else
        path = strcat(motor_train, files{i});
    end
    if strcmp(type, 'intensity')
        [F_motor,D_motor] = vl_sift(im_motor);
    elseif strcmp(type, 'dense')
        [F_motor,D_motor] = vl_sift(im_motor);
    else
        D_motor = calc_sift_color(path, type);
    end
    % construct the descriptor matrix
    D = [D; D_air';D_car';D_face';D_motor'];
end
size(D)

% disp('Finished parsing the descriptors. Starting MoG...')
% [means,cov,prior] = vl_gmm(double(D'),voc_size, 'verbose');
% voc = means;
% size(voc)
% obj = gmdistribution.fit(double(D),voc_size);
% voc = obj.mu;

disp('Finished parsing the descriptors. Starting k-means...')
[voc, A] = vl_kmeans(double(D'),voc_size,'verbose', 'algorithm','ann','MaxNumIterations', 100);
size(voc)

% save the vocabulary in a .mat file
s = strcat('./vocabularies/visual_vocabulary_',int2str(sample_images*4),'_',int2str(voc_size),'_',type,'.mat');
save(s,'voc');

end