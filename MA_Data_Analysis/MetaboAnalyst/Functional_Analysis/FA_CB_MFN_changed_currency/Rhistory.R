# PID of current job: 929936
mSet<-InitDataObjects("mass_all", "mummichog", FALSE, 150)
mSet<-SetPeakFormat(mSet, "rmp")
mSet<-UpdateInstrumentParameters(mSet, 3.0, "mixed", "yes", 0.02);
mSet<-Read.PeakListData(mSet, "Replacing_with_your_file_path");
mSet<-SanityCheckMummichogData(mSet)
curr.vec <- c("Water (C00001)","Proton (C00080)","Oxygen (C00007)","Pyrophosphate (C00013)","Phosphate (C00009)","Carbon dioxide (C00011)")
mSet<-Setup.MapData(mSet, curr.vec);
mSet<-PerformCurrencyMapping(mSet)
add.vec <- c("M+H [1+]","M-H2O+H [1+]","M-H [1-]","M-H2O-H [1-]")
mSet<-Setup.AdductData(mSet, add.vec);
mSet<-PerformAdductMapping(mSet, "mixed")
mSet<-SetPeakEnrichMethod(mSet, "mum", "v2")
mSet<-SetMummichogPval(mSet, 1.0E-5)
mSet<-PerformPSEA(mSet, "hsa_mfn", "current", 3 , 100)
mSet<-PlotPeaks2Paths(mSet, "peaks_to_paths_0_", "png", 150, width=NA)
mSet<-PlotPeaks2Paths(mSet, "peaks_to_paths_0_", "png", 300, width=NA)
