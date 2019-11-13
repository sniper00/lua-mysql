--[[
    lua版mysql,如果需要lua mysql 客户端，取消下面注释.
    依赖： 需要连接 mysql C client库,
    1. windows 下需要设置MYSQL_HOME.
    2. Linux 下需要确保mysql C client头文件目录和库文件目录正确
]]

---------------------mysql-----------------------
project("mysql")
    location("projects/build/mysql")
    objdir "projects/obj/%{cfg.project.name}/%{cfg.platform}_%{cfg.buildcfg}"--编译生成的中间文件目录
    targetdir "projects/bin/%{cfg.buildcfg}"--目标文件目录

    kind "SharedLib" -- 静态库 StaticLib， 动态库 SharedLib
    includedirs {"%{wks.location}/third","%{wks.location}/third/lua53"} --头文件搜索目录
    files { "**.h", "**.hpp", "**.c", "**.cpp"} --需要编译的文件， **.c 递归搜索匹配的文件
    targetprefix "" -- linux 下需要去掉动态库 'lib' 前缀
    language "C"

    filter { "system:windows" }
        links{"lua53"} -- windows 版需要链接 lua 库
        defines {"LUA_BUILD_AS_DLL","LUA_LIB"} -- windows下动态库导出宏定义
        if os.istarget("windows") then
            assert(os.getenv("MYSQL_HOME"),"please set mysql environment 'MYSQL_HOME'")
            includedirs {os.getenv("MYSQL_HOME").. "/include"}
            libdirs{os.getenv("MYSQL_HOME").. "/lib"} -- mysql C client库搜索目录
            links{"libmysql"}
        end
    filter {"system:linux"}
        if os.istarget("linux") then
            assert(os.isdir("/usr/include/mysql"),"please make sure you have install mysql, or modify the default include path,'/usr/include/mysql'")
            assert(os.isdir("/usr/lib64/mysql"),"please make sure you have install mysql, or modify the default lib path,'/usr/lib64/mysql'")
            includedirs {"/usr/include/mysql"}
            libdirs{"/usr/lib64/mysql"} -- mysql C client库搜索目录
            links{"mysqlclient"}
        end
    filter {"system:macosx"}
        links{"lua53"}
    filter{"configurations:*"}
        postbuildcommands{"{COPY} %{cfg.buildtarget.abspath} %{wks.location}/clib"}
