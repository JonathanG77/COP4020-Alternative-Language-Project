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
    def setLaunchDate=(launchDate)
        @launchDate = launchDate
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

        if /(\d{4})/.match?(@launchAnnounced)
            @launchAnnounced = @launchAnnounced[/(\d{4})/].to_i
        else
            @launch_announced = nil
        end
        
        if /(\d{4})/.match?(@launchStatus)
            @launchStatus = @launchStatus[/(\d{4})/].to_i
        elsif @launchStatus.eql?('Discontinued') || @launchStatus.eql?('Cancelled')
            @launchStatus = @launchStatus
        else
            @launch_announced = nil
        end

        if @bodyDimensions.blank?
            @bodyDimensions = nil
        end

        if /(\d+ [g])/.match?(@bodyWeight)
            @bodyWeight = @bodyWeight[/(\d+ [g])/].to_f
        else
            @bodyWeight = nil
        end

        if @bodySim.blank? || @bodySim.eql?('No') || @bodySim.eql?('Yes')
            @bodySim = nil
        end

        if @displayType.blank?
            @displayType = nil
        end

        if /(\d*+\.?\d* \binches\b)/.match?(@displaySize)
            @displaySize = @displaySize[/(\d+\.\d+ \binches\b)/].to_f
        else
            @displaySize = nil
        end

        if @displayResolution.blank?
            @displayResolution = nil
        end

        if @featuresSensors.blank? || /(^[0-9.]+$)/.match?(@featuresSensors)
            @featuresSensors = nil
        end

        if /(^\d*+\.?\d*$)/.match?(@platformOs) || @platformOs.blank?
            @platformOs = nil
        else
            @platformOs = @platformOs[/([^,])+/]
        end
    end

    def self.findHighestAverage(cellHash)

    end

    def self.findDifferentYear(cellHash)
        cellHash.each_key do |i|
            if cellHash[i].getLaunchAnnounced != cellHash[i].getLaunchStatus && (cellHash[i].getLaunchAnnounced != nil && cellHash[i].getLaunchStatus != nil) && !(cellHash[i].getLaunchStatus.is_a?(String))
                puts "OEM: " + cellHash[i].getOEM + ", Model: " + cellHash[i].getModel
            end
        end
    end

    def self.findSingleFeature(cellHash)

    end

    def self.findMostLaunchedYear(cellHash)

    end
end

if File.zero?('cells.csv')
    raise IOError, 'File to be read from is empty!'
else    
    cellInfo = CSV.parse(File.read('cells.csv'), headers: true)
end

Cells = {}

# Iterate through the CSV Table structure to sanitize data and put into hashmap

cellInfo.each_with_index do |row, i|
    tempCell = Cell.new(row['oem'], row['model'], row['launch_announced'], row['launch_status'], row['body_dimensions'], row['body_weight'], row['body_sim'], row['display_type'], row['display_size'], row['display_resolution'], row['features_sensors'], row['platform_os'])
    tempCell.sanitizeData
    Cells[i] = i 
    Cells.store(i, tempCell)
end

Cell.findDifferentYear(Cells)
