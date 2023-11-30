# meta-devfest

This README file contains information on the contents of the meta-devfest layer, which is a custom layer that can be used in a Yocto Project build. This layer provides patches to existing Flutter recipes and a patch adding a non-default Weston configuration file that is capable of running specific Flutter applications.

## Dependencies

- URI: [git://git.yoctoproject.org/poky](git://git.yoctoproject.org/poky)
  - branch: `kirkstone`
  - layers: `meta`

- URI: [https://github.com/meta-flutter/meta-flutter](https://github.com/meta-flutter/meta-flutter)
  - branch: `kirkstone`
  - layers: `meta-flutter`
