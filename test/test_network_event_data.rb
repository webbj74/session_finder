require 'test/unit'
require 'session_finder/network_event_data'

class TestNetworkEventDataCSV < Test::Unit::TestCase
    def test_NetworkEventData_csv
       network_event_data = NetworkEventData.new({}, {})
       expected = network_event_data.csv
       assert_equal expected, ", "

       network_event_data = NetworkEventData.new({'foo' => 'bar'}, {})
       expected = network_event_data.csv
       assert_equal expected, ", "

       network_event_data = NetworkEventData.new({'foo' => 'bar'}, {'foo' => nil})
       expected = network_event_data.csv
       assert_equal expected, "bar, "

       network_event_data = NetworkEventData.new({'foo' => 'bar','foo2' => {'foo3' => 'bar3'}}, {'foo' => nil, 'foo2' => {'foo3' => nil}})
       expected = network_event_data.csv
       assert_equal expected, "bar, bar3, , "
    end

    def test_NetworkEventData_csv_head
       network_event_data = NetworkEventData.new({}, {})
       expected = network_event_data.csv_head
       assert_equal expected, ", #{network_event_data.class.name} data"

       network_event_data = NetworkEventData.new({'foo' => 'bar'}, {})
       expected = network_event_data.csv_head
       assert_equal expected, ", #{network_event_data.class.name} data"

       network_event_data = NetworkEventData.new({'foo' => 'bar'}, {'foo' => nil})
       expected = network_event_data.csv_head
       assert_equal expected, "foo, #{network_event_data.class.name} data"

       network_event_data = NetworkEventData.new({'foo' => 'bar','foo2' => {'foo3' => 'bar3'}}, {'foo' => nil, 'foo2' => {'foo3' => nil}})
       expected = network_event_data.csv_head
       assert_equal expected, "foo, foo3, NetworkEventData data, NetworkEventData data"
    end
end

