classdef ROIExtractionMain  < handle
    %ROIExtractionMain Extracts ROIs of 3d matrixes based on shape/activity
    
    %  Loads a tiff stack, cross correlates pixel activities, segments ROIs
    %  (watershed of extent center pixel), registers rois in image, extacts
    %  each rois timecourse and cross correlates each roi
    
    properties
        min_size;
        max_size;
        skip_beginning;
        binary_threshold;
        method;
        stack_in_raw;
        ratio_stack_raw;
        current_filename;
        file_list;
        path_list;
        window_size;
        average_method;
        main_gui;
        
    end
    
    methods
        
        function obj = ROIExtractionMain(Minsize, Maxsize, method_av, Skipbeginning, BinaryThreshold, temp_smooth, method, main_gui_in)
            % class constructor is reading stack in
            if nargin>0
                obj.max_size = Maxsize;
                obj.min_size = Minsize;
                obj.average_method = method_av;
                obj.skip_beginning = Skipbeginning;
                obj.binary_threshold = BinaryThreshold;
                obj.window_size = temp_smooth;
                obj.method = method;
                obj.main_gui = main_gui_in;
            else
                obj.max_size = 700;
                obj.min_size = 40;
                obj.method = 1;
                obj.skip_beginning = 110;
                obj.binary_threshold = 0.5;
                obj.window_size = 3;
                obj.average_method = 1;
            end
            
        end
        
        
        function [ROI_Data_out Filename_current] = extractSingleFile(obj, handles, file_path)
            disp('            ----**START**----    ');
            disp(['    ----**',datestr(now),'**----    ']);
            
            set(handles.text1,'String', 'Loading data..');
            pause(0.01);
            
            try
                %   read stack
                if nargin > 2
                    [obj.stack_in_raw, obj.current_filename] = ReadTiffStack_ROIExtraction(file_path);
                else
                    [obj.stack_in_raw, obj.current_filename] = ReadTiffStack_ROIExtraction;
                    
                end
                
                
            catch err
                disp('no file selected');
               set(handles.text1,'String', 'no file selected');
                pause(0.01);
                
            end
            
            %show file name
            [pathstr,name,ext] = fileparts(obj.current_filename);
            set(handles.text20,'String', name);
            pause(0.01);
            
            is_ratio = get(handles.checkbox5,'Value');
            
            
            ROI_Data_out = obj.doExtract(obj.stack_in_raw, obj.current_filename, obj.average_method, obj.min_size, obj.max_size, obj.skip_beginning, obj.binary_threshold, obj.window_size, handles, obj.method, is_ratio);
            
            set(handles.text1,'String', 'Done');
            pause(0.01);
            Filename_current = obj.current_filename;
            disp(['    ----**',datestr(now),'**----    ']);
            disp('            ----**DONE**----    ');
            disp('               ');
            
        end
        
        
        function [ROI_Data_out Filename_current] = extractFolder(obj, handles, file_list, path_list)
            disp('               ');
            disp('            ----**START**----    ');
            disp(['    ----**',datestr(now),'**----    ']);
            if nargin > 2
                path_list = path_list;
                file_list = file_list;
                
            else
                %get directory and files from user
                try
                    [file_list, path_list] = ROIExtractionMain.ReadImageFilesFromFolder();
               catch err
                    disp('no folder selected');
                    %disp(err.message);
                    set(handles.text1,'String', 'no folder selected');
                    pause(0.01);
                    rethrow(err);
               end
            end
            
            
            
            start_t = clock;
            time_average = 0;
            set(handles.text1,'String', 'Loading data..');
            pause(0.01);
            is_ratio = get(handles.checkbox5,'Value');
            
            for i = 1:length(file_list)
                
                
                %try read stack
                try
                    
                    [obj.stack_in_raw, obj.current_filename] = ReadTiffStack_ROIExtraction(char(path_list(i)));
                    
                    %check if stack
                    if size(obj.stack_in_raw,3)<2
                        err_string = ['File ',char(file_list(i)),' is not a stack and was ignored'];
                        disp(err_string);
                        set(handles.text1,'String', err_string);
                        pause(0.01);
                        disp('****');
                        continue; %go to next iteration
                    end
                    
                    
                    %show file name
                    [pathstr,name,ext] = fileparts(file_list{i});
                    set(handles.text20,'String', name);
                    pause(0.01);
                    
                    %use whole path as save name to save in folder of origin
                    obj.current_filename = char(path_list(i));
                    ROI_Data_out = obj.doExtract(obj.stack_in_raw, obj.current_filename, obj.average_method,obj.min_size, obj.max_size,obj.skip_beginning, obj.binary_threshold, obj.window_size, handles, obj.method, is_ratio);
                    Filename_current = obj.current_filename;
                    disp(['    ----****----    ']);
                catch err
                    err_string = ['File ',char(file_list(i)),' is not a tiff file and was ignored'];
                    if strcmp(err.message,'STOPPED')
                        err_string = err.message;
                    end
                    disp(err_string);
                    set(handles.text1,'String', err_string);
                    pause(0.01);
                    
                    %pass error on to main
                    rethrow;
                    % break;
                end
                
                %show files remaining
                completed_files = floor(i/length(file_list)*100);
                diplstring = ['Files Completed: ',num2str(completed_files), '%'];
                set(handles.text1,'String', diplstring);
                diplstringButton = ['folder(',num2str(completed_files), '%)'];
                set(handles.pushbutton8,'String', diplstringButton);
                pause(0.01);
                disp(diplstring);
                
                %show time remaining
                time_ = etime(clock, start_t);
                time_average = time_average+time_;
                start_t = clock;
                time_remaining =floor(((time_average/i)*length(file_list)-i*(time_average/i))/60);
                diplstring = ['Time Remaining:  ',num2str(time_remaining), 'min'];
                disp(diplstring);
                
            end
            
            disp(['    ----**',datestr(now),'**----    ']);
            disp('            ----**DONE**----    ');
            disp('               ');
            
        end
        
        
        
        function  [ROI_Data_out] = doExtract(obj, stack_in_raw, current_filename, average_method, min_size, max_size, skip_beginning, level, window_size, handles, method, is_ratio)
            
            
            %if rationmetric, take the ratio first
            if is_ratio == 1
                %first deinterleave
                frame_stepsize = 2;
                raw_dataCh0 =  stack_in_raw(:,:, 1 : frame_stepsize : end);
                raw_dataCh1 =  stack_in_raw(:,:, 2:frame_stepsize : end);
                %make sure length of both channels is the same
                if size(raw_dataCh0,3) > size(raw_dataCh1,3)
                    raw_dataCh0 = raw_dataCh0(:,:,1:end-1);
                end
                if size(raw_dataCh0,3) < size(raw_dataCh1,3)
                    raw_dataCh0 = raw_dataCh1(:,:,1:end-1);
                end
                
                %if still don't match, throw exception
                if size(raw_dataCh0,3) ~= size(raw_dataCh1,3)
                    error('Cannot de-interleave')
                end
                
                %then divide
                obj.ratio_stack_raw = raw_dataCh1./raw_dataCh0;
                stack_in_raw = obj.ratio_stack_raw;
            end
            
            
            %do line background substraction X
            if get(handles.checkbox3,'Value') == 1
                outlier_threshold = str2num(get(handles.edit11,'String'));
                stack_in_raw = ROIExtractionMain.LineBG(stack_in_raw, outlier_threshold);
            end
            
            %check if user aborted
            if get(handles.togglebutton1,'Value') == 1
                error('STOPPED');
            end
            
            %do line background substraction Y
            if get(handles.checkbox4,'Value') == 1
                outlier_threshold = str2num(get(handles.edit11,'String'));
                stack_in_raw = ROIExtractionMain.ColumnBG(stack_in_raw, outlier_threshold);
            end
            
            %check if user aborted
            if get(handles.togglebutton1,'Value') == 1
                error('STOPPED');
            end
            
            
            
            %stretch image to square if not
            stack_in_raw = ROIExtractionMain.stretchToSquare(stack_in_raw);
            
            %check if user aborted
            if get(handles.togglebutton1,'Value') == 1
                error('STOPPED');
            end
            
            %smooth median xy (for segmentation only, don't smooth data)
            stack_in = ROIExtractionMain.medianSmoothPixel(stack_in_raw);
            
            %smooth temporal (for segmentation only, don't smooth data)
            stack_in = ROIExtractionMain.temporalSmooth(stack_in, window_size);
            
            %check if stack has enough slices to skip beginning
            num_slices = size(stack_in,3);
            if skip_beginning > num_slices
                skip_beginning = 1;
            end
            
            if average_method == 2
                %form correlation for averageImage
                set(handles.text1,'String', 'Cross Correlating..');
                pause(0.01);
                corr2 = CrossCorrImage_ROIExtraction(stack_in(:,:,skip_beginning:num_slices));
                
            else
                %just take mean of whole image
                set(handles.text1,'String', 'Mean averaging..');
                disp('Mean averaging image.. ');
                pause(0.01);
                corr2 = mean(stack_in(:,:,skip_beginning:num_slices),3);
                
                %normalize ratio to threshold
                if is_ratio == 1
                    corr2 = corr2-1;
                end
                
            end
            
            
            
            %check if user aborted
            if get(handles.togglebutton1,'Value') == 1
                error('STOPPED');
            end
            
            i_eq = corr2;
            
            %plot just the average image
            temp = figure();
            subaxis(1,4,1,'sh',0,'sv',0,'MR',0, 'ML', 0, 'MT', 0, 'MB', 0, 'PaddingTop', 0, 'PaddingBottom', 0, 'PaddingLeft', 0, 'PaddingRight', 0);
            imshow(i_eq, 'border', 'tight');
            hold on
            
            %plot color ROIS
            subaxis(1,4,2,'sh',0,'sv',0,'MR',0, 'ML', 0, 'MT', 0, 'MB', 0, 'PaddingTop', 0, 'PaddingBottom', 0, 'PaddingLeft', 0, 'PaddingRight', 0);
            imshow(corr2, 'border', 'tight');
            hold on
            pause(0.01);
            
            %extract ROIs
            if method == 1
                %WATERSHED
                set(handles.text1,'String', 'Measuring ROIS (watershed)..');
                pause(0.01);
                BW3 = ROIExtractionMain.watershedSegmentation(i_eq, min_size, level);
            else
                %EXTEND CENTER PIXEL
                set(handles.text1,'String', 'Measuring ROIS (extend center)..');
                pause(0.01);
                BW3 = ROIExtractionMain.extendPixelSegmentation(i_eq);
            end
            
            %check if user aborted
            if get(handles.togglebutton1,'Value') == 1
                error('STOPPED');
            end
            
            
            %segment into individual areas which get a label and border
            labeledImage = bwlabel(BW3, 8);
            
            %make color for plot
            coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
            
            %overlay on plot
            ih = imshow( coloredLabels);
            set( ih, 'AlphaData', 0.4 );
            
            % Extract all areas from above
            ROIareas = regionprops(labeledImage, corr2, 'all');
            
            %get borders of all ROIs
            boundaries = bwboundaries(BW3);
            
            %remove ROIS with certain characteristics
            %-too large
            i_roi = 1;
            counter = 1;
            
            while i_roi < size(ROIareas, 1)+1
                
                if ROIareas(i_roi).Area < max_size
                    %copy only smaller
                    ROIareas_selected(counter,1) = ROIareas(i_roi);
                    boundaries_selected (counter,1) = boundaries(i_roi);
                    counter = counter + 1;
                end
                
                i_roi = i_roi+1;
            end
            
            %stop if no rois found
            if ~exist('ROIareas_selected')
                error('STOPPED, No ROIs could be extracted, try different settings');
            end
            
            
            ROIareas = ROIareas_selected;
            boundaries = boundaries_selected;
            
            %count of rois
            numberOfRois = size(ROIareas, 1);
            
            %plot outlines of ROIS over original image
            subaxis(1,4,3,'sh',0,'sv',0,'MR',0, 'ML', 0, 'MT', 0, 'MB', 0, 'PaddingTop', 0, 'PaddingBottom', 0, 'PaddingLeft', 0, 'PaddingRight', 0);
            imshow(corr2, 'border', 'tight');
            RoiImages = gcf;
            axis image;
            hold on;
            
            numberOfBoundaries = size(boundaries, 1);
            for k = 1 : numberOfBoundaries
                thisBoundary = boundaries{k};
                plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 1);
            end
            hold off;
            
            %now display in other function
            All_Roi_data = ROIExtractionMain.measureAllRois(stack_in_raw,numberOfRois, ROIareas);
            
            %cross correlate all ROIs
            set(handles.text1,'String', 'Cross Correlate ROIS..');
            pause(0.01);
            corr_matrix = ROIExtractionMain.CreateCrossCorrMatrix(All_Roi_data);
            
            %display correlation matrix
            subaxis(1,4,4,'sh',0,'sv',0,'MR',0, 'ML', 0, 'MT', 0, 'MB', 0, 'PaddingTop', 0, 'PaddingBottom', 0.029, 'PaddingLeft', 0.029, 'PaddingRight', 0);
            imshow(corr_matrix,[0.9 1]);
            %colormap(jet);
            axis on;
            
            set(RoiImages, 'Units', 'Normalized', 'OuterPosition', [0.1 0.2 0.71 0.4]);
            set(gcf,'color','w');
            
            %grab a copy of the ROI image for display in GUI
            ROI_frame = getframe(RoiImages);
            
            %show ROI image in GUI
            axes(handles.axes2)
            image(ROI_frame.cdata);
            set(handles.axes2,'YTickLabel',[]);
            set(handles.axes2,'XTickLabel',[]);
            %plot roi data
            y_spacing = 0.5;
            x_spacing = 0.297;
            do_normalize = 1;
            offset_for_sync = 0.01;
            
            %create data object for plot
            PlotObject = BehaviorData;
            %add ROI data and scale and normalize to behavior data
            PlotObject.AddRoiDataAndScale(All_Roi_data, y_spacing, x_spacing, do_normalize, offset_for_sync);
            %calculate Behavior data (not in yet)
            %PlotObject.AddBehaviorData(globaldata.BehaviorData_in.BehaviorData);
            
            ROIExtractionMain.plotAllRois(PlotObject, handles);
            
            ROI_Data_out = PlotObject.ROI_data;
            
            %save image
            set(RoiImages,'PaperPositionMode','auto');
            set(RoiImages,'InvertHardcopy','off');
            %remove extention
            [pathstr,name,ext] = fileparts(current_filename);
            saveasname = [pathstr,filesep,name,'_RoiImage','.jpg'];
            print (RoiImages, '-dbmp', '-r250', saveasname);
            
            
            %save data
            saveasname = [pathstr,filesep,name,'_RoiData','.txt'];
            dlmwrite(saveasname,All_Roi_data,'delimiter','\t');
            
            %save gui window
            saveasname = [pathstr,filesep,name,'_GUI','.jpg'];
            % set(gcf,'color','w');
            
            set(obj.main_gui,'PaperPositionMode','auto');
            set(obj.main_gui,'InvertHardcopy','off');
            
            print ('-dbmp', '-r250', saveasname);
            disp(['saved: ',saveasname]);
            
            
            
            %close figs if open
            try
                close(temp);
                close(handles.plotRois);
            end
            
            %check if user aborted
            if get(handles.togglebutton1,'Value') == 1
                error('STOPPED');
            end
            
            
        end
        
    end
    
    
    methods ( Static=true )
        
        function [current_stack] = showStack(obj)
            current_stack = obj.stack_in_raw;
        end
        
        
        
        
        function stack_in_raw = stretchToSquare(stack_in_raw)
            in_dimensions = size(stack_in_raw);
            if in_dimensions(1) ~= in_dimensions(2)
                stack_in_raw = imresize(stack_in_raw, [in_dimensions(2), in_dimensions(2)]);
            end
        end
        
        
        function stack_in_raw_out = medianSmoothPixel(stack_in_raw)
            %median smooth pixel noise
            in_dimensions = size(stack_in_raw);
            stack_in_raw_out = zeros(in_dimensions(1),in_dimensions(2),in_dimensions(3));
            
            for i=1:size(stack_in_raw,3);
                stack_in_raw_out(:,:,i) = medfilt2(stack_in_raw(:,:,i),[1 1]);
            end
        end
        
        
        function stack_in_raw_out = temporalSmooth(stack_in_raw, window_size)
            
            [y_dim, x_dim, slices] = size(stack_in_raw);
            
            %preallocate
            stack_in_raw_out = zeros(y_dim, x_dim, slices);
            
            for i = 1:size(stack_in_raw,3)-1
                
                %make sure you are not running out of bounds at end
                if i+window_size > size(stack_in_raw, 3)
                    
                    window_size = window_size-1;
                    
                end
                
                stack_in_raw_out(:,:,i) =  mean(stack_in_raw(:,:,i:(i+window_size)),3);
                
            end
            
        end
        
        
        
        function plotAllRois(PlotObject, handles)
            
            %plot ROIS
            axes(handles.axes1);
            
            handles.plotRois = plot(PlotObject.ROI_data(:,1),PlotObject.ROI_data(:,2));
            set(handles.plotRois,'Color','black')
            for i = 3:size(PlotObject.ROI_data,2)
                hold on
                handles.plotRois = plot(PlotObject.ROI_data(:,1),PlotObject.ROI_data(:,i));
                set(handles.plotRois,'Color','black')
            end
            
            %get max for plot
            ymax =  max(PlotObject.ROI_data(:,size(PlotObject.ROI_data,2)));
            xmax = max(PlotObject.ROI_data(:,(1)));
            
            ylim([0 ymax]);
            xlim([0 xmax]);
            
            hold off
        end
        
        
        function  stack_in_raw = LineBG(stack_in_raw, outlier_threshold)
            
            %for each frame, take the average for each line
            %then substract that average value of all frames of each line from each line in each frame
            num_lines = size(stack_in_raw,1);
            num_pixels = size(stack_in_raw,2);
            for current_line = 1:num_lines
                %take average of whole current line for each frame
                mean1 = trimmean(stack_in_raw(current_line,:,:), outlier_threshold);
                %copy that value for as many pixels there are in each line
                mean_length_of_fram = repmat(mean1,1,num_pixels);
                %take those values and substract from data
                stack_in_raw(current_line,:,:) = double(stack_in_raw(current_line,1:num_pixels,:)) - mean_length_of_fram(1,1:num_pixels,:);
            end
            
        end
        
        
        function  stack_in_raw = ColumnBG(stack_in_raw, outlier_threshold)
            
            %for each frame, take the average for each line
            %then substract that average value of all frames of each line from each line in each frame
            num_lines = size(stack_in_raw,2);
            num_pixels = size(stack_in_raw,1);
            for current_line = 1:num_lines
                %take average of whole current line for each frame
                mean1 = trimmean(stack_in_raw(:,current_line,:), outlier_threshold);
                %copy that value for as many pixels there are in each line
                mean_length_of_fram = repmat(mean1,num_pixels,1);
                %take those values and substract from data
                stack_in_raw(:,current_line,:) = double(stack_in_raw(1:num_pixels,current_line,:)) - mean_length_of_fram(1:num_pixels,1,:);
            end
            
        end
        
        
        function corr_matrix = CreateCrossCorrMatrix(All_Roi_data)
            
            dim = size(All_Roi_data);
            textprogressbar('Cross Corr ROIs:  ');
            %cross correlate each ROI with each other and group to form a 2d
            %correlation matrix
            corr_matrix = zeros(dim(2),dim(2));
            
            %go through all, ignore legend
            for i = 2:dim(2)
                textprogressbar((i/dim(2)*100));
                
                for ii = 2:i
                    rCROSS = max(xcorr(All_Roi_data(2:dim(1),i),All_Roi_data(2:dim(1),ii),'coeff'));
                    corr_matrix(i, ii) = rCROSS;
                end
            end
            textprogressbar(' - done');
        end
        
        
        function [All_Roi_data] = measureAllRois(stack_in_raw,numberOfRois, ROIareas)
            % Used to control size of labels put atop the image.
            textFontSize = 14;
            % Used to align the labels in the centers of ROIs.
            labelShiftX = -4;
            
            %store all rois in cell array (allows different lengths vectors)
            All_Roi_coordinates{1} = 0;
            
            %make first colum index
            All_Roi_data = zeros(length(stack_in_raw)+1, numberOfRois+1);
            All_Roi_data(:,1) =1:length(stack_in_raw)+1;
            All_Roi_data(1,:) = 1:numberOfRois+1;
            
            % Loop over all ROIs
            textprogressbar('Measuring ROIs:   ');
            for k = 1 : numberOfRois           % Loop through all ROIs and get data
                
                RoiCoordinates = ROIareas(k).PixelList;  % Get list of pixels in current blob and save in array
                All_Roi_coordinates{k}=RoiCoordinates;
                textprogressbar((k/numberOfRois*100));
                
                
                %get data for each pixel coordinates current ROI
                for current_slice = 1:size(stack_in_raw,3)
                    y = ROIareas(k,1).PixelList(:,1);
                    x = ROIareas(k,1).PixelList(:,2);
                    pixels_mean = mean(mean( impixel(stack_in_raw(:,:,current_slice),y ,x)));
                    All_Roi_data(current_slice+1, k+1) = pixels_mean;
                end
                
                %label ROIS in image
                Centroid = ROIareas(k).Centroid;		% Get centroid one at a time
                %add labels into image
                text(Centroid(1) + labelShiftX, Centroid(2), num2str(k),'Color','y', 'FontSize',  textFontSize, 'FontWeight', 'Bold');
            end
            
            textprogressbar(' - done');
            
        end
        
        
        function [BW3] = watershedSegmentation(i_eq, min_size, level)
            %threshold
            %auto, but use manual
            %level = graythresh(i_eq);
            BW = im2bw(i_eq,level);
            %fill holes
            bw2 = ~bwareaopen(~BW, 10);
            %create distance to center map
            D = -bwdist(~BW);
            %watershed
            Ld = watershed(D);
            %use the watershed lines to create borders
            bw2 = BW;
            bw2(Ld == 0) = 0;
            %remove all rois smaller than area threshold
            BW3temp = bwareaopen(bw2, min_size);
            %fill holes inside ROIS
            BW3= imfill(BW3temp,'holes');
        end
        
        
        function [BW3] = extendPixelSegmentation(i_eq)
            %extend the maximal pixel
            BW3 = imextendedmax(i_eq, 0.25);
        end
        
        function [file_list, path_list] = ReadImageFilesFromFolder
            
            %ask user for folder
            d = uigetdir('C:\Users\','Select a folder containing images');
            files = dir(fullfile(d, '*.tif*'));
            file_list{length(files)} = '';
            path_list{length(files)} = '';
            for i = 1:length(files)
                path_list{i} = [d,'\',files(i).name];
                file_list{i} = [files(i).name];
            end
            
        end
    end
    
end

