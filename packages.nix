{ pkgs ? import <nixpkgs> {}, unstable ? import <unstable> {}, nixgl ? import <nixgl> {} }:

[
  #vim
  #git
  #htop
  pkgs.cmatrix
  pkgs.brave
  pkgs.rustdesk

  #pkgs.orca-slicer
  pkgs.fish

  #unstable.onlyoffice-bin
  #unstable.wpsoffice
  #unstable.softmaker-office
  unstable.libreoffice-qt6-fresh
  #unstable.parsec-bin
  unstable.stellarium
  unstable.anydesk
  unstable.bruno
  unstable.betterbird
  unstable.nuclear
  unstable.piper-tts

  # needed for some apps (like stellarium) 
  nixgl.auto.nixGLDefault
  unstable.nomacs

  #unstable.nuclear
  pkgs.invidtui
  #headset # youtube listening app
]


#with import <nixpkgs> {};
#[
#  #vim
#  #git
#  #htop
#  cmatrix
#  #nuclear
#  invidtui
#  #headset # youtube listening app
#]


# Content of /etc/nix-channels
#                                               
#build-users-group = nixbld                     
#trusted-users = root horo                      
#experimental-features = nix-command flakes     



