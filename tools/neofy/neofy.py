# turboize.py
#
# usage: turboize.py [sprite|tile|8x8font|8x16font] <input> <output> <pal_output>

from pixelgrid import *
import sys
import json

def palettize(inputgrid):
    def to_binary(input):
        return bin(input)[2:].zfill(6) # strip 0b and make 6 digits
    output = []
    for color in inputgrid.palette:
        red = to_binary(color[0] // 4)
        green = to_binary(color[1] // 4)
        blue = to_binary(color[2] // 4)

        if (int(red[5]) + int(green[5]) + int(blue[5])) == 2:
            dark_bit = 1
        else:
            dark_bit = 0
        output.append(int(f'{dark_bit}{red[4]}{green[4]}{blue[4]}{red[:4]}', 2))
        output.append(int(f'{green[:4]}{blue[:4]}', 2))
    return output

def index_to_binary(input):
    return bin(input)[2:].zfill(4) # strip 0b and make 4 digits

def turboize_tile(inputgrid, x_start, y_start):
    bitplane1 = []
    bitplane2 = []
    bitplane3 = []
    bitplane4 = []
    
    for y in range(0, 8):
        rowplane1 = []
        rowplane2 = []
        rowplane3 = []
        rowplane4 = []
        for x in range(0, 8):
            true_x = x + x_start
            true_y = y + y_start
            val = index_to_binary(inputgrid.get(true_x, true_y))
            rowplane1.append(val[3])
            rowplane2.append(val[2])
            rowplane3.append(val[1])
            rowplane4.append(val[0])
        bitplane1.append(int(''.join(rowplane1), 2))
        bitplane2.append(int(''.join(rowplane2), 2))
        bitplane3.append(int(''.join(rowplane3), 2))
        bitplane4.append(int(''.join(rowplane4), 2))
    
    output = []
    for i in range(0, 8):
        output.append(bitplane1[i])
        output.append(bitplane2[i])
    for i in range(0, 8):
        output.append(bitplane3[i])
        output.append(bitplane4[i])
    return output

def turboize_8x8(inputgrid):
    max_ = inputgrid.getmaxtuple()
    rows = (1+max_[1])
    output = []
    for y in range(0, rows):
        for x in range(0, inputgrid.width):
            output.extend(turboize_tile(inputgrid, x*8, y*8))
    return output

def turboize_8x16(inputgrid):
    max_ = inputgrid.getmaxtuple()
    rows = math.ceil((1+max_[1])/2)
    output = []
    for ygroup in range(0, rows):
        for tile in range(0, inputgrid.width):
            true_x = tile * 8
            true_y = ygroup * 16
            output.extend(turboize_tile(inputgrid, true_x, true_y))
            output.extend(turboize_tile(inputgrid, true_x, true_y + 8))
    return output

def turboize_16x16(inputgrid):
    max_ = inputgrid.getmaxtuple()
    rows = math.ceil((1+max_[1])/2)
    output = []
    for ygroup in range(0, rows):
        for tile in range(0, inputgrid.width // 2):
            true_x = tile * 16
            true_y = ygroup * 16
            output.extend(turboize_tile(inputgrid, true_x, true_y))
            output.extend(turboize_tile(inputgrid, true_x + 8, true_y))
            output.extend(turboize_tile(inputgrid, true_x, true_y + 8))
            output.extend(turboize_tile(inputgrid, true_x + 8, true_y + 8))
    return output

def neofy_sprite_8x8(inputgrid, x_start, y_start):
    bitplane1 = []
    bitplane2 = []
    bitplane3 = []
    bitplane4 = []
    for y in range(0, 8):
        rowplane1 = []
        rowplane2 = []
        rowplane3 = []
        rowplane4 = []
        for x in range(7, -1, -1):
            true_x = x + x_start
            true_y = y + y_start
            val = index_to_binary(inputgrid.get(true_x, true_y))
            rowplane1.append(val[3])
            rowplane2.append(val[2])
            rowplane3.append(val[1])
            rowplane4.append(val[0])
        bitplane1.append(int(''.join(rowplane1[:8]), 2))
        bitplane2.append(int(''.join(rowplane2[:8]), 2))
        bitplane3.append(int(''.join(rowplane3[:8]), 2))
        bitplane4.append(int(''.join(rowplane4[:8]), 2))
    return (bitplane1, bitplane2, bitplane3, bitplane4)

def interleave_bitplanes(bitplane1, bitplane2):
    output = []
    for i in range(0, len(bitplane1)):
        output.append(bitplane1[i])
        output.append(bitplane2[i])
    return output

def neofy_sprite_16x16(inputgrid, x_start, y_start):
    top_left = neofy_sprite_8x8(inputgrid, x_start, y_start)
    top_right = neofy_sprite_8x8(inputgrid, x_start + 8, y_start)
    bottom_left = neofy_sprite_8x8(inputgrid, x_start, y_start + 8)
    bottom_right = neofy_sprite_8x8(inputgrid, x_start + 8, y_start + 8)

    c0 = []
    c1 = []

    c0.extend(interleave_bitplanes(top_right[0], top_right[1]))
    c1.extend(interleave_bitplanes(top_right[2], top_right[3]))

    c0.extend(interleave_bitplanes(bottom_right[0], bottom_right[1]))
    c1.extend(interleave_bitplanes(bottom_right[2], bottom_right[3]))

    c0.extend(interleave_bitplanes(top_left[0], top_left[1]))
    c1.extend(interleave_bitplanes(top_left[2], top_left[3]))

    c0.extend(interleave_bitplanes(bottom_left[0], bottom_left[1]))
    c1.extend(interleave_bitplanes(bottom_left[2], bottom_left[3]))

    return (c0, c1)

def neofy_sprite(inputgrid):
    output0 = []
    output1 = []
    max_ = inputgrid.getmaxytuple()
    cols = math.ceil((1+max_[0])/2)
    for xgroup in range(0, cols):
        for ygroup in range(0, inputgrid.height // 2):
            c0, c1 = neofy_sprite_16x16(inputgrid, xgroup * 16, ygroup*16)
            output0.extend(c0)
            output1.extend(c1)
    return (output0, output1)

if (len(sys.argv) < 5):
    print("usage: neofy.py [sprite|tile|8x8font|8x16font|face] <input> <output> <palette>")
    sys.exit()

mode = sys.argv[1]
inputfile = sys.argv[2]
outputfile = sys.argv[3]
palettefile = sys.argv[4]

pixelgrid = PixelGrid([(0,0,0)])

with open(inputfile, "r") as fileo:
    pixelgrid.load(json.load(fileo))

if mode == "sprite":
    bytelist1, bytelist2 = neofy_sprite(pixelgrid)
    with open(f"{outputfile}.s1", "wb") as fileo:
        fileo.write(bytes(bytelist1))
    with open(f"{outputfile}.s2", "wb") as fileo:
        fileo.write(bytes(bytelist2))
elif mode == "tile":
    bytelist = turboize_16x16(pixelgrid)
elif mode == "8x8font":
    bytelist = turboize_8x8(pixelgrid)
elif mode == "8x16font":
    bytelist = turboize_8x16(pixelgrid)
else:
    print("Unsupported type")
    sys.exit(2)

palette = palettize(pixelgrid)
if mode == "sprite" or mode == "face":
    palette[0] = 0
    palette[1] = 0
with open(palettefile, "wb") as fileo:
    fileo.write(bytes(palette))
