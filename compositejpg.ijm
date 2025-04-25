// Get folder of images
dir = getDirectory("Choose a folder");
list = getFileList(dir);

// Create subfolder for JPEGs
jpegDir = dir + "jpeg" + File.separator;
File.makeDirectory(jpegDir);

// Ask user for brightness settings
Dialog.create("Set Brightness for Each Channel");
Dialog.addNumber("Channel 1 Min:", 385);
Dialog.addNumber("Channel 1 Max:", 65535);
Dialog.addNumber("Channel 2 Min:", 1366);
Dialog.addNumber("Channel 2 Max:", 32323);
Dialog.show();

c1Min = Dialog.getNumber();
c1Max = Dialog.getNumber();
c2Min = Dialog.getNumber();
c2Max = Dialog.getNumber();

// Helper function to strip extension
function stripExtension(filename) {
    dot = lastIndexOf(filename, ".");
    if (dot > 0) {
        return substring(filename, 0, dot);
    } else {
        return filename;
    }
}

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".czi") || endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")) {
        path = dir + list[i];

        // Open based on file type
        if (endsWith(list[i], ".czi")) {
            run("Bio-Formats Importer", 
                "open=[" + path + "] color_mode=Default view=Hyperstack stack_order=XYCZT");
        } else {
            open(path); // Use standard ImageJ open for TIFFs
        }

        // Set to Composite and apply LUT
        Stack.setDisplayMode("composite");
        run("Apply LUT");

        // Adjust brightness for channel 1
        Stack.setChannel(1);
        setMinAndMax(c1Min, c1Max);

        // Adjust brightness for channel 2
        Stack.setChannel(2);
        setMinAndMax(c2Min, c2Max);

        // Save JPEG
        name = stripExtension(list[i]);
        saveAs("Jpeg", jpegDir + name + ".jpg");

        // Close image
        close();
    }
}