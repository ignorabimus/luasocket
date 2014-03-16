-- hexdump
function hexdump(buf)
    for byte=1, #buf, 16 do
        buf:sub(byte, byte+15):gsub('.',
            function (c)
                io.write(string.format('0x%02X,', string.byte(c)))
            end)
        io.write("\n")
    end
end

local fh, msg
fh, msg = io.open(arg[1], "rb")
if fh then
    io.write("const unsigned char " .. arg[2] .. "[] = {\n")
    hexdump(fh:read("*a"))
    io.write("};\n")
    io.write("const unsigned long " .. arg[2] .. "_len = sizeof " .. arg[2] .. ";\n")
else
    print(msg)
end
