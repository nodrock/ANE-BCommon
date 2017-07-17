/*
 nochump.util.zip.CRC32
 Copyright (C) 2007 David Chang (dchang@nochump.com)

 This file is part of nochump.util.zip.

 nochump.util.zip is free software: you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 nochump.util.zip is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License
 along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
 */
package sk.bpositive.bcommon.common {

import flash.utils.ByteArray;

/**
 * Computes CRC32 data checksum of a data stream.
 * The actual CRC32 algorithm is described in RFC 1952
 * (GZIP file format specification version 4.3).
 *
 * @author David Chang
 * @date January 2, 2007.
 */
public class CRC32 {

    public function CRC32()
    {
    }

    /** The crc data checksum so far. */
    private var crc:uint;

    /** The fast CRC table. Computed once when the CRC32 class is loaded. */
    private static var crcTable:Vector.<uint> = makeCrcTable();

    /** Make the table for a fast CRC. */
    private static function makeCrcTable():Vector.<uint>
    {
        var crcTable:Vector.<uint> = new Vector.<uint>(256, true);
        for (var n:int = 0; n < 256; n++) {
            var c:uint = n;
            for (var k:int = 8; --k >= 0;) {
                if ((c & 1) != 0) c = 0xedb88320 ^ (c >>> 1);
                else c = c >>> 1;
            }
            crcTable[n] = c;
        }
        return crcTable;
    }

    /**
     * Returns the CRC32 data checksum computed so far.
     */
    public function getValue():uint
    {
        return crc & 0xffffffff;
    }

    /**
     * Resets the CRC32 data checksum as if no update was ever called.
     */
    public function reset():void
    {
        crc = 0;
    }

    /**
     * Adds the complete byte array to the data checksum.
     *
     * @param buf the buffer which contains the data
     */
    public function update(buf:ByteArray):CRC32
    {
        var off:uint = 0;
        var len:uint = buf.length;
        var c:uint = ~crc;
        while (--len >= 0) c = crcTable[(c ^ buf[off++]) & 0xff] ^ (c >>> 8);
        crc = ~c;
        return this;
    }

    /**
     * Adds part of data to checksum.
     *
     * @param buf the buffer which contrains the data
     * @param offset
     * @param length
     * @return
     */
    public function updateBytes(buf:ByteArray, offset:uint = 0, length:uint = 0):CRC32
    {
        var len:uint = buf.length;
        if (offset >= len) return this;
        if (offset + length > len) length = len - offset;
        if (length == 0) length = len;

        var c:uint = ~crc;
        while (--length >= 0) c = crcTable[(c ^ buf[offset++]) & 0xff] ^ (c >>> 8);
        crc = ~c;
        return this;
    }

    public static function crc32(buf:ByteArray):uint
    {
        var crc:uint = 0;
        var off:uint = 0;
        var len:uint = buf.length;
        var c:uint = ~crc;
        while (--len >= 0) c = crcTable[(c ^ buf[off++]) & 0xff] ^ (c >>> 8);
        crc = ~c;
        return crc & 0xffffffff;
    }

    public static function updateCrc32(crc:uint, buf:ByteArray, offset:uint = 0, length:uint = 0):uint
    {
        length = length == 0 ? buf.length : length;
        if (offset + length <= buf.length) {
            var c:uint = ~crc;
            while (--length >= 0) c = crcTable[(c ^ buf[offset++]) & 0xff] ^ (c >>> 8);
            crc = ~c;
        }
        return crc & 0xffffffff;
    }
}

}
