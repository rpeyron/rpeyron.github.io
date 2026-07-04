# Very simple script to remove file whose name is not used in all the site

# Usage:
#  step 1: sh remove-unused-files.sh > unused-files
#  step 2: sh unused-files
#  step 3: find . -name '*.orig' -delete
#  
#  find . -type d -empty -delete


FOLDER=files
DEST_FOLDER=files-unused

find $FOLDER -type f  | while read FILE
do
    FILENAME_WITHEXT=`basename "$FILE"`
    FILENAME=${FILENAME_WITHEXT%.*};
    #echo Searching $FILENAME
    #grep -R -I --exclude-dir=$FOLDER --exclude-dir=vendor  "$FILENAME" .
    if ! grep -q -I -r --exclude-dir=vendor --exclude-dir=_site --exclude-dir=.jekyll-cache  -F "$FILENAME" .
    then
        echo "# File not referenced : $FILENAME"
        #echo rm "$FILE"
        DEST_FILE_FOLDER=$DEST_FOLDER/$( dirname "$FILE" )
        echo mkdir -p \"$DEST_FILE_FOLDER\" \; mv \"$FILE\" \"$DEST_FOLDER/$FILE\"
    fi
done

# Note: will keep source images for -123x456
# Identify with -\d{3,4}x\d{3,4}
