# 32-bit Debian Docker Image

These are a couple of scripts to generate a 32-bit Debian image to run in
a docker container.

## How to use

First run the `prepare32.sh` script with `sudo`; it will generate `debian32.tgz`
file to be imported in docker, with a bare minimum 32-bit system.

```
$ sudo ./prepare32.sh
```

Then, you may run the `base32.sh` script to import the tar file into a docker
image.

```
$ ./base32.sh
```

You may want to edit both files and change the values at the top of them to
adjust your preferences (for example, the name of the imported docker image).

## Requirements

The command `debootstrap` must be installed in the system.


