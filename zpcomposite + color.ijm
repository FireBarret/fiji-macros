// Ask user for number of slices to use in Z projection
numberOfSlices = getNumber("Enter number of slices for Z projection", 7);

// Ask user for brightness settings for 3 channels
Dialog.create("Set Brightness for Each Channel");
Dialog.addNumber("Channel 1 Min:", 385);
Dialog.addNumber("Channel 1 Max:", 65535);
Dialog.addNumber("Channel 2 Min:", 1366);
Dialog.addNumber("Channel 2 Max:", 32323);
Dialog.addNumber("Channel 3 Min:", 0);
Dialog.addNumber("Channel 3 Max:", 20000);
Dialog.show();

c1Min = Dialog.getNumber();
c1Max = Dialog.getNumber();
c2Min = Dialog.getNumber();
c2Max = Dialog.getNumber();
c3Min = Dialog.getNumber();
c3Max = Dialog.getNumber();

// Get folder of images
dir = getDirectory("Choose a folder");
list = getFileList(dir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".czi") || endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")) {
        // Build full path
        path = dir + list[i];

        // Open with Bio-Formats without prompt
        run("Bio-Formats Importer", 
            "open=[" + path + "] color_mode=Default view=Hyperstack stack_order=XYCZT");

        // Save original image title
        originalTitle = getTitle();

        // Z Project using user-defined number of slices
        run("Z Project...", "start=1 stop=" + numberOfSlices + " projection=[Max Intensity]");

        // Close the original image
        selectWindow(originalTitle);
        close();

        // Set to Composite mode and apply LUTs
        Stack.setDisplayMode("composite");
        run("Apply LUT");

        // Adjust brightness for each channel
        Stack.setChannel(1);
        setMinAndMax(c1Min, c1Max);

        Stack.setChannel(2);
        setMinAndMax(c2Min, c2Max);

        Stack.setChannel(3);
        setMinAndMax(c3Min, c3Max);
    }
}