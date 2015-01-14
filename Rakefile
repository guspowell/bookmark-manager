require 'data_mapper'
require './app/data_mapper_setup'

task :auto_upgrade do
	DataMapper.auto_upgrade!
	puts "auto_upgrade complete (no data loss)"
end

tast :auto_migrate do
	DataMapper.auto_migrate!
	puts "Auto_migrate complete (data could have been lost)"
end