function [label_lists,ranked2] = create_ranked_lists(predictions, write)
air_test = './data/airplanes_test/';
car_test = './data/cars_test/';
face_test = './data/faces_test/';
motor_test = './data/motorbikes_test/';

ranked_air = './ranked_lists/ranked_airplanes/';
ranked_car = './ranked_lists/ranked_cars/';
ranked_face = './ranked_lists/ranked_faces/';
ranked_motor = './ranked_lists/ranked_motorbikes/';

% get the filenames, same for every folder
dirInfo = dir(air_test); 
% remove directories
dirInfo = dirInfo(~[dirInfo.isdir]);

files = cell(size(dirInfo,1),1);
for K = 1:size(dirInfo,1)
  files{K} = dirInfo(K).name;
end

list = cell(1,200);
list2 = cell(1,200);
% create the list to be sorted
count = 1;
for i=1:size(files,1)
    list{count} = strcat(air_test,files{i});
    list2{count} = strcat(air_test);
    count = count + 1;
end

for i=1:size(files,1)
    list{count} = strcat(car_test, files{i});
    list2{count} = strcat(car_test);
    count = count + 1;
end

for i=1:size(files,1)
    list{count} = strcat(face_test, files{i});
    list2{count} = strcat(face_test);
    count = count + 1;
end

for i=1:size(files,1)
    list{count} = strcat(motor_test, files{i});
    list2{count} = strcat(motor_test);
    count = count + 1;
end
% create the label list
label_lists = cell(4,200);
% correct airplane list
label_lists(1,:) = list2;
% correct cars list
label_lists(2,1:50) = list2(51:100);
label_lists(2,51:100) = list2(1:50);
label_lists(2,101:end) = list2(101:end);
% correct faces list
label_lists(3,1:50) = list2(101:150);
label_lists(3,51:150) = list2(1:100);
label_lists(3,151:200) = list2(151:200);
% correct motorbikes list
label_lists(4,1:50) = list2(151:200);
label_lists(4,51:end) = list2(1:150);

% create the ranked lists here
ranked = cell(4,200);
ranked2 = cell(4,200);
for i=1:size(predictions,1)
    [sort_pred,idx] = sort(predictions(i,:), 'descend');
    ranked(i,:) = list(idx);
    ranked2(i,:) = list2(idx);
    if write == 1
        for j=1:size(ranked,2)
            im = imread(ranked{i,j});
            if i == 1
                imwrite(im, strcat(ranked_air,int2str(j)),'JPEG');
            elseif i == 2
                imwrite(im, strcat(ranked_car,int2str(j)),'JPEG');
            elseif i == 3
                imwrite(im, strcat(ranked_face,int2str(j)),'JPEG');
            elseif i == 4
                imwrite(im, strcat(ranked_motor,int2str(j)),'JPEG');
            end
        end
    end
end   

end

