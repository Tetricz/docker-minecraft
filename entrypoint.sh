#!/bin/bash
cd /tmp
mkdir -p /minecraft/updater
mkdir -p /minecraft/mods
mkdir -p /tmp/res
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
    filename=$(cat $file | jq -cr '[.[] | {(.loaders[]): .game_versions[], filename: .files[].filename, url: .files[].url, sha512: .files[].hashes.sha512} | select(.fabric == "1.18.2")] | .[0].filename')
    url=$(cat $file | jq -cr '[.[] | {(.loaders[]): .game_versions[], filename: .files[].filename, url: .files[].url, sha512: .files[].hashes.sha512} | select(.fabric == "1.18.2")] | .[0].url')
    recorded_hash=$(cat $file | jq -cr '[.[] | {(.loaders[]): .game_versions[], filename: .files[].filename, url: .files[].url, sha512: .files[].hashes.sha512} | select(.fabric == "1.18.2")] | .[0].sha512')

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

#fabric and launch server
if [ ! -f "/minecraft/fabric-server-launch.jar" ]
then
    cp /fabric-server-launch.jar /minecraft/fabric-server-launch.jar
    cp /server.jar /minecraft/server.jar
fi
cd /minecraft
java -Xmx${MEMORY} -Xms${MEMORY} -jar fabric-server-launch.jar nogui