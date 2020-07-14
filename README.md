# pdftoppm-r
Recursive conversion of PDF files to JPG format using pdftoppm and Hy.

This script can be executed by running

``` sh
hy pdftoppmr.hy "/path/to/pdfs/folder" -q 100 -r 300
```

The first argument should be a valid path, the `-q` option sets the quality of
the conversion (defaults to 100) while `-r` sets the resolution (defaults to
300). Use `-h` for bringing up the help.

What this script does is it recursively goes through the
`"/path/to/pdfs/folder"` path, visiting its subfolders and for each PDF file it
finds, it converts it to the JPG format using the desired quality and
resolution. Keep in mind that the original file is **deleted** in the process.
Run this in a copy of the original folder to keep the PDF files.

---

This script was built having the following folder structure in mind

``` sh
some_folder
├── some_pdfs
│   ├── foo.pdf
│   ├── bar.pdf
│   └── baz.pdf
├── pdfs_and_other
│   ├── foobar.pdf
│   ├── foobaz.txt
│   └── barbaz.jpg
└── no_pdfs_here
    ├── bazbar.txt
    ├── barbaz.json
    └── bazbar.jpg
```

So running the script as

``` sh
hy pdftoppmr.hy "/path/to/some_folder"
```

essentially replaces all the PDF files with JPG files, essentially ending up
with

``` sh
root_folder
├── some_pdfs
│   ├── foo.jpg
│   ├── bar.jpg
│   └── baz.jpg
├── pdfs_and_other
│   ├── foobar.jpg
│   ├── foobaz.txt
│   └── barbaz.jpg
└── no_pdfs_here
    ├── bazbar.txt
    ├── barbaz.json
    └── bazbar.jpg
```
