RSpec::Matchers.define :be_geojson_point do |expected|
  match do |actual|
    result = actual["type"] == "Point"
    result &&= actual["coordinates"].join(",") == expected.join(",")
    result
  end
  description do
    result = "should have a 'type' = Point"
    result += "and have coordinates"
    result
  end
  failure_message_for_should do |actual|
    result = ""
    result += "should have type Point" if actual["type"] != "Point"
    result += "should have coordinates #{expected.join(",")}" if actual["coordinates"] != expected
    result
  end
end
