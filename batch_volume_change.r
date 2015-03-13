#Volume Change and Make Stereo###
#eb 01/28/15; ask Elika for help as needed####

#To run a section of code, highlight it with the mouse, and then press run up in the corner (or command+return on a mac)
#comment lines start with the # sign and running them doesn't do anything because they are just comments.

#first, install PraatR (h/t to Aaron Albin for making this library!)
#you only need to do this step once, if you've installed it before, you can just go on to the 'library' line below 
#(installing again won't make anything explode though)

install.packages(
  pkgs= "~/Desktop/praat/praat_workshop/PraatR",
  ### change the above directory to wherever you saved PraatR when you downloaded and upzipped it! [you only need to do this once]
  lib=R.home("library"), 
  repos = NULL,
  type="source")

#next, load the library
library("PraatR")

####### Where do you your audio files that are unnormalized live? ######
#first, make sure your computer is connected to ebergelson2014-1 where the audio files all live!

#this tells the script where your files are
FullPath = function(FileName){
  DataDirectory = "/Volumes/ebergelson-1/Desktop/seedlings_stimuli/temp_unnormalized/" ### CHECK THAT THIS IS WHERE THEY ARE
    return( paste(DataDirectory,FileName,sep="") )
}
# this tells the script to look for things in that same place you just set as the DataDirectory
setwd("/Volumes/ebergelson-1/Desktop/seedlings_stimuli/temp_unnormalized/")### CHECK THIS LINE EVERY TIME

# This saves the list of the filenames within Rs memory
# note: you need to have this be a folder with *only* .wav files in it, or you might need the commented out line below
FileList = list.files()
FileList # this will show you what the files are that you are about to change

#FileList <- FileList[substring(FileList,first=nchar(FileList)-3,last=nchar(FileList)) == ".wav"]#ignore this line

##########################################
## MAKING THE STEREO 72 DB FILES############
##########################################

####### Where will the stereo_rightsilent_72db files you make go? ######
#next, tell the computer where the new files it makes should go
# this should be the  temp_stereo_rightsilent_72db folder within seedlings_stimuli

# if you don't change this correctly you may overwrite your original recordings!#
FullPathNewFiles_rightsilent72db = function(FileName){
  DataDirectory = "/Volumes/ebergelson-1/Desktop/seedlings_stimuli/temp_stereo_rightsilent_72db/" ### CHECK THAT THIS IS WHERE THEY SHOULD GO
    return( paste(DataDirectory,FileName,sep="") )
}


#This loop goes through each file you've made that is stereo with one silent channel, in the folder you specified,
#and normalizes the volume to an average of 72db in the file
for(File in 1:length(FileList)){
  TargetFile <- FileList[File]
  praat("Scale intensity...", arguments=list(72),
        input=FullPath(TargetFile),
        output=FullPathNewFiles_rightsilent72db(TargetFile),
        filetype="WAV") 
}

#that's it! your new normalized stereo files now live in the folder you told them to go to above, go check 'em out!
#to make sure this worked, right-click on one of the new files, click 'open with praat'
#then click 'query->get intensity (dB)' and the window that pops up should say 72db (or 71.999)
#close praat and pat yourself on the back.

##########################################
## MAKING THE MONO 65 DB FILES############
##########################################

####### Where will the mono_65db files you make go? ######
# this should be the  temp_mono_65db folder within seedlings_stimuli

# if you don't change this correctly you may overwrite your original recordings!
FullPathNewFiles_mono65db = function(FileName){
  DataDirectory = "/Volumes/ebergelson-1/Desktop/seedlings_stimuli/temp_mono_65db/" ### CHECK THAT THIS IS WHERE THEY SHOULD GO
  return( paste(DataDirectory,FileName,sep="") )
}


#loop for making stereo and louder
for(File in 1:length(FileList)){
  TargetFile <- FileList[File]
  AudioFilename <- sub(TargetFile,pattern=".wav",replacement="_mono65db.wav")
  praat( "Convert to mono", input = FullPath(TargetFile),
         output=FullPathNewFiles_mono65db(AudioFilename), filetype="WAV", overwrite = T ) 
  praat("Scale intensity...", arguments=list(65),
        input=FullPathNewFiles_mono65db(AudioFilename),
        #output=FullPath(StereoFilename),
        output=FullPathNewFiles_mono65db(AudioFilename),
        filetype="WAV") 
}

#that's it! your new normalized mono 65db files now live in the folder you told them to go to above, go check 'em out!
#to make sure this worked, right-click on one of the new files, click 'open with praat'
#then click 'query->number of channels' and the window that pops up should say' 1 channel (mono)
#then click 'query->get intensity (dB)' and the window that pops up should say 65db (or 64.999)
#close praat and pat yourself on the back. and then follow the next steps in the wiki

#if you need something else done with the audio file, or if you get an error (e.g. make it mono, make it stereo in both channels, etc., ask Elika)
