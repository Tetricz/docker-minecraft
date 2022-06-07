#!/bin/bash
cd /tmp
mkdir -p /minecraft/updater
mkdir -p /minecraft/mods
mkdir -p /tmp/res
#remove files that could cause issues from previous boot
if [ -f /tmp/uptodate ]
then
    rm -f /tmp/uptodate
    rm -f /tmp/res/*
fi
#copy default modlist if not found in folder
if [ ! -f "/minecraft/updater/modlist" ]
then
    cp /modlist /minecraft/updater/modlist
    touch /minecraft/updater/modkeep
fi

#get response from modrinth for mods
while IFS= read -r line
do
    readarray -t strarr <<< "$line"
    curl -s "https://api.modrinth.com/v2/project/${line}/version" -o "/tmp/res/${line}.res"
done < /minecraft/updater/modlist
#copy mods to tmp folder for hashchecking, this should be in ram
cp /minecraft/mods/* /tmp/
cp /minecraft/updater/modkeep /tmp/uptodate
for file in $(ls /tmp/res/*res);
do
    #takes api response from modrinth and parses
    filename=$(cat $file | jq -cr '[.[] | {(.loaders[]): .game_versions[], filename: .files[].filename, url: .files[].url, sha512: .files[].hashes.sha512} | select(.fabric == "1.19")] | .[0].filename')
    url=$(cat $file | jq -cr '[.[] | {(.loaders[]): .game_versions[], filename: .files[].filename, url: .files[].url, sha512: .files[].hashes.sha512} | select(.fabric == "1.19")] | .[0].url')
    recorded_hash=$(cat $file | jq -cr '[.[] | {(.loaders[]): .game_versions[], filename: .files[].filename, url: .files[].url, sha512: .files[].hashes.sha512} | select(.fabric == "1.19")] | .[0].sha512')

    #create sha512 file
    echo "${recorded_hash}  ${filename}" > $filename.sha512
    #markdown new files, so that we can remove the old ones
    echo "/minecraft/mods/$filename" >> uptodate
    
    #check if current file is up to date
    sha512sum -c $filename.sha512
    #download new files and mv into mods folder
    if [ $? -eq 0 ]; then
        echo "$filename is up to date"
        rm /tmp/$filename
    else
        echo "Updating..."
        curl -L "${url}" --output "${filename}"
        if [ $? -eq 0 ]; then
            echo "$filename is updated"
            mv /tmp/$filename /minecraft/mods/$filename
        else
            echo "Update failed"
        fi
    fi
done;

#delete out of date modes
for i in $(ls /minecraft/mods/*jar);
do
    if ! grep -qxFe "$i" /tmp/uptodate; then
        echo "Deleting: $i"
        rm "$i"
    fi
done

#add a file to say that this version has been copied
if [ ! -f "/1.19" ]
then
    cp /fabric-server-launch.jar /minecraft/fabric-server-launch.jar
    cp /server.jar /minecraft/server.jar
    touch /1.19
fi
#fabric and launch server copy check in case they were deleted
if [ ! -f "/minecraft/fabric-server-launch.jar" ]
then
    cp /fabric-server-launch.jar /minecraft/fabric-server-launch.jar
    cp /server.jar /minecraft/server.jar
fi
cd /minecraft
java -Xmx${MEMORY} -Xms${MEMORY} -jar fabric-server-launch.jar nogui