# dali-scene-template
Template scenes for DALi scene launcher.

* Build

    To build on Desktop just build like dali-scene-launcher

        $ source setenv

        $ cd 'template'/build/tizen                     # Where 'template' can be hellodali or watchface.

        $ cmake -DCMAKE_INSTALL_PREFIX=$DESKTOP_PREFIX

        $ make install

    The asset files are installed into the dali-env folder.



    To build for device use a gbs command line similar to the one used to build dali-scene-launcher. It requires dali-scene-launcher to be built first.

        $ gbs -c [path to the .gbs.conf file] build -A armv7l -P [profile] -B [path to the destination folder]

    The rpm package is generated and can be installed on target.



