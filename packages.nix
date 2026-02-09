{ pkgs ? import <nixpkgs> {}, unstable ? import <unstable> {}, nixgl ? import <nixgl> {} }:

[
  # WHithout this nix would be uninstalled 
  #pkgs.nix




  #vim
  #git
  #htop
  pkgs.cmatrix
  pkgs.brave
  unstable.rustdesk
  unstable.avidemux

  #pkgs.orca-slicer
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
  #nixgl.auto.nixVulkanNvidia

  unstable.nomacs

  #unstable.nuclear
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



