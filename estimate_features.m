function features = estimate_features(num_samples, type, type_s, voc_size, voc_samples, reg, vis)
% Function to estimate the features given a vocabulary
% Arguments:
%     num_samples: how many samples do you wanna transform to features
%     type: 'train' or 'test'
%     type_s: 'intensity', 'rgb', 'RGB', 'opponent', 'hsv'
%     voc_size: size of the vocabulary to read
%     reg: rank of the regularizing norm, (usually = 2)
%     vis: Choose if you want to visualize the histograms for each image
%          (default off)

close all;
%voc_size = 400;
% parse the vocabulary
if nargin == 6
    vis = 0;
end

s = strcat('./vocabularies/visual_vocabulary_',int2str(voc_samples),'_',int2str(voc_size),'_',type_s,'.mat');
voc_ = load(s);
% voc has integers here, need to investigate
voc = voc_.voc';
if strcmp(type,'train')
    air_train = './data/airplanes_train/';
    car_train = './data/cars_train/';
    face_train = './data/faces_train/';
    motor_train = './data/motorbikes_train/';
elseif strcmp(type, 'test')
    air_train = './data/airplanes_test/';
    car_train = './data/cars_test/';
    face_train = './data/faces_test/';
    motor_train = './data/motorbikes_test/';
end

% get the filenames, same for every folder
dirInfo = dir(air_train); 
% remove directories
dirInfo = dirInfo(~[dirInfo.isdir]);

files = cell(size(dirInfo,1),1);
for K = 1:size(dirInfo,1)
  files{K} = dirInfo(K).name;
end

%features = zeros(num_samples*4,voc_size);
features = [];
count = 1;
if strcmp(type, 'train')
    %ii = 251:250+num_samples;
    ii = voc_samples/4 + 1:voc_samples/4 + num_samples;
else
    ii = 1:num_samples;
end

% 1 = airplanes
% 2 = cars
% 3 = faces
% 4 = motorbikes

for i=ii
    count
    % airplane
    if ~strcmp(type_s, 'RGB') && ~strcmp(type_s, 'rgb') && ~strcmp(type_s, 'opponent') && ~strcmp(type_s, 'hsv')
        im_air = imread(strcat(air_train,files{i}));
        if size(im_air,3) == 3 
            im_air = im2single(rgb2gray(im_air));
        else
            im_air = im2single(im_air);
        end
    else
        path = strcat(air_train,files{i});
    end
    if strcmp(type_s, 'intensity')
        [F_air,D_air] = vl_sift(im_air);
    elseif strcmp(type_s, 'dense')
        [F_air, D_air] = vl_dsift(im_air);
    else
        D_air = calc_sift_color(path, type_s);
    end
    % estimate the features from the vocabulary
    [d,I] = pdist2(voc, double(D_air'), 'euclidean', 'Smallest', 1);
    [elems, cent] = hist(I,voc_size);
    features(count,:) = [elems/norm(elems,reg) 1];
    %features(count,:) = elems/norm(elems,reg);
    if vis == 1
        figure(1)
        bar(cent, features(count,1:end - 1))
    end
    count = count+1;
end
disp('finished for airplanes.')
for i=ii
    count
    % car
    try
        if ~strcmp(type_s, 'RGB') && ~strcmp(type_s, 'rgb') && ~strcmp(type_s, 'opponent')&& ~strcmp(type_s, 'hsv')
            im_car = imread(strcat(car_train,files{i}));
            if size(im_car,3) == 3 
                im_car = im2single(rgb2gray(im_car));
            else
                im_car = im2single(im_car);
            end
        else
            path = strcat(car_train,files{i});
        end
        if strcmp(type_s,'intensity')
            [F_car,D_car] = vl_sift(im_car);
        elseif strcmp(type_s, 'dense')
            [F_car, D_car] = vl_dsift(im_car);
        else
            D_car = calc_sift_color(path,type_s);
        end
        [d,I] = pdist2(voc, double(D_car'), 'euclidean', 'Smallest', 1);
        [elems, cent] = hist(I,voc_size);
        features(count,:) = [elems/norm(elems,reg) 2];
%         features(count,:) = elems/norm(elems,reg);
        if vis == 1
            figure(2)
            bar(cent, features(count,1:end - 1))
        end
        count = count+1;
    catch err
        disp('maximum cars')
        break
    end
end
disp('finished for cars.')
for i=ii
    count
    % face
    try
        if ~strcmp(type_s, 'RGB') && ~strcmp(type_s, 'rgb') && ~strcmp(type_s, 'opponent')&& ~strcmp(type_s, 'hsv')
            im_face = imread(strcat(face_train,files{i}));
            if size(im_face,3) == 3 
                im_face = im2single(rgb2gray(im_face));
            else
                im_face = im2single(im_face);
            end
        else
            path = strcat(face_train, files{i});
        end
        if strcmp(type_s, 'intensity')
            [F_face,D_face] = vl_sift(im_face);
        elseif strcmp(type_s, 'dense');
            [F_face, D_face] = vl_dsift(im_face);
        else
            D_face = calc_sift_color(path,type_s);
        end
        [d,I] = pdist2(voc, double(D_face'), 'euclidean', 'Smallest', 1);
        [elems, cent] = hist(I,voc_size);
        features(count,:) = [elems/sum(elems,reg) 3];
%         features(count,:) = elems/norm(elems,reg);
        if vis == 1
            figure(3)
            bar(cent, features(count,1:end - 1))
        end
        count = count+1;
    catch err
        disp('maximum faces')
        break
    end
end
disp('finished for faces.')
for i=ii
    count
    % motorbike
    if ~strcmp(type_s, 'RGB') && ~strcmp(type_s, 'rgb') && ~strcmp(type_s, 'opponent')&& ~strcmp(type_s, 'hsv')
        im_motor = imread(strcat(motor_train,files{i}));
        if size(im_motor,3) == 3 
            im_motor = im2single(rgb2gray(im_motor));
        else
            im_motor = im2single(im_motor);
        end
    else
        path = strcat(motor_train,files{i});
    end
    if strcmp(type_s, 'intensity')
        [F_motor,D_motor] = vl_sift(im_motor);
    elseif strcmp(type_s,'dense')
        [F_motor,D_motor] = vl_dsift(im_motor);
    else
        D_motor = calc_sift_color(path,type_s);
    end
    [d,I] = pdist2(voc, double(D_motor'), 'euclidean', 'Smallest', 1);
    [elems, cent] = hist(I,voc_size);
    features(count,:) = [elems/norm(elems,reg) 4];
%     features(count,:) = elems/norm(elems,reg);
    if vis == 1
        figure(4)
        bar(cent, features(count,1:end - 1))
    end
%     features(count,end + 1) = 4;
    count = count+1;
  
end
disp('finished for motobikes.')

size(features)

% save the features in a .mat file
if strcmp(type, 'train')
    s = strcat('./features/features_',int2str(voc_size),'_',int2str(voc_samples),'_',type_s,'.mat');
    save(s,'features');
else
    s = strcat('./features/features_test_',int2str(voc_size),'_',int2str(voc_samples),'_',type_s,'.mat');
    save(s,'features');
end


end