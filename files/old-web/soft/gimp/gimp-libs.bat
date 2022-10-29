@echo off
lib /machine:i386 /def:gimp.def /name:libgimp-2.0-0.dll /out:libgimp-2.0.lib
lib /machine:i386 /def:gimpbase.def /name:libgimpbase-2.0-0.dll /out:libgimpbase-2.0.lib
lib /machine:i386 /def:gimpcolor.def /name:libgimpcolor-2.0-0.dll /out:libgimpcolor-2.0.lib
lib /machine:i386 /def:gimpmath.def /name:libgimpmath-2.0-0.dll /out:libgimpmath-2.0.lib
lib /machine:i386 /def:gimpmodule.def /name:libgimpmodule-2.0-0.dll /out:libgimpmodule-2.0.lib
lib /machine:i386 /def:gimpthumb.def /name:libgimpthumb-2.0-0.dll /out:libgimpthumb-2.0.lib
lib /machine:i386 /def:gimpui.def /name:libgimpui-2.0-0.dll /out:libgimpui-2.0.lib
lib /machine:i386 /def:gimpwidgets.def /name:libgimpwidgets-2.0-0.dll /out:libgimpwidgets-2.0.lib

