// Ask user for the number of Z slices (stop number)
stopZ = getNumber("Enter the number of Z slices (stop value):", 7);

// Prompt the user with a file picker (just like File > Open...)
path = File.openDialog("Choose a .czi file");

// Open the file using Bio-Formats without dialog
run("Bio-Formats Importer", 
    "open=[" + path + "] color_mode=Default view=Hyperstack stack_order=XYCZT");

// Save original title
originalTitle = getTitle();

// Z Project using the user-defined stopZ value (start from Z=1)
run("Z Project...", "start=1 stop=" + stopZ + " projection=[Max Intensity]");

// Close original image
selectWindow(originalTitle);
close();

// Set the projection image to grayscale mode
projTitle = "MAX_" + originalTitle;
selectWindow(projTitle);
Stack.setDisplayMode("grayscale");