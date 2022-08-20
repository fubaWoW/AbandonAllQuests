AddonName=AbandonAllQuests
srcDir=src
targetDir=target
targetSrc=${targetDir}/${AddonName}
zipFile=${AddonName}.zip

rm -rf ${targetDir}
mkdir -p ${targetSrc}
cp -R ${srcDir}/. ${targetSrc}
cd ${targetDir}
tar -c -f ${zipFile} ${AddonName}
cd ..

# dev deploy into addon folder
cp -R ${srcDir}/. .