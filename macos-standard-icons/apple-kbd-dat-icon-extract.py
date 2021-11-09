#!/usr/bin/env python
#
# Copyright (C) 2012 Philip Belemezov <philip@belemezov.net>
#
# Public domain
#


import struct
import optparse
import sys
import os

prog = os.path.basename(sys.argv[0])

DEFAULT_DATFILE = "/System/Library/Keyboard Layouts/AppleKeyboardLayouts.bundle/Contents/Resources/AppleKeyboardLayouts-L.dat"

parser = optparse.OptionParser(usage="Usage: %prog [options] DATFILE")
parser.add_option("-o", "--output", dest="output",
                  help="Output directory", metavar="OUTPUT")

(opts, args) = parser.parse_args()
if not opts.output:
    parser.error("Please specify output dir using `-o'")


ICNS_HEADER = '\x69\x63\x6e\x73'


def bufferToHex(buffer):
    accumulator = ''
    for i in range(len(buffer)):
        accumulator += '%02x' % ord(buffer[i]) + ' '
    return accumulator


def findNextIcon(data, pos):
    while pos < len(data):
        if data[pos:pos + len(ICNS_HEADER)] == ICNS_HEADER:
            pos += len(ICNS_HEADER)
            break
        pos += len(ICNS_HEADER)
    return pos


def readIconData(data, pos, length):
    if pos + length >= len(data):
        return None
    return data[pos:pos + length]


def writeIcon(filename, iconData):
    with open(filename, 'wb') as f:
        f.write(ICNS_HEADER)
        f.write(struct.pack('>I', len(iconData)))
        f.write(iconData)


def processIcons(data, outputDir):
    if not os.path.exists(outputDir):
        print "%s: Output directory %s doesn't exist, please create it first" \
                % (prog, outputDir)
        return 1

    iconIndex = 1
    pos = findNextIcon(data, 0)
    while pos < len(data):
        iconLen = struct.unpack('>I', data[pos:pos+4])[0]
        pos += 4
        iconData = readIconData(data, pos, iconLen)
        assert iconLen == len(iconData)

        filename = os.path.join(outputDir, 'icon%d.icns' % iconIndex)
        print "%s: Writing icon file %s" % (prog, filename)
        writeIcon(filename, iconData)

        iconIndex += 1
        pos = findNextIcon(data, pos)
    return 0

def main():
    if not args:
        filename = DEFAULT_DATFILE
    else:
        filename = args[0]

    print "%s: Reading %s" % (prog, filename)
    data = None
    with open(filename, "rb") as f:
        data = f.read()
    return processIcons(data, outputDir=opts.output)

if __name__ == "__main__":
    sys.exit(main())
