Dir[File.dirname(__FILE__) + '/rmarket/*.rb'].each do |file|
  require "rmarket/#{File.basename(file, File.extname(file))}"
end
