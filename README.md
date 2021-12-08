# tmplt

Bash template file and folder creator designed for STEM students with repeated assignments.


## Installation

Install and uninstall with make

```bash
  make install
  make uninstall
```

tmplt will look in ~/.Templates/ for available templates. Examples are present in the
repository.

## Usage

Any file or folder located in ~/.Templates/ can be used as a template.
For folders, any files within that have the same name as their parent directory will be
replaced with the second argument passed to tmplt retaining file extension.
```bash
tmplt essay HW4
```
This will create a folder
```bash
HW4
  HW4.tex
  makefile
  images
 ``` 
