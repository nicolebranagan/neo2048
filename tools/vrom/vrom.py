#
# Build a data overlay.
# usage: overlay.py <output> <header> <input1> <input2> ...
#

import sys
from pathlib import Path
import math

def get_file_name(filename):
    cleaned_name = Path(filename).stem.upper().replace('.', '_').replace('-', '_')
    try:
        int(cleaned_name[0])
        return '_' + cleaned_name
    except ValueError:
        return cleaned_name

def get_binary_data(filename):
    with open(filename, "rb") as fileo:
        return fileo.read()

def get_sector_aligned_data(filename):
    binarydata = get_binary_data(filename)
    size = len(binarydata)
    sectorcount = math.ceil(size / 256)
    paddeddata = binarydata + bytes([0 for _ in range(0, (sectorcount * 256) - size)])

    return {
        "name": filename,
        "data": paddeddata,
        "size": size,
        "sectorcount": sectorcount,
    }

if (len(sys.argv) < 4):
    print("usage: overlay.py <output> <header> <input1> <input2> ...")
    sys.exit()

outputfile = sys.argv[1]
headerfile = sys.argv[2]

binaryfiles = sys.argv[3:]

parsed_files = [get_sector_aligned_data(filename) for filename in binaryfiles]
fulldata = b''

with open(headerfile, "w") as header:
    header.write("; This is an auto-generated file. Do not alter.\n\n")
    header_name = get_file_name(headerfile)
    address = 0
    for filedata in parsed_files:
        header.write(f'; {filedata["name"]}\n')
        variable_name = get_file_name(filedata["name"])
        header.write(f'{variable_name}_START_ADDR equ {address//256} \n')
        header.write(f'{variable_name}_END_ADDR equ {(address + filedata["size"])//256} \n\n')
        fulldata = fulldata + filedata["data"]
        address = address + len(filedata["data"])

with open(outputfile, "wb") as output:
    output.write(fulldata)
