rm -rf ./build/*

for f in ./images/sprites/*.terra;
do
  python3 ./tools/neofy/neofy.py sprite $f ./bin/Sprites ./src_68k/palettes/$(basename $f .terra).pal
done

vasmm68k_mot_win32.exe ./src_68k/neo2048.asm -chklabels -nocase -Fvobj -m68000 -align -L ./build/Listing.txt -o "./build/cart.obj"
vlink -s -b rawbin1 -M -T "./memmap.ld" -t -o "./build/cart.p" "./build/cart.obj"

romwak /f ./build/cart.p

mkdir ./build/rom
mkdir ./build/rom/Neo2048

cp ./bin/* ./build/rom/Neo2048
cp ./build/cart.p ./build/rom/Neo2048/202-p1.p1
cp ./neogeo.zip ./build/rom/

MakeNeoGeoHash.exe "./xml/neogeo.xml" "./build/rom/neogeo.xml" "./build/rom/Neo2048"
