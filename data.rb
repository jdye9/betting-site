require 'dm-core'
require 'dm-migrations'
require 'dm-aggregates'

#url for database specification
#protocal://userid.password/databasename
#protocol: mysql, sqlite3, oracle, postgre...
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/accounts.db")

# make accounts table
class Account
    
    include DataMapper::Resource

    property(:username, String, :key => true)
    property(:password, String)
    property(:total_won, Integer)
    property(:total_lost, Integer)

end

DataMapper.auto_upgrade!
DataMapper.finalize