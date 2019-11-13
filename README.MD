# Lua Mysql Client

For moon game server https://github.com/sniper00/moon.git

## build

Depend

- Mysql C client
- windows need set ENV `MYSQL_HOME`
- Linux need set mysql C client `include dir` and `lib dir`

## Lua 
```lua
local mysql = require("mysql")

local conn = mysql.create()

-- host,port,user,password,database,2
local result,errmsg = conn:connect("127.0.0.1", 3306, "root", "4321", "mysql",2)
print(result,errmsg)

--query
local result,errmsg = conn:query("select * from article_detail;")
log.dump(result)

print(conn:connected())

local create_table = [[
    DROP TABLE IF EXISTS `article_detail`;
    CREATE TABLE `article_detail` (
    `id` BIGINT NOT NULL,
    `parentid` BIGINT DEFAULT '0',
    `title` varchar(255) DEFAULT '',
    `content` varchar(255) DEFAULT '',
    `updatetime` varchar(255) DEFAULT '',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]

print(conn:execute(create_table))

print(conn:execute("INSERT INTO article_detail(id,parentid,title,content,updatetime) VALUES(1,2,'abc','abc','abc')"))

local stmtid,ec = conn:prepare("INSERT INTO article_detail(id,parentid,title,content,updatetime) VALUES(?,?,?,?,?)")
print(conn:execute_stmt(stmtid,2,3,'abc','abc','abc'))
```

## C++
```cpp
#include "mysql.hpp"
#include "data_table.hpp"
#include <iostream>
int main()
{
    try{
        db::mysql mysql;
        mysql.connect("127.0.0.1",3306,"root","4321","mysql");

        auto sql = R"(
            DROP TABLE IF EXISTS `article_detail`;
            CREATE TABLE `article_detail` (
            `id` BIGINT NOT NULL,
            `parentid` BIGINT DEFAULT '0',
            `title` varchar(255) DEFAULT '',
            `content` varchar(255) DEFAULT '',
            `updatetime` varchar(255) DEFAULT '',
            PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
        )";

        mysql.execute(sql);
        mysql.execute("INSERT INTO article_detail(id,parentid,title,content,updatetime) VALUES(1,2,'abc','abc','abc')");

        auto stmtid = mysql.prepare("INSERT INTO article_detail(id,parentid,title,content,updatetime) VALUES(?,?,?,?,?)");
        //stmt
        mysql.execute_stmt(stmtid, 2,2,"abc","abc","abc");
        
        auto result = mysql.query<db::data_table>("select * from article_detail;");
        for(auto& row : *result)
        {
           std::cout<<std::get<int64_t>(row[0])<<std::endl;
           std::cout<< std::get<int64_t>(row[1])<<std::endl;
           std::cout<< std::get<std::string>(row[2])<<std::endl;
           std::cout<< std::get<std::string>(row[3])<<std::endl;
           std::cout<< std::get<std::string>(row[4])<<std::endl;
        }
    
    }catch(std::exception& e)
    {
        std::cout<<"mysql exception:"<<e.what()<<std::endl;
    }
    return 0;
}
```