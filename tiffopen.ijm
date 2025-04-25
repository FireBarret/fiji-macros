// Get folder of images
dir = getDirectory("Choose a folder");
list = getFileList(dir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")) {
        // Build full path
        path = dir + list[i];

        // Open with Bio-Formats without prompt
        run("Bio-Formats Importer", 
            "open=[" + path + "] color_mode=Default view=Hyperstack stack_order=XYCZT");
    }
}
