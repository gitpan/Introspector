# patch the files
for x in `cat MANIFEST`; do echo $x; ln -b -f -s /home/mdupont/introspector-cvs/c_files/$x ~/gcc-main/gcc-introspector-0.1/gcc/$x;  done