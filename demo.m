
clear all;clc;close all;
for datadir=["BSDS500","NYUv2"]

folder =fullfile('G:\Data',datadir);
savedir=fullfile("G:\Result"',datadir);
filename="CSRS";
file_list = dir(folder);
file_names = {file_list.name};
step=1;
% 去除"."和".." 
file_names = file_names(~strcmp(file_names, '.'));
file_names = file_names(~strcmp(file_names, '..'));
file_names = file_names(~strcmp(file_names, 'groundturth'));
file_names = file_names(~strcmp(file_names, 'Label'));
% 
% file_names = file_names(~strcmp(file_names, 'Clean')); 
% file_names = file_names(~strcmp(file_names, 'GA'));
% file_names = file_names(~strcmp(file_names, 'GM'));
% file_names = file_names(~strcmp(file_names, 'SP'));
% 打印剩余的文件名
for i = 1:numel(file_names)
%     disp(file_names{i});
    firstdir=(fullfile(folder,file_names{i}));
    sub_file_list = dir(firstdir);
    sub_file_names = {sub_file_list.name};
    sub_file_names = sub_file_names(~strcmp(sub_file_names, '.'));
    sub_file_names = sub_file_names(~strcmp(sub_file_names, '..'));
    % 
    % sub_file_names = sub_file_names(~strcmp(sub_file_names, '0.05'));
    % sub_file_names = sub_file_names(~strcmp(sub_file_names, '0.1'));
%     sub_file_names = sub_file_names(~strcmp(sub_file_names, '0.15'));
    % sub_file_names = sub_file_names(~strcmp(sub_file_names, '0.2'));
    % sub_file_names = sub_file_names(~strcmp(sub_file_names, '0.25'));
    % sub_file_names = sub_file_names(~strcmp(sub_file_names, '0.3'));


    for j = 1:numel(sub_file_names)
        seconddir=(fullfile(firstdir,sub_file_names{j}));
        inDir=seconddir;
        root=fullfile(savedir,file_names{i},sub_file_names{j});
        timeDir=fullfile(root,filename); 
%         disp(timeDir);
        if ~exist(timeDir,'dir')
            mkdir(timeDir)
        end
        iids = dir(fullfile(inDir,'*.jpg'));
        timefile=fullfile(timeDir,'Time.csv');
        fid = fopen(timefile, 'w');
        fprintf(fid,'%s,',filename);
        fclose(fid);
        for n=1:10
            matsaveDir=fullfile(root,filename,num2str(n*100), 'Label');
            imgsaveDir =fullfile(root,filename,num2str(n*100), 'Get_image');
            
            if ~exist(matsaveDir,'dir')
                mkdir(matsaveDir)
            end
            if ~exist(imgsaveDir,'dir')
                mkdir(imgsaveDir)
            end
            fprintf('%s  %s  %s\n',inDir,matsaveDir,imgsaveDir);
            meantime=zeros(1,numel(iids));
            parfor k = 1:numel(iids)
%             for k = 1:step:numel(iids)
              
                fname=iids(k).name(1:end-4);

                inFile = fullfile(inDir, strcat(iids(k).name(1:end-4), '.jpg'));
                obFile = fullfile(matsaveDir, strcat('\',fname,'.mat'));
                % if exist(obFile,'file')
                %     continue;
                % end

                tic;
                img = imread(inFile);
           


               [labels, numlabels]=CSRS(img,n*100);%numlabels is the same as number of superpixels(img, n*100, ratio);
               %fprintf('   %d',numlabels);
        
                meantime(k)= toc;
                obFile = fullfile(matsaveDir, strcat('\',fname,'.mat'));
                if exist(obFile,'file')
                    delete(obFile);
                end
                %     writematrix(labels,obFile);
                parsave(obFile,labels)
                superpixel_bound_name = fullfile(imgsaveDir, [fname, '.jpg']);
                if exist(superpixel_bound_name,'file')
                    delete(superpixel_bound_name);
                end
                Displaysuperpixels(labels,img,superpixel_bound_name);
               
            end

            fid = fopen(timefile, 'a');
            fprintf(fid,'%05.3f,',mean(meantime)*step);
            fclose(fid);

        end
    end

end
end

fprintf("运算结束")

function parsave(fname,labels)
   save(fname,"labels")
end

   


