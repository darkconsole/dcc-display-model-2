@echo off
echo DID YOU INCREMEMENT THE VERSION NUMBER IN THE MAIN SCRIPT ASSHOLE?
zip display-model-v%~1.zip -q -r *.esp notes-*.txt interface meshes scripts seq textures
