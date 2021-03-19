#Base image
FROM python

#create a folder for our app
WORKDIR /app

#copy all the files
COPY . .

#run the application
CMD ["python3", "youtube_downloader.py"]