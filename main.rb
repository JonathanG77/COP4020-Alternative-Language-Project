require 'csv'

if File.zero?('cells.csv')
    raise IOError, 'File to be read from is empty!'
else    
    cellInfo = CSV.parse(File.read('cells.csv'), headers: true)
end

puts cellInfo

