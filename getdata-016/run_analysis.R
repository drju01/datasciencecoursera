################
# run_analysis.R
################

# check if your working directory is the original directory with datasets
if (basename(getwd()) != "UCI HAR Dataset"){ 
	stop("You need to set your working directory to 'UCI HAR Dataset' where project data is located")
}

# get relevant packages if necessary
for (lib in c("data.table","plyr","tidyr")) {
	if(lib %in% rownames(installed.packages()) == FALSE){
		install.packages(lib)
	}
}

# load relevant packages
library(data.table)
library(tidyr)
library(plyr)

# read dictionaries
features <- fread("features.txt")
activity_labels <- fread("activity_labels.txt")

# create list to store test and train datasets
tSets <- c()

# iterate through test and train sets
for (tSet in c("test","train")){
	
	# read entire field as one field dataset
	x <- fread(paste(tSet,"/X_",tSet,".txt",sep=""),sep="\n",header=FALSE)
		
	# get number of fields in the main dataset
	nof <- nchar(gsub("[^,]","",gsub("[ ]+",",",head(x$V1,1))))
	
	# split the main dataset into separate fields (number calculated previously - nof)
	x_sep <- separate(x,V1,into = paste("V",0:nof,sep=""), sep="[ ]+")
	
	# remove first field(was empty)
	x_sep[,V0:=NULL]

	# set the main dataset column names in line with feature list
	setnames(x_sep,features$V2)
	
	# add set type attribute (either "test" or "train")
	x_type <- cbind(SetType=tSet,x_sep)
	
	# read activity dataset
	y <- fread(paste(tSet,"/y_",tSet,".txt",sep=""))
	# label activity dataset by merging with activity_labels dataset
	y_alab <- merge(y,activity_labels,by=c("V1","V1"))

	# append activity dataset (only labels) to the main dataset
	xy <- cbind(y_alab[,3,with=FALSE],x_type)
	# change activity column name to "Activity"
	setnames(xy,"V2","Activity")
	
	# read subject dataset
	subject <- fread(paste(tSet,"/subject_",tSet,".txt",sep=""))
	# append single field subject dataset, set column name to "Subject"
	xy_subj <- cbind(Subject=subject$V1,xy)
	
	# store the resultset
	tSets[[tSet]] <- xy_subj
}

# union 2 main datasets (test and train)
xy_full <- rbind(tSets[[1]],tSets[[2]])

# get indexes of necessary columns (descriptive attributes + mean() and std() measures)
cols <- grep(".*(SetType|Activity|Subject|mean\\(\\)|std\\(\\)).*",colnames(xy_full))

# select only columns as indicated in previous step
xy_filtd <- xy_full[,cols,with=FALSE]

# get indexes of measure columns (mean(), std())
measr_cols <- grep(".*(mean\\(\\)|std\\(\\)).*",colnames(xy_filtd))

# reshape dataset, all measure columns have been included in "variable", and their corresponding values in "value"
xy_meltd <- melt(xy_filtd,measure.vars=measr_cols)

# append XYZ axis attribute (for missing axis values)
xy_meltd$variable <- gsub("\\(\\)$","()-XYZ",xy_meltd$variable)

# split "variable" column into 3 fields, ie. Signal, Measure and Axis
xy_tidy <- separate(xy_meltd,variable,into = c("Signal","Measure","Axis"), sep="-")

# remove "()" from Measure name
xy_tidy$Measure <- gsub("\\(\\)","",xy_tidy$Measure)

# calculate average of measure values
xy_avg <- ddply(xy_tidy,.(Subject,Activity,SetType,Signal,Measure,Axis),summarize,MeasureValue=mean(as.numeric(value)))

# save dataset to file
write.table(xy_avg,file="xy_avg.txt",sep=",",row.names=FALSE)

