// "BatchProcessFolders"
//
// This macro batch processes all the TIFF files in a folder and any
// subfolders in that folder. For other kinds of processing,
// edit the processFile() function at the end of this macro.

   requires("1.33s"); 
   dir = getDirectory("Choose a Directory ");
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   //print(count+" files processed");
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }

  function processFile(path) {
       if (endsWith(path, ".tif")) {
           open(path);
           //run("Brightness/Contrast...");
			run("Enhance Contrast", "saturated=0.35");
			//run("Median...");
			//run("Threshold...");
			setAutoThreshold("Moments dark stack");
			run("Set Measurements...", "area mean standard min fit feret's integrated median limit redirect=None decimal=4");
			run("Analyze Particles...", "size=2-Infinity circularity=0.8-1.00 display exclude clear include in_situ stack");
			saveAs("Results", path + ".txt");
           //save(path);
           close();
      }
  }