classdef BehaviorData < handle
%this class takes a matrix of roi data (each roi is one column, each frame
%is one row), rescales it, plots it, and then adds the matlab data from the
%BehaviorBox to it

%LOAD IN EXCEL FILE WITH ALL ROIS FIRST, format:
% 1 87 88 ...
% 2 82 91
% 3 89 90
% 4 88 90

%ALSO ADD IN THE BEHAVIOR DATA

%Then call

% b = VisualTwoPhotonBehavior;
    %parameters: roidata, y spacing of data for plot, second between each x
%data point, toggle if scaled to 100% (1 is yes)
% b.AddRoiDataAndScale(untitled, 1, 0.32, 1);
% b.AddBehaviorData(BehaviorData);
% b.PlotAll;


    properties
        ROI_data;
        Behavior_matrix;
        Percent_correct;
        %extracted from above
        Responses_correct;
        Responses_correct_x;
        Responses_wrong;
        Responses_wrong_x;
        Stimulus_left_x;
        Stimulus_left_y;
        Stimulus_right_x;
        Stimulus_right_y;
        Max_y;
        DateHeader;
                
        
    end
       
    
    methods
        
        
        
        
        function AddRoiDataAndScale(this , ROI_matrix_in, scale_value_offset, delta_value_x, normalize_to_100, Offset_for_sync)
            ROI_data_temp = [];
            %compensate for delay with trigger
            OFFSETDELAY = 0.01;
            %OFFSETDELAY = 0.252;
            % OFFSETDELAY = 0.14;
            %OFFSETDELAY = 0.07;
            %%0.01
            %for 256*128 scab the frame length is 0.297s
            %normalize them all to have 100 as max
            if normalize_to_100 == 1
                
                
                for column = 1:size(ROI_matrix_in,2)
                    %find max
                    max_signal = max(ROI_matrix_in(:,column));
                    %normalize to max
                    ROI_data_temp(:,column)=ROI_matrix_in(:,column)/max_signal;
                end
                
                 %update data 
                 ROI_matrix_in = ROI_data_temp;
                 ROI_data_temp = [];
            end
            
            
            %add offset to each value in column
            for i = 1:size(ROI_matrix_in,2)
                
                ROI_data_temp(:,i)=ROI_matrix_in(:,i)+scale_value_offset*i-scale_value_offset;
                
            end
            
            %chaange delta scaling of the x axis
            for i = 1:size(ROI_matrix_in,1)
                ROI_data_temp(i,1) = ((delta_value_x*i)-delta_value_x)/60+Offset_for_sync-OFFSETDELAY;
               % ROI_data_temp(i,1) = (delta_value_x*i-delta_value_x)/60;
            end
            
           %find highest value 
           this.Max_y = max(ROI_data_temp(:,size(ROI_matrix_in,2)));
           this.ROI_data = ROI_data_temp;
        end
        
        
       
        
        function AddBehaviorData(this, behavior_matrix_in)
            this.Behavior_matrix = behavior_matrix_in;
            this.Extract_correct_wrong();
            this.Extract_Stimulus_left_right();
        end
        
        
        
        function Extract_correct_wrong(this)
            %split data into separate correct/wrong vectors
            i = 1;
            MAX = this.Max_y;
            MIN = 0;
            
            %count all and create percent correct
            Percent_correct = 0;
            correct_count = 0;
            wrong_count = 0;
            %keep all values at 0 if there is no response. If there is one,
            %set it to max, then create a new x time point right after and
            %set y back to 0, so on the plot it is a straing vertical line
            
            %start at 0
            
            this.Responses_correct_x(end+1) = 0;
            this.Responses_correct(end+1) = MIN;
            this.Responses_wrong_x(end+1) = 0;
            this.Responses_wrong(end+1) = MIN;
            
            while this.Behavior_matrix(1,i) ~= 0
                
                %if correct
                if this.Behavior_matrix(2,i) == 0.8
                        
                        %create an extra entry right before in time to
                        %start low
                        this.Responses_correct_x(end+1) = this.Behavior_matrix(1,i)-0.000001;
                        this.Responses_correct(end+1) = MIN;
                        %raise to max
                        this.Responses_correct_x(end+1) = this.Behavior_matrix(1,i);
                        this.Responses_correct(end+1) = MAX;
                        %create an extra entry right after in time to lower
                        %back to min
                        this.Responses_correct_x(end+1) = this.Behavior_matrix(1,i)+0.000001;
                        this.Responses_correct(end+1) = MIN;
                       
                        correct_count = correct_count+1;
           
                %if wrong     
                elseif this.Behavior_matrix(2,i) == 0.5
                        %create an extra entry right before in time to
                        %start low
                        this.Responses_wrong_x(end+1) = this.Behavior_matrix(1,i)-0.000001;
                        this.Responses_wrong(end+1) = MIN;
                        %raise to max
                        this.Responses_wrong_x(end+1) = this.Behavior_matrix(1,i);
                        this.Responses_wrong(end+1) = MAX;
                        %create an extra entry right after in time to lower
                        %back to min
                        this.Responses_wrong_x(end+1) = this.Behavior_matrix(1,i)+0.000001;
                        this.Responses_wrong(end+1) = MIN;
                        wrong_count = wrong_count + 1;
                     
                end
                
                i = i+1;
            end
            
            this.Percent_correct = correct_count/(correct_count+wrong_count);
           
           
        end
            
         
        
        function Extract_Stimulus_left_right(this)
            %split data into separate left/right matrixes
            %to plot the data, use "patch" which draws a box bound to when
            %the stimulus is on. Patch uses two vectors, first is x = [x1,
            %x2, x3, x4], then each has a corresponding y coordinate y =
            %[y1, y2, y3, y4]. To plot a box starting at t0 to t1, having
            %the height starting at x0 to x1, use these:
            %patch_y = [min, min, max, max]
            %patch_x = [t0, t1, t1, t0]
            %(patch would get drawn starting at bottom left point, then
            %bottom right, then up to top right and left to top left.
            %store all these patch vectors in a vector (so a matrix total)
            %then iterate through the rows to plot.
            
                        
            MAX = this.Max_y;
            MIN = 0;
            patch_y = [0, 0, 0, 0];
            patch_x = [0, 0, 0, 0];
            
            %1 = left, 11/12 = right, -1 is close
            
            for i =1:length(this.Behavior_matrix(5,:))
                
                %if the ID for the stimulus matched left
                if this.Behavior_matrix(5,i) == 1
                    
                        %add current time to temp coordinates as start of
                        %patch. Usually each open gets followed by a close,
                        %so using +1 of i on the time vector should get the
                        %closing time, to make sure that it does, check,
                        %and if not, add it to the data
                        
                        %if current stim open ID is the last entrance,
                        %there is no closing event recorded, so add one
                        %right after.
                        if i == length(this.Behavior_matrix(5,:))
                            this.Behavior_matrix(4,i+1) = this.Behavior_matrix(4,i)+0.001;  
                        end
                        patch_x = [this.Behavior_matrix(4,i), this.Behavior_matrix(4,i+1), this.Behavior_matrix(4,i+1), this.Behavior_matrix(4,i)];
                        patch_y = [MIN, MIN, MAX, MAX];
                        
                        %add to matrix
                        
                        this.Stimulus_left_x(end+1,1:4)= patch_x;
                        this.Stimulus_left_y(end+1,1:4)= patch_y;
                        
                %or ID matched right, do same
                elseif this.Behavior_matrix(5,i) > 10
                        if i == length(this.Behavior_matrix(5,:))
                            this.Behavior_matrix(4,i+1) = this.Behavior_matrix(4,i)+0.001;  
                        end
                        patch_x = [this.Behavior_matrix(4,i), this.Behavior_matrix(4,i+1), this.Behavior_matrix(4,i+1), this.Behavior_matrix(4,i)];
                        patch_y = [MIN, MIN, MAX, MAX];
                        
                        this.Stimulus_right_x(end+1,1:4)= patch_x;
                        this.Stimulus_right_y(end+1,1:4)= patch_y;
                end
              
            
            end
           
        end
        
                
        
        function PlotAll(this)
            
            
            figure;
            this.PlotROIS;
            this.PlotResponses;
            this.PlotStimuli;
            
        end
        
        function PlotROIS(this)
            
            %plot all
            
            p = plot(this.ROI_data(:,1),this.ROI_data(:,2));
            set(p,'Color','black')
            for i = 3:size(this.ROI_data,2)
                hold on
                p = plot(this.ROI_data(:,1),this.ROI_data(:,i));
                set(p,'Color','black')
            end
            hold off
                       
        end
        
      
        
        function PlotResponses(this)
            hold on
            p1 = plot(this.Responses_correct_x, this.Responses_correct);
            set(p1,'Color','green','LineWidth',2)
            p2 = plot(this.Responses_wrong_x, this.Responses_wrong);
            set(p2,'Color','red','LineWidth',2)
            hold off
            
        end
        
         function PlotStimuli(this)
            
            %plot left, skip first 0 entry
            if size(this.Stimulus_left_x,1) > 1
                hold on
                for i = 2:size(this.Stimulus_left_x,1)
                    patch(this.Stimulus_left_x(i,:), this.Stimulus_left_y(i,:),'yellow', 'EdgeColor','none', 'FaceAlpha', 0.4)
                end
                hold off
            end
            
             %plot right, skip first 0 entry
            if size(this.Stimulus_right_x,1) > 1
                hold on
                for i = 2:size(this.Stimulus_right_x,1)
                    patch(this.Stimulus_right_x(i,:), this.Stimulus_right_y(i,:),'blue', 'EdgeColor','none','FaceAlpha', 0.2)
                end
                hold off
            end
            
         end
        
            %call default for quick plot
         function Default(this, ROI_data_In, BehaviorData_in)
            this.AddRoiDataAndScale(ROI_data_In, 1, 0.32, 1, 0.2);
            this.AddBehaviorData(BehaviorData_in);
            this.PlotAll; 
         end
        
         
         
    end
    
    methods(Static = true)
        
    end
   
end

