// Choose output directory
outputDir = getDirectory("Choose where to save JPEGs");

n = nImages();
for (i = 1; i <= n; i++) {
    selectImage(i);
    title = getTitle();

    // Try to extract base name (remove extension)
    if (endsWith(title, ".tif") || endsWith(title, ".tiff") || endsWith(title, ".czi"))
        base = substring(title, 0, lastIndexOf(title, "."));
    else
        base = title;

    // Get channel count
    Stack.getDimensions(width, height, channels, slices, frames);

    for (c = 1; c <= channels; c++) {
        Stack.setChannel(c);
        saveAs("Jpeg", outputDir + base + "-C" + c + ".jpg");
    }
}