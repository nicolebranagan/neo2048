rm -rf ./build/*

for f in ./images/sprites/*.terra;
do
  python3 ./tools/neofy/neofy.py sprite $f ./bin/Sprites ./src_68k/palettes/$(basename $f .terra).pal
done

vasmm68k_mot_win32.exe ./src_68k/neo2048.asm -chklabels -nocase -Fvobj -m68000 -align -L ./build/Listing.txt -o "./build/cart.obj"
vlink -s -b rawbin1 -M -T "./memmap.ld" -t -o "./build/cart.p" "./build/cart.obj"
romwak /f ./build/cart.p

vasmz80_oldstyle_win32.exe -Fbin -nosym -DTARGET_CART -o build/m1.m1 src_z80/simple.asm
romwak /p build/m1.m1 build/m1.m1 64 0

mkdir ./build/rom
mkdir ./build/rom/Neo2048

cp ./bin/* ./build/rom/Neo2048
cp ./build/cart.p ./build/rom/Neo2048/202-p1.p1
cp ./build/m1.m1 ./build/rom/Neo2048/202-m1.m1
cp ./neogeo.zip ./build/rom/

MakeNeoGeoHash.exe "./xml/neogeo.xml" "./build/rom/neogeo.xml" "./build/rom/Neo2048"
