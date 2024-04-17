require 'csv'
require 'active_support'
require 'active_support/core_ext/object'

class Cell

    def initialize(oem, model, launchAnnounced, launchStatus, bodyDimensions, bodyWeight, bodySim, displayType, displaySize, displayResolution, featuresSensors, platformOs)
        @oem = oem
        @model = model
        @launchAnnounced = launchAnnounced
        @launchStatus = launchStatus
        @bodyDimensions = bodyDimensions
        @bodyWeight = bodyWeight
        @bodySim = bodySim
        @displayType = displayType
        @displaySize = displaySize
        @displayResolution = displayResolution
        @featuresSensors = featuresSensors
        @platformOs = platformOs
    end

    # Getter method for OEM variable
    def getOEM()
        @oem
    end

    # Setter method for OEM variable
    def setOEM=(oem)
        @oem = oem
    end

    # Getter method for model variable
    def getModel()
        @model
    end

    # Setter method for model variable
    def setModel=(model)
        @model = model
    end

    # Getter method for launch date variable
    def getLaunchAnnounced()
        @launchAnnounced
    end

    # Setter method for launch date variable
    def setLaunchAnnounced=(launchAnnounced)
        @launchAnnounced = launchAnnounced
    end

    # Getter method for launch status variable
    def getLaunchStatus()
        @launchStatus
    end

    # Setter method for launch status variable
    def setLaunchStatus=(launchStatus)
        @launchStatus = launchStatus
    end

    # Getter method for body dimensions variable
    def getBodyDimensions()
        @bodyDimensions
    end

    # Setter method for body dimensions variable
    def setBodyDimensions=(bodyDimensions)
        @bodyDimensions = bodyDimensions
    end

    # Getter method for body weight variable
    def getBodyWeight()
        @bodyWeight
    end

    # Setter method for body weight variable
    def setBodyWeight=(bodyWeight)
        @bodyWeight = bodyWeight
    end

    # Getter method for body sim variable
    def getBodySim()
        @bodySim
    end

    # Setter method for body sim variable
    def setBodySim=(bodySim)
        @bodySim = bodySim
    end

    # Getter method for display type variable
    def getDisplayType()
        @displayType
    end

    # Setter method for display type variable
    def setDisplayType=(displayType)
        @displayType = displayType
    end

    # Getter method for display size variable
    def getDisplaySize()
        @displaySize
    end

    # Setter method for display size variable
    def setDisplaySize=(displaySize)
        @displaySize = displaySize
    end

    # Getter method for display resolution variable
    def getDisplayResolution()
        @displayResolution
    end

    # Setter method for display resolution variable
    def setDisplayResolution=(displayResolution)
        @displayResolution = displayResolution
    end

    # Getter method for features sensors variable
    def getFeaturesSensors()
        @featuresSensors
    end

    # Setter method for features sensors variable
    def setFeaturesSensors=(featuresSensor)
        @featuresSensors = featuresSensor
    end

    # Getter method for platform OS variable
    def getPlatformOS()
        @platformOs
    end

    # Setter method for platform OS variable
    def setPlatformOS=(platformOs)
        @platformOs = platformOs
    end

    # Method to sanitize the data for input into HashMap
    def sanitizeData()
        if @oem.blank?
            @oem = nil
        end

        if @model.blank?
            @model = nil
        end
        # Use a regex expression to check if the announced launch date string contains a year in it. This expression matches 4 digits anywhere in the string
        if /(\d{4})/.match?(@launchAnnounced)
            @launchAnnounced = @launchAnnounced[/(\d{4})/].to_i
        else
            @launchAnnounced = nil
        end
        # Use a regex expression to check if the released launch date string contains a year in it. This expression matches 4 digits anywhere in the string
        # Also check for if it is Discontinued or Cancelled as those are valid values for this attribute 
        if /(\d{4})/.match?(@launchStatus)
            @launchStatus = @launchStatus[/(\d{4})/].to_i
        elsif @launchStatus.eql?('Discontinued') || @launchStatus.eql?('Cancelled')
            @launchStatus = @launchStatus
        else
            @launchStatus = nil
        end

        if @bodyDimensions.blank?
            @bodyDimensions = nil
        end
        # Regex to check for a number that may or may not have a decimal component with a space and a g afterwards for the body weight attribute
        if /(\d+\.?\d* g)/.match?(@bodyWeight)
            @bodyWeight = @bodyWeight[/(\d+\.?\d+ g)/].to_f
        else
            @bodyWeight = nil
        end

        if @bodySim.blank? || @bodySim.eql?('No') || @bodySim.eql?('Yes')
            @bodySim = nil
        end

        if @displayType.blank?
            @displayType = nil
        end
        # Use regex to check for a number followed by the inches word, then convert it to float to only have the numeric value
        if /(\d+\.?\d* \binches\b)/.match?(@displaySize)
            @displaySize = @displaySize[/(\d+\.\d+ \binches\b)/].to_f
        else
            @displaySize = nil
        end

        if @displayResolution.blank? || @displayResolution.eql?('-')
            @displayResolution = nil
        end
        # Regex to check if the feature sensors attribute only contains a number within it 
        if @featuresSensors.blank? || /(^[0-9.]+$)/.match?(@featuresSensors)
            @featuresSensors = nil
        end
        # Regex to check if the platform os attribute only contains a number within it. If not, we take everything up to the first comma or the whole string if there is no comma for the attribute 
        if /(^\d*+\.?\d*$)/.match?(@platformOs) || @platformOs.blank?
            @platformOs = nil
        else
            @platformOs = @platformOs[/([^,])+/]
        end
    end

    # Method to print the attributes of the class as a string organized into a list
    def ToString()
        puts "OEM: #{@oem}\nModel: #{@model}\nAnnounced Launch Year: #{@launchAnnounced}\nReleased Year: #{@launchStatus}\nDimensions: #{@bodyDimensions}\nWeight: #{@bodyWeight}\nSim Card: #{@bodySim}\nDisplay Type: #{@displayType}\nDisplay Size: #{@displaySize}\nDisplay Resolution: #{@displayResolution}\nSensor Features: #{@featuresSensors}\nOS: #{@platformOs}"
    end

    # Method to find the OEM that has the highest average weight for their phones
    # Input Parameter: A hash of cell objects 
    # Runtime: O(n^2) as we are iterating through the entirety of the cell hash and the entirety of the tempHash
    # In the worst case scenario where each phone comes from a different oem, these lengths would be equal to one another, thus making the runtime O(n^2)
    def self.findHighestAverage(cellHash)
        tempHash = {}
        cellHash.each_key do |i|
            # Make sure that neither the weight or the OEM are nil values, then check if the key(oem) exists within the hash
            # If not, make new entry for OEM and store the weight and 1(count of phones from them)
            # Otherwise, we add to the running body weight count and add 1 to the phone count before storing them back
            if !cellHash[i].getBodyWeight.nil? && !cellHash[i].getOEM.nil?
                if tempHash.key?(cellHash[i].getOEM)
                    tempArray = tempHash.fetch(cellHash[i].getOEM)
                    tempArray[0] += cellHash[i].getBodyWeight
                    tempArray[1] += 1 
                    tempHash.store(cellHash[i].getOEM,[tempArray[0], tempArray[1]])
                else
                    tempHash.store(cellHash[i].getOEM,[cellHash[i].getBodyWeight, 1])
                end
            end
        end
        highestOEM = nil
        highestWeight = 0.0
        # Iterate through the tempHash to calculate the average weight of each oems phones
        # We also check if it is the highest average and store it in variables if so
        # Regardless, we sotre the average weight along with the number of phones and average sum for printing of the raw data
        tempHash.each_key do |i|
            tempArray = tempHash[i]
            averageWeight = tempArray[0] / tempArray[1]
            if averageWeight > highestWeight
                highestWeight = averageWeight
                highestOEM = i
            end
        tempHash.store(i, [tempArray[0], tempArray[1], averageWeight])
        end
        puts "Raw Data: \n"
        puts tempHash
        puts "The company with the highest average weight is #{highestOEM} at %0.2f g. average." % [highestWeight]
    end

    # Method to find phones that were announced and released in two different years
    # Input Parameter: A hash of cell objects 
    # Runtime: O(n) as we are iterating through the entirety of the cell hash  
    def self.findDifferentYear(cellHash)
        cellHash.each_key do |i|
            # Checking three conditions with this statement:
                # 1. Check that the Announced year and the Launch Year are different
                # 2. Check that both of these attributes are not nil values
                # 3. Make sure that the launch status attribute isn't "Cancelled" or "Discontinued" as those don't count for these purposes
            if cellHash[i].getLaunchAnnounced != cellHash[i].getLaunchStatus && (cellHash[i].getLaunchAnnounced != nil && cellHash[i].getLaunchStatus != nil) && !(cellHash[i].getLaunchStatus.is_a?(String))
                puts "OEM: " + cellHash[i].getOEM + ", Model: " + cellHash[i].getModel
            end
        end
    end

    # Method to find phones that have only a single feature sensor
    # Input Parameter: A hash of cell objects 
    # Runtime: O(n) as we are iterating through the entirety of the cell hash  
    def self.findSingleFeature(cellHash)
        counter = 0
        cellHash.each_key do |i|
            if !cellHash[i].getFeaturesSensors.nil?
                # If the feature sensor parameter has a comma in it, that means there is more than one sensor on the phone
                # Thus, we use regex to check for a comma and only those without one count for this purpose
                if !/([,])+/.match?(cellHash[i].getFeaturesSensors)
                    counter += 1
                end
            end
        end
        puts "There are #{counter} phones that have only one feature sensor."
    end

    # Method to find the year after 1999 where the most phones released
    # Input Parameter: A hash of cell objects 
    # Runtime: O(nlogn) as we are first iterating through the entirety of the cell hash, then iterating through a subset of the cell hash (Phones released after 1999).
    # So, in the worst case scenario where the two hashes are equal in length, the runtime is O(n^2). Although in this case, they can't be equal so the runtime is more like O(nlogn)
    def self.findMostLaunchedYear(cellHash)
        tempHash = {}
        cellHash.each_key do |i|
            # Check to make sure both years are not nil and that the status doesn't equal "Cancelled"
            if (!(cellHash[i].getLaunchStatus.eql?("Cancelled")) && !(cellHash[i].getLaunchStatus.nil?) && !(cellHash[i].getLaunchAnnounced.nil?))
                # Check to see if the launch status is "Discontinued and the announced year is past 1999"
                # This assumes that discontinued phones count for the total for the year as it implies that they actually came out, just aren't available anymore
                # This is different to cancelled as those phones never actually launched so they shouldn't count.
                # For discontinued phones, we use the announced year for the purposes of the method
                if cellHash[i].getLaunchStatus.eql?("Discontinued") && cellHash[i].getLaunchAnnounced > 1999
                    # If the key already exists in the hash(which is the year), we fetch the value, add 1, and store the value
                    # Otherwise, we use store to add the new key to the hash with an initial counter value of 1
                    if tempHash.key?(cellHash[i].getLaunchAnnounced)
                        counter = tempHash.fetch(cellHash[i].getLaunchAnnounced)
                        counter += 1
                        tempHash.store(cellHash[i].getLaunchAnnounced, counter)
                    else
                        tempHash.store(cellHash[i].getLaunchAnnounced, 1)
                    end
                    # We have to check that the launch status is not discontinued here to make use of short-circuit evaluation
                    # Otherwise, we end up with an error for attempting to compare a string against an integer number 
                elsif !(cellHash[i].getLaunchStatus.eql?("Discontinued")) && cellHash[i].getLaunchStatus > 1999
                    if tempHash.key?(cellHash[i].getLaunchStatus)
                        counter = tempHash.fetch(cellHash[i].getLaunchStatus)
                        counter += 1
                        tempHash.store(cellHash[i].getLaunchStatus, counter)
                    else
                        tempHash.store(cellHash[i].getLaunchStatus, 1)
                    end
                end
            end
        end
        highestNum = 0
        highestYear = 0
        # We sort the hash by year by making use of the built in sort function, then convert it back to hash as that gives an array as output
        # Then we iterate through to print the results and find the year with the most releases
        tempHash = tempHash.sort.to_h
        tempHash.each_key do |i|
            puts "Number of phones released in #{i} " + ": #{tempHash[i]}"
            if tempHash[i] > highestNum
                highestNum = tempHash[i]
                highestYear = i
            end
        end
        puts "The Year with the highest amount of phones launched was #{highestYear} at #{highestNum} phones."
    end

    # Method to find the average/mean display size for all the phones in the data
    # Input Parameter: A hash of cell objects 
    # Runtime: O(n) as we are iterating through the entirety of the cell hash  
    def self.findMeanDisplaySize(cellHash)
        total = 0
        count = 0
        cellHash.each_key do |i|
            if !cellHash[i].getDisplaySize.nil?
                total += cellHash[i].getDisplaySize
                count += 1
            end
        end
        average = total/count
        puts "The Mean value of the phones display column is %0.2f inches." % [average]
    end

    # Method to find the percent of cell objects in the data that do not contain a nil value from missing/invalid data 
    # Input Parameter: A hash of cell objects 
    # Runtime: O(n^2) as we are iterating through the entirety of the cell hash but the array include? function also iterates through the temp array using a for loop behind the scenes
    # Since we are going through the whole cellHash, we end up with a double iteration for each element of it
    def self.returnNonNilPercent(cellHash)
        counter = 0.0
        cellHash.each_key do |i|
            tempArray = [cellHash[i].getOEM, cellHash[i].getModel, cellHash[i].getLaunchAnnounced, cellHash[i].getLaunchStatus, cellHash[i].getBodyDimensions, cellHash[i].getBodyWeight, cellHash[i].getBodySim, cellHash[i].getDisplayType, cellHash[i].getDisplaySize, cellHash[i].getDisplayResolution, cellHash[i].getFeaturesSensors, cellHash[i].getPlatformOS]
            if !tempArray.include?(nil)
                counter += 1
            end
        end
        percent = counter / cellHash.length * 100
        puts "Precentage of data that does not have a nil value: %0.0f%%" % [percent]
    end
