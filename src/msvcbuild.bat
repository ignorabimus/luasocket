@setlocal
@set LUAJIT_DIR=..\..
@set MYCOMPILE=cl /nologo /O2 /W3 /c /D_CRT_SECURE_NO_DEPRECATE /DUSE_DL /I%LUAJIT_DIR%
@set MYLIB=lib /nologo
@set SOCKET_SRCS=luasocket.c timeout.c buffer.c io.c auxiliar.c options.c inet.c tcp.c udp.c except.c select.c wsocket.c
@set SOCKET_OBJS=luasocket.obj timeout.obj buffer.obj io.obj auxiliar.obj options.obj inet.obj tcp.obj udp.obj except.obj select.obj wsocket.obj
@set MIME_SRCS=mime.c
@set MIME_OBJS=mime.obj

@if not exist lib\ (
  mkdir lib
)

%MYCOMPILE% /MT %SOCKET_SRCS%
%MYLIB% /out:lib\socket.lib %SOCKET_OBJS%

%MYCOMPILE% /MDd %SOCKET_SRCS%
%MYLIB% /out:lib\socket_d.lib %SOCKET_OBJS%

%MYCOMPILE% /MT %MIME_SRCS%
%MYLIB% /out:lib\mime.lib %MIME_OBJS%

%MYCOMPILE% /MDd %MIME_SRCS%
%MYLIB% /out:lib\mime_d.lib %MIME_OBJS%

del %SOCKET_OBJS% %MIME_OBJS%

mkdir %LUAJIT_DIR%\lua\jit
copy %LUAJIT_DIR%\jit\* %LUAJIT_DIR%\lua\jit
%LUAJIT_DIR%\luajit.exe -bs ftp.lua ftp.luo
%LUAJIT_DIR%\luajit.exe -bs http.lua http.luo
%LUAJIT_DIR%\luajit.exe -bs ltn12.lua ltn12.luo
%LUAJIT_DIR%\luajit.exe -bs mime.lua mime.luo
%LUAJIT_DIR%\luajit.exe -bs smtp.lua smtp.luo
%LUAJIT_DIR%\luajit.exe -bs socket.lua socket.luo
%LUAJIT_DIR%\luajit.exe -bs tp.lua tp.luo
%LUAJIT_DIR%\luajit.exe -bs url.lua url.luo

%LUAJIT_DIR%\luajit.exe hexdump.lua ftp.luo toolkit_ftp > toolkit_ftp.c
%LUAJIT_DIR%\luajit.exe hexdump.lua http.luo toolkit_http > toolkit_http.c
%LUAJIT_DIR%\luajit.exe hexdump.lua ltn12.luo toolkit_ltn12 > toolkit_ltn12.c
%LUAJIT_DIR%\luajit.exe hexdump.lua mime.luo toolkit_mime > toolkit_mime.c
%LUAJIT_DIR%\luajit.exe hexdump.lua smtp.luo toolkit_smtp > toolkit_smtp.c
%LUAJIT_DIR%\luajit.exe hexdump.lua socket.luo toolkit_socket > toolkit_socket.c
%LUAJIT_DIR%\luajit.exe hexdump.lua tp.luo toolkit_tp > toolkit_tp.c
%LUAJIT_DIR%\luajit.exe hexdump.lua url.luo toolkit_url > toolkit_url.c
del *.luo
rmdir /s /q %LUAJIT_DIR%\lua

%MYCOMPILE% /MT toolkit_*.c
%MYLIB% /out:lib\toolkit.lib toolkit_*.obj

%MYCOMPILE% /MDd toolkit_*.c
%MYLIB% /out:lib\toolkit_d.lib toolkit_*.obj

del toolkit_*.obj toolkit_*.c
