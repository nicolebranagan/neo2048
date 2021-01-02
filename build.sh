rm -rf ./build/*

vasmm68k_mot_win32.exe ./src/NEO_HelloWorld.asm -chklabels -nocase -Fbin -m68000 -align -L ./build/Listing.txt -o "./build/cart.p"
romwak /f ./build/cart.p

mkdir ./build/rom
mkdir ./build/rom/TestGame

cp ./bin/* ./build/rom/TestGame
cp ./build/cart.p ./build/rom/TestGame/202-p1.p1
cp ./neogeo.zip ./build/rom/

MakeNeoGeoHash.exe "./xml/neogeo.xml" "./build/rom/neogeo.xml" "./build/rom/TestGame"