end

if File.zero?('cells.csv')
    raise IOError, 'File to be read from is empty!'
else    
    cellInfo = CSV.parse(File.read('cells.csv'), headers: true)
end

Cells = {}

# Iterate through the CSV Table structure to sanitize data and put into hashmap
# Runtime: O(n) as we are iterating through the whole table of data and none of the inner lines of code are worse than O(1)
cellInfo.each_with_index do |row, i|
    tempCell = Cell.new(row['oem'], row['model'], row['launch_announced'], row['launch_status'], row['body_dimensions'], row['body_weight'], row['body_sim'], row['display_type'], row['display_size'], row['display_resolution'], row['features_sensors'], row['platform_os'])
    tempCell.sanitizeData
    Cells[i] = i 
    Cells.store(i, tempCell)
end

puts "Finding Highest Average Weight\n"
Cell.findHighestAverage(Cells)

puts "\nFinding difference between anounced and released years\n"
Cell.findDifferentYear(Cells)

puts "\nFinding phones with a single feature\n"
Cell.findSingleFeature(Cells)

puts "\nFinding year after 1999 with most phone launches\n"
Cell.findMostLaunchedYear(Cells)

puts "\nPrinting Random Cell Data"
Cells[rand(1000)].ToString

puts "\nFinding the Mean of the Display Size Column"
Cell.findMeanDisplaySize(Cells)

puts "\nFinding how many rows include no nil values from data cleanup"
Cell.returnNonNilPercent(Cells)
