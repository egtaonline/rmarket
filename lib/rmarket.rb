Dir[File.dirname(__FILE__) + '/rmarket/*.rb'].each do |file| 
  require File.basename(file, File.extname(file))
end
