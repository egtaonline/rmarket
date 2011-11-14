Dir[File.dirname(__FILE__) + '/beliefs/*.rb'].each do |file|
  require "rmarket/beliefs/#{File.basename(file, File.extname(file))}"
end