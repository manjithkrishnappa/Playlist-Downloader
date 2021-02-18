#/bin/sh

OPTIND=1

while getopts e:h option
    do
    case "${option}"
    in
    c) Extract=true;;
    h) HELP=true;;
    esac
done

if [ $HELP ]; then
    echo "-h Shows this help"
    echo "-c extracts the audio into seperate folder"
    exit
fi

propertiesFile="/home/pi/scripts/shell/FolderNames_Links.properties"
baseDir="/media/pi/cloud_data/Youtube_videos"
audio_baseDir="/media/pi/cloud_data/Music"

check_create_directory()
{
  dirPath=$1
  if [ -d "$dirPath" ]; then
        echo "Directory exist;"
    else
        echo "Directory does not exist; Creating"
        mkdir -p "$dirPath"
    fi
}

download_playlist()
{
    subDirName=$1
    playlistURL=$2
    echo "Going to dowload into $subDirName folder"
    echo "Playlist URL: $playlistURL"
    fullPath="$baseDir/$subDirName"
    echo "Full Path: $fullPath"
    check_create_directory $fullPath
    cd "$fullPath"
    pwd

    /usr/local/bin/youtube-dl -w -i -f bestvideo+bestaudio --max-downloads 100 "$playlistURL"

}

convert_videos_audio()
{
  subDirName=$1
  echo "Going to convert into audio: $subDirName folder"
  fullPath="$baseDir/$subDirName"
  audioFullPath="$audio_baseDir/$subDirName"
  check_create_directory $audioFullPath
  echo $fullPath
  cd "$fullPath"
  pwd
  for vid in *.mkv
  do
    echo $vid
    fileName="${vid%.*}"
    fileName=${fileName// /_};
    fullPathWithFile="$audioFullPath/$fileName.mp3"
    echo $fullPathWithFile
    ffmpeg -i "$vid" -q:a 0 -map a $fullPathWithFile
  done
}

if [ -f "$propertiesFile" ]
then
  echo "$propertiesFile found."

  while IFS='=' read -r subDirName playlistURL
  do
    download_playlist $subDirName $playlistURL
    if [ $Extract ]; then
   	 convert_videos_audio $subDirName
    fi
  done < "$propertiesFile"
else
  echo "$propertiesFile not found."
fi
