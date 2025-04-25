// Ask user for number of slices to use in Z projection
numberOfSlices = getNumber("Enter number of slices for Z projection", 7);

// Ask brightness settings
Dialog.create("Set Brightness for Each Channel (-1 to skip)");
Dialog.addNumber("Channel 1 Min:", -1);
Dialog.addNumber("Channel 1 Max:", -1);
Dialog.addNumber("Channel 2 Min:", -1);
Dialog.addNumber("Channel 2 Max:", -1);
Dialog.addNumber("Channel 3 Min:", -1);
Dialog.addNumber("Channel 3 Max:", -1);
Dialog.show();

c1Min = Dialog.getNumber();
c1Max = Dialog.getNumber();
c2Min = Dialog.getNumber();
c2Max = Dialog.getNumber();
c3Min = Dialog.getNumber();
c3Max = Dialog.getNumber();

// Helper function to safely set brightness
function safeSetMinMax(channel, minVal, maxVal, maxChannels) {
    if (channel <= maxChannels && minVal >= 0 && maxVal >= 0) {
        Stack.setChannel(channel);
        setMinAndMax(minVal, maxVal);
    }
}

// Get folder of images
dir = getDirectory("Choose a folder");
list = getFileList(dir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".czi") || endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")) {
        path = dir + list[i];

        // Open image based on extension
        if (endsWith(list[i], ".czi")) {
            run("Bio-Formats Importer", 
                "open=[" + path + "] color_mode=Default view=Hyperstack stack_order=XYCZT");
        } else {
            open(path); // Standard open for TIFFs
        }

        // Save original image title
        originalTitle = getTitle();

        // Z Projection
        run("Z Project...", "start=1 stop=" + numberOfSlices + " projection=[Max Intensity]");

        // Close original image
        selectWindow(originalTitle);
        close();

        // Set composite display mode
        Stack.setDisplayMode("composite");
        run("Apply LUT");

        // Detect how many channels
        maxChannels = Stack.getDimensions()[2];

        // Apply brightness
        safeSetMinMax(1, c1Min, c1Max, maxChannels);
        safeSetMinMax(2, c2Min, c2Max, maxChannels);
        safeSetMinMax(3, c3Min, c3Max, maxChannels);
    }
}