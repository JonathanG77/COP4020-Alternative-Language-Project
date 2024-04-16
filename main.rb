require 'csv'

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
    def setPlatformOS=(platformOS)
        @platformOS = platformOS
    end

    # Method to sanitize the data for input into HashMap
    def sanitizeData()
    end
    
end

if File.zero?('cells.csv')
    raise IOError, 'File to be read from is empty!'
else    
    cellInfo = CSV.parse(File.read('cells.csv'), headers: true)
end

Cells = {}


cellInfo.each_with_index do |row, i|
    tempCell = Cell.new(row['oem'], row['model'], row['launch_announced'], row['launch_status'], row['body_dimensions'], row['body_weight'], row['body_sim'], row['display_type'], row['display_size'], row['display_resolution'], row['features_sensors'], row['platform_os'])
    tempCell.sanitizeData
    Cells[:Index] = i
    Cells.store(i, tempCell)
end

puts Cells
