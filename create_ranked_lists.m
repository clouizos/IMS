function [ranked2, size_ones] = create_ranked_lists(predictions, write, voc_size, voc_samples, type, kernel)
air_test = './data/airplanes_test/';
car_test = './data/cars_test/';
face_test = './data/faces_test/';
motor_test = './data/motorbikes_test/';

ranked_air = strcat('./ranked_lists_',int2str(voc_size),'/ranked_airplanes/');
ranked_car = strcat('./ranked_lists_',int2str(voc_size),'/ranked_cars/');
ranked_face = strcat('./ranked_lists_',int2str(voc_size),'/ranked_faces/');
ranked_motor = strcat('./ranked_lists_',int2str(voc_size),'/ranked_motorbikes/');
% get the filenames, same for every folder
dirInfo = dir(air_test); 
% remove directories
dirInfo = dirInfo(~[dirInfo.isdir]);
disp('Creating ranked lists...')
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
    list2{count} = air_test;
    count = count + 1;
end

for i=1:size(files,1)
    list{count} = strcat(car_test, files{i});
    list2{count} = car_test;
    count = count + 1;
end

for i=1:size(files,1)
    list{count} = strcat(face_test, files{i});
    list2{count} = face_test;
    count = count + 1;
end

for i=1:size(files,1)
    list{count} = strcat(motor_test, files{i});
    list2{count} = motor_test;
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
%ranked = cell(4,200);
%ranked2 = cell(4,200);
size_ones = [];
for i=1:size(predictions,1)
    % sort them and create the ranked2 list which is for 
    % quantitave the evaluation
    s = ['classifier ' int2str(i) '...'];
    disp(s)
    [sort_pred,idx] = sort(predictions(i,:), 'descend'); 
    idx__ = idx(predictions(i,idx) > 0.5);
    length(idx__);
    %temp = list2(idx__);
    %temp(1)
    ranked2(i,:) = {list2(idx__)};
    % get only the positive predictions for the qualitative 
    % evaluation (writing the ranked images)
    
    %idx2 = find(predictions(i,:) > 0.5 ); %===we have to change this
    %idx2;
    %ranked(i,1:length(list(idx2))) = list(idx2);
    %ranked(i,1:length(list(idx__))) = list(idx__)
    ranked = list(idx__);
   
    size_ones = [size_ones;length(list(idx__))];
    
    if write == 1
        for j=1:length(list(idx__))%size(ranked,2)
            %im = imread(ranked{i,j});
            im = imread(ranked{j});
            iml = ranked{j};      %# A string
% fid = fopen(fName,'w');            %# Open the file
% if fid ~= -1
%   fprintf(fid,'%s\r\n',str);       %# Print the string
%   fclose(fid);                     %# Close the file
% end
            if i == 1
                % delete the previous rankings first
                if j == 1
                    delete(strcat(ranked_air,'*'))
                    fid1 = fopen(strcat('./ranked_lists_all/ranked_list_airplane_',int2str(voc_size),'_', int2str(voc_samples),'_', type,'_', kernel, '.txt'), 'w');
                end
                fprintf(fid1,'%s\n' ,iml);
                imwrite(im, strcat(ranked_air,int2str(j)),'JPEG');
            elseif i == 2
                if j == 1
                    delete(strcat(ranked_car,'*'))
                    fid2 = fopen(strcat('./ranked_lists_all/ranked_list_car_',int2str(voc_size),'_', int2str(voc_samples),'_', type,'_', kernel,'.txt'), 'w');
                end
                fprintf(fid2,'%s\n' ,iml);
                imwrite(im, strcat(ranked_car,int2str(j)),'JPEG');
            elseif i == 3
                if j == 1
                    delete(strcat(ranked_face,'*'))
                    fid3 = fopen(strcat('./ranked_lists_all/ranked_list_face_',int2str(voc_size),'_', int2str(voc_samples),'_', type,'_', kernel,'.txt'), 'w');
                end
                fprintf(fid3,'%s\n' ,iml);
                imwrite(im, strcat(ranked_face,int2str(j)),'JPEG');
            elseif i == 4
                if j == 1
                    delete(strcat(ranked_motor,'*'))
                    fid4 = fopen(strcat('./ranked_lists_all/ranked_list_motorbike_',int2str(voc_size),'_', int2str(voc_samples),'_', type,'_', kernel,'.txt'), 'w');
                end
                fprintf(fid4,'%s\n' ,iml);
                imwrite(im, strcat(ranked_motor,int2str(j)),'JPEG');
            end
        end
    end
end   

end

