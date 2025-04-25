// Ask user for number of slices to use in Z projection
numberOfSlices = getNumber("Enter number of slices for Z projection", 7);

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

        // Set grayscale on the projected image
        Stack.setDisplayMode("grayscale");
    }
}