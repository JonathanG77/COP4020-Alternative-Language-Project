require 'test/unit'
require_relative './main'

class CellTest < Test::Unit::TestCase
    def test_fileEmpty
        assert_false(File.zero?('cells.csv'), "File is empty")
    end

    def test_dataTypes
        tCell = Cell.new("Honor","9X Lite","2020, April 17","Available. Released 2020, May 14","160.4 x 76.6 x 7.8 mm (6.31 x 3.02 x 0.31 in)","188 g (6.63 oz)","Hybrid Dual SIM (Nano-SIM, dual stand-by)","IPS LCD capacitive touchscreen, 16M colors","6.5 inches, 103.2 cm (~84.0% screen-to-body ratio)","1080 x 2340 pixels, 19.5:9 ratio (~397 ppi density)","Fingerprint (rear-mounted), accelerometer, proximity, compass","Android 9.0 (Pie), EMUI 9.1")
        tCell.sanitizeData
        assert_true(tCell.getLaunchAnnounced.is_a?(Integer), "Announced Year not transformed to int")
        assert_true(tCell.getBodyWeight.is_a?(Float), "Weight of phone not transformed to float")
        assert_true(tCell.getDisplaySize.is_a?(Float), "Size of display not transformed to float")
    end

    def test_replaceMissing
        tCell = Cell.new("Haier","P5","2003","Discontinued","135 x 28 x 18 mm (5.31 x 1.10 x 0.71 in)","75 g (2.65 oz)","Mini-SIM","Monochrome","","64 x 102 pixels, 16:10 ratio","V1","-")
        tCell.sanitizeData
        assert_true(tCell.getPlatformOS.nil?, "Missing value not replaced with nil")
        assert_true(tCell.getDisplaySize.nil?, "Empty value not replaced with nil")
    end

    def test_testHashFunctions
        tCell = Cell.new("Honor","9X Lite","2020, April 17","Available. Released 2020, May 14","160.4 x 76.6 x 7.8 mm (6.31 x 3.02 x 0.31 in)","188 g (6.63 oz)","Hybrid Dual SIM (Nano-SIM, dual stand-by)","IPS LCD capacitive touchscreen, 16M colors","6.5 inches, 103.2 cm (~84.0% screen-to-body ratio)","1080 x 2340 pixels, 19.5:9 ratio (~397 ppi density)","Fingerprint (rear-mounted), accelerometer, proximity, compass","Android 9.0 (Pie), EMUI 9.1")
        tCell2 = Cell.new("Haier","P5","2003","Discontinued","135 x 28 x 18 mm (5.31 x 1.10 x 0.71 in)","75 g (2.65 oz)","Mini-SIM","Monochrome","","64 x 102 pixels, 16:10 ratio","V1","-")
        tCell.sanitizeData
        tCell2.sanitizeData
        tCells = {}
        tCells.store(1, tCell)
        tCells.store(2, tCell2)
        assert_nothing_thrown do Cell.findHighestAverage(tCells) end
        assert_nothing_thrown do Cell.findDifferentYear(tCells) end
        assert_nothing_thrown do Cell.findSingleFeature(tCells) end
        assert_nothing_thrown do Cell.findMostLaunchedYear(tCells) end
        assert_nothing_thrown do Cell.findMeanDisplaySize(tCells) end
        assert_nothing_thrown do Cell.returnNonNilPercent(tCells) end
    end

    def testGettersSetters
        tCell = Cell.new("Haier","P5","2003","Discontinued","135 x 28 x 18 mm (5.31 x 1.10 x 0.71 in)","75 g (2.65 oz)","Mini-SIM","Monochrome","","64 x 102 pixels, 16:10 ratio","V1","-")
        tCell.setOEM = "Honor"
        assert_true(tCell.getOEM.eql?("Honor"), "OEM not set correctly")
        tCell.setModel = "9X Lite"
        assert_true(tCell.getModel.eql?("9X Lite"), "Model not set correctly")
        tCell.setLaunchAnnounced = "2020, April 17"
        assert_true(tCell.getLaunchAnnounced.eql?("2020, April 17"), "Announced Year not set correctly")
        tCell.setLaunchStatus = "Available. Released 2020, May 14"
        assert_true(tCell.getLaunchStatus.eql?("Available. Released 2020, May 14"), "Release Year not set correctly")
        tCell.setBodyDimensions = "160.4 x 76.6 x 7.8 mm (6.31 x 3.02 x 0.31 in)"
        assert_true(tCell.getBodyDimensions.eql?("160.4 x 76.6 x 7.8 mm (6.31 x 3.02 x 0.31 in)"), "Body dimensions not set correctly")
        tCell.setBodyWeight = "188 g (6.63 oz)"
        assert_true(tCell.getBodyWeight.eql?("188 g (6.63 oz)"), "Body weight not set correctly")
        tCell.setBodySim = "Hybrid Dual SIM (Nano-SIM, dual stand-by)"
        assert_true(tCell.getBodySim.eql?("Hybrid Dual SIM (Nano-SIM, dual stand-by)"), "Body Sim not set correctly")
        tCell.setDisplayType = "IPS LCD capacitive touchscreen, 16M colors"
        assert_true(tCell.getDisplayType.eql?("IPS LCD capacitive touchscreen, 16M colors"), "Display type not set correctly")
        tCell.setDisplaySize = "6.5 inches, 103.2 cm (~84.0% screen-to-body ratio)"
        assert_true(tCell.getDisplaySize.eql?("6.5 inches, 103.2 cm (~84.0% screen-to-body ratio)"), "Display Size not set correctly")
        tCell.setDisplayResolution = "1080 x 2340 pixels, 19.5:9 ratio (~397 ppi density)"
        assert_true(tCell.getDisplayResolution.eql?("1080 x 2340 pixels, 19.5:9 ratio (~397 ppi density)"), "Display Resolution not set correctly")
        tCell.setFeaturesSensors = "Fingerprint (rear-mounted), accelerometer, proximity, compass"
        assert_true(tCell.getFeaturesSensors.eql?("Fingerprint (rear-mounted), accelerometer, proximity, compass"), "Features Sensors not set correctly")
        tCell.setPlatformOS = "Android 9.0 (Pie), EMUI 9.1"
        assert_true(tCell.getPlatformOS.eql?("Android 9.0 (Pie), EMUI 9.1"), "OS not set correctly")
    end
end