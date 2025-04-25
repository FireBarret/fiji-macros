// Ask user for the number of Z slices (stop value)
stopZ = getNumber("Enter the number of Z slices (stop value for Z-Projection):", 7);

// Get source directory from user
inputDir = getDirectory("Choose Source Directory ");
outputDir = inputDir + "Cropped_Grayscale_TIFF/";
File.makeDirectory(outputDir);

list = getFileList(inputDir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".czi")) {
        processCZI(inputDir, outputDir, list[i], stopZ);
    }
}

function processCZI(inputDir, outputDir, filename, stopZ) {
    fullPath = inputDir + filename;

    // Open .czi with Bio-Formats
    run("Bio-Formats Importer", 
        "open=[" + fullPath + "] color_mode=Default view=Hyperstack stack_order=XYCZT");

    // Store original title to close it later
    originalTitle = getTitle();

    // Max Intensity Z-Projection using user-defined stopZ
    run("Z Project...", "start=1 stop=" + stopZ + " projection=[Max Intensity]");

    // Close original full stack
    selectWindow(originalTitle);
    close();

    // Set grayscale view
    Stack.setDisplayMode("grayscale");

    // Prompt for manual crop
    run("ROI Manager...");
    roiManager("Show All");
    setTool("Rectangular");
    waitForUser("Select crop area");
    run("Crop");

    // Construct new filename
    baseName = replace(filename, ".czi", "");
    newName = baseName + " grayscale cropped.ome.tiff";
    savePath = outputDir + newName;

    // Save as OME-TIFF
    saveAs("OME-TIFF", savePath);

    // Close the cropped image
    close();
}