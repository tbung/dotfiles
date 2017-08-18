# Create symlinks for stuff in $HOME

New-Item -ItemType SymbolicLink -Target .\_vimrc -Path ~\_vimrc
New-Item -ItemType SymbolicLink -Target .\.eslintrc -Path ~\.eslintrc


# Create symlinks for other stuff

New-Item -ItemType SymbolicLink -Target .\profile.ps1 -Path $PROFILE
