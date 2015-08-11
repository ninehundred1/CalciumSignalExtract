####CalciumSignalExtract 
A Matlab GUI that automatically segments fluorescence image stacks into ROIs based on differential morphology and fluorescence activity of the individual cells. The time course data of each ROI gets extracted and plotted.

*Overview*
![MATLAB Calcium Signal Extract GUI]( http://i.imgur.com/OimWqag.jpg)

Different parameters can be set to match the nature of the data in terms of signal strength, expected size of cells and the kind of fluorescent probe (single flourophore vs ratiometric). External Data from behavioral experiments and sensory stimuli can be integrated to analyze the imaging data for task and stimulus dependent neuronal events.
Below is a guide on the settings. 

*Make sure to check the very bottom for troubleshooting instructions, as there is a need to play around with the settings depending on your data!*



---
####Workflow:
1. **Load the .tiff stack data** (either individually or a whole folder of stacks as a batch)
   this will create:
   
	-a .txt file with the data over time for each ROI extracted
	
	-an image file of all the ROIs overlaid on the raw image
	
	-a summary of the GUI with an image of the ROIs and all their data plotted
	
	-a correlation matrix comparing each ROI with each other for signal correlation
	
2. **Assess the accuracy of the extraction**, adjust if necessary and rerun with different parameters
3. Optionally add data of other events during the imaging (behavioral responses, application of a stimulu
s, etc).



---
####ROI segmentation output:
The ***RoiImage.jpg*** looks as below and is also, in a lower resolution, displayed in the GUI, along the all the individually plotted ROIs and a correlation matrix (in the matrix, white is the maximum scaled correlation of 1, black the minimum of 0).

*ROI image output file*
![MATLAB Calcium Signal Extract ROI image]( http://i.imgur.com/r2aBLu4.jpg)



---
####User guide:
Below is the menu with the buttons labeled.

*GUI menu*
![MATLAB Calcium Signal Extract Menu]( http://i.imgur.com/p6aGDsw.png)

To extract a single tiff stack file, click **Single File(1)** and select the file. It will start extracting using the current settings. It will save the extracted ROI data as a ***Roi.txt*** file in the same folder, an image of the data stack with the ROIs overlaid as a ***RoiImage.jpg*** file and an image of the whole ROI as ***Roi.jpg*** as a quick summary.

The left image (A) in the ROI image output file is a projection of the input data. The second image (B) is the different areas that got separated out using either watershed or center pixel segmentation. These get transformed into ROIs depending on the setting (see below), turning into the third image. The third image (C) shows the actual ROIs that are measured and their number. The fourth image (D) is a cross correlation of each ROI with each other ROI, where white means high correlation in the data, black means low.

To batch extract a folder, click **Folder(2)** and it will go through all the files in the folder looking for tiff stacks. 
The process can be stopped clicking **STOP after this step(3)**, which will complete the current process and stop thereafter.
To load already extracted data, click **LoadROI.txt(4)**, which will request a .txt file to load (the same files it generates above will work, otherwise see below for the required format). 


Then click **Plot(5)** to display the data.

To load an already previously generated image (the one generated above, or also other images) click **Load ROI image (6)** to select an image.
You can also add data that is external to the imaging stack but contains information about stimuli onset and duration or behavioral events of the animal. If you want to add behavior or stimulus ID data, click **Load Behavior (7)**. See below for the format required.

In the example at the very beginning you can see behavior and stimulus data added to the extracted signal plots. The onset and end of a stimulus presentation (green field) and the mice response (red correct, green wrong) are displayed on top of the responses and stimulus and choice depended calcium signals can easily be read off.

Once you have plotted everything you can save the current window by clicking **Save In Path (8)**, which will save in the path of the data loaded. You can also export the data as plotted into the Matlab workspace by clicking **Export to workspace (9)**.

The parameters for the ROI extraction can be set on the left. **Max size ROI (10)** indicated the maximum pixel number a ROI can be. If you want to include or exclude larger areas from the segmented image (B), change this value. If you set it to a large value, almost all segment from B gets transformed into a ROI in C and gets measured. If you want to only include the small areas from B, decrease the Max size ROI value.
**Min size ROI (11)** is the same as max size, just on the lower end. To exclude small areas, increase the value and vice versa.
**Skip frames (12)** ignores the number of frames indicated from the beginning. If your image brightness is lower in the first few frames, you can ignore those for the segmentation.
**% threshold(13)** is the amount of change over baseline of when pixels are used for segmentation. 0.25 means if a certain pixel changed intensity anywhere in the data to 25% above the average of that pixel over the whole stack, it gets included for segmentation. If you expect signals to be high (100%), you can set this value higher to exclude noise. If your signal is low (10%) you need to lower this to less than (10%), or the pixels showing the signal will not get included, but that might also include more noise, that also crossed that threshold.
**Temp smooth (14)** is the number of frames the data gets smoothed to measure the threshold mentioned above. If you choose 3, three frames in the data will be averaged and the resulting smoothed data will be used to look if a pixel crossed a threshold as explained above. This smooth will remove shot noise from the data,  which is usually fluctuating in between single frames. The higher you set this number the clearer the extraction will be, but it will also average your signal, thereby lowering the peak. If your signals have a slow time course, you can set it higher.

The **average method (15)** defines how your image is averaged before segmentation.  
Correlate uses a method described [here](http://labrigger.com/blog/2013/06/13/local-cross-corr-images/), where pixels are kept if they correlate in their fluorescence changes (as the activity of larger cells), and discarded if they randomly change independently (as random shot noise). The second method is a mean average of the stack.
The segmentation is either via a watershed, or an extend center pixel approach. If you have strong activity across the whole frame (as with high neuropil activity), it might be better to use the mean average method, as otherwise the whole image will be highlighted, without any clear change for segmentation.

If you use a light stimulus, it is possible for light contamination to enter your objective and cause artifacts, as seen below (noted in the square form regular peaks that correspond to the light being on, and then off again in the bottom graph below. Also note that the whole frame is chosen as one ROI in blue, with a few random ROIs in the bottom right. Also note how all ROIs are correlated in activity completely, as they all contain the same light contamination (see correlation matrix top right below).

*Before BG substraction*
![MATLAB Calcium Signal Extract BG](http://i.imgur.com/8FTH0ya.jpg)

To remove light contamination, use **subtract BG (17)** for either x and y. If you are using a light stimulus, it likely has a sharp start and end. This average goes through every line in x (or y (**18**)) removed outliers from the mean of each line across the stack(one mean value for frame 1, one for 2, etc) subtracts that mean value from the same line of each frame. 
The **BG threshold (19)** defines how the cutoff of what an outlier of the mean is. The higher, the more outliers get removed, but if too high, an accurate mean is not guaranteed. 

Below is the same data and same settings as above, just with the BG substraction enabled (arrow on the left), note the correlation matrix on the right showing different correlations of the individual cells.

*After BG substraction*
![MATLAB Calcium Signal Extract BG removed]( http://i.imgur.com/v83v0eA.jpg)

If your data is ratiometric (CFP/YFP), tick the box **ratiometric data (20)**. Your data needs to start with a CFP frame, if it starts with a YFP, you can delete the first frame of your data.

Once the data is plotted, you can change the appearance.
**Time step x (21)** defines the spacing between each frame in seconds, as defined by your frame rate of imaging.
**ROI Y space (22)** is the spacing between each ROI on the graph. 1 means 100%. Change the values and click plot to update.
**Ylim(23/24)** and **xlim (25/26)** sets the limits of your plot in y and in x. Auto means it takes the limits of your data.
**Max and Min ROI# (27/28)** plot sets which ROIs to display. If set to 2 for min and 10 for max it will only show ROIs 2 to 10 and excluded everything else. Auto will show the max (or min).
**Scale to 1 (29)** will normalize your data so they all will have the same height on the graph, independent of how large the signal peaks are.
If your signal is very weak, this might lead to large artifacts.
**Plot in window (30)** will show the data in a Matlab figure outside the GUI.
**Annotate (31)** adds ROI numbers and a calibration bar to the plot.

The current settings can be saved by clicking **save settings (32)**, or the previously saved settings can be loaded by **load settings (33)**.
To restore to default settings, click **restore settings (34)**.


####HINTS AND TIPS:
For these steps, it is easier to open the ***RoiImage.jpg*** file generated and saved in the folder of the data instead of the GUI, as it has a better resolution.
The process of the ROI extraction involves two steps, **first segmentation the stack into areas**, which is shown in image B, the **second step is to then convert the areas from image B into  
ROIs in image C**.

**TIPS FOR STEP 1**
If image B is not matching the outlines of cells visible in image A, as seen below, try changing the %threshold.

*Adjusting threshold for closer shape matching*
![MATLAB Calcium Signal Extract ROI1](http://i.imgur.com/5WFrg1F.png)

*If the area extracted in Image B does not match the cell outline in Image A (but is a much larger area), try increasing the threshold*

If the areas are too large around a cell, increase the %threshold. if a cell is not included in an area, lower the %threshold.
If you want to extract only the bright signals, keep the threshold just below those response levels. You can rerun the extraction a few times to get a feel.
Sometimes cells are dimmer than others and if they are dimmer than the background, excluding the background by a higher %threshold will also exclude those dim cells. In that case, try to reduce the background.
If your data is noisy it might also make it harder to segment. Incease the Temp Smooth to smooth out the data an remove background noise.
You can also increase the value for BG threshold (if subtract BG is ticked) to further exclude random noise. 
Currently only cell body extraction is supported. If you data does not contain cell bodies that change in fluorescence, a successful segmentation is unlikely.


**TIPS FOR STEP2**
If the areas in Image B look ok (matching the outlines of Image A), but are not chosen as ROIS in image B, as shown below, it usually means the size is not set correct.

*Adjusting ROI sizes to exclude large and small ROIs*
![MATLAB Calcium Signal Extract ROI2](http://i.imgur.com/SBQCklq.png)

*If large areas in Image B get converted to ROIs in Image C, lower the max ROI size to exclude those areas in B from being transformed into ROIs.*

If small areas in Image B are not outlines as ROIS in image C, lower the min size ROI value. In the same way, if large areas that are not cells are marked as a ROI and you want to exclude thos, lower the max size ROI number (see asterisk in bottom right image).

**Make sure your data is not containing a lot of motion artifacts, that that also distorts the ROIs and the data.**
(A motion removal step might be added later).
 
**TIP FOR RATIOMETRIC DATA**
Ratiometric analysis has not yet been implemented too well, but updates will follow. For now, it is probably better to use mean as the average method and set the %threshold very low. Also, the BG substraction in x and y might lead to large artifacts.
I will work on this function more once I have better data to try it out on. Keep checking for updates on this.

**If the extraction stops without anything further happening, usually no ROIs could be extracted (if the last image displayed is all black, in which case, try lowering the %threshold) or everything got segmented into one ROI (if the last image displayed has a red overlay, in which case try setting %threshold higher).**

####FORMAT OF EXTERNAL DATA

If you want to add ROI data that has not been generated in this GUI, use the format of a ***tab delimited .txt*** file. 

The top row should include the ROI number as a header, then each row is the data for each ROI.

| 1        | 2           | 3  | ...|
| ------------- |:-------------:| -----:|-----:|
| 47      | 175 | 101 | ... |
| 49      | 174      |  99| ... |
| 48       | 172      |   98 | ... |
| 49       | 170      |   97 | ... |
| ...       | ...      |   ... | ... |



If you want to add event data (such as the start and end of a stimulus display or behavioral choices of an animal), you need to load a ***.mat*** file with the following format:
The first row of the matrix containes the time of a behavioral response in minutes.
The second row contains the kind of behavioral response (here, the number 0.8 means correct choice, 0.5 means wrong choice, 0.2 means timeout).
The third row is used to indicate the current difficulty level, a parameter that is not used here, so you can leave row 3 empty.
Row 4 is the timepoint of a stimulus event (which can be different to the mouse response events, so it does have its own time data), in minutes.
Row 5 is the stimulus event. Here the number 12 means the stimulus is turned on at the right side, the number 1 means a stimulus on the left side, and number -1 means the stimulus turned off (this number is the same for left and right side).
For the example below, the first two rows mean the mouse made a correct decision (0.8 in row 2) at 0.18 minutes (0.18 in row 1), followed by a wrong decision (0.5) at 0.27 minutes and so on.
A stimulus on the left side (1 in row 5) was turned on at 0.9 minutes (0.9 in row 4), and turned off (-1) at 0.187 minutes. It was followed by a right stimulus (12) that was turned off (-1) again after.


**DO NOT INCLUDE THE FIRST ROW(Row1, ...)**

Row1|Row2|Row3|Row4|Row5|
| ------------- |:-------------:| -----:|-----:|-----:|
| 0.18        | 0.27   | 0.39  |0.44|...|
| 0.8     | 0.5 | 0.2 | 0.8 |...|
| 0      | 0      |  0| 0 |...|
| 0.9       | 0.187   |   0.268 | 0.274 |...|
| 1      | -1     |  12 |-1 |...|


###To install
Download all files (click Download ZIP on the right), unzip and copy them into your Current Folder path in Matlab. Then in the Matlab command window type
```MATLAB
CalciumSignalExtractGUI;
```

All else via the buttons inside the GUI.

emails to:
- <fuschro@gmail.com>
