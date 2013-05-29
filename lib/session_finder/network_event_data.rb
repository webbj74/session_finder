
class NetworkEventData

  def initialize(data, attributes, caller = "", debug = false)
    @caller = caller
    @debug = debug
    @attributes = Hash.new("undefined")
    attributes.keys.each do |attribute|
      if attributes[attribute].is_a?(Hash)
        @attributes[attribute] = self.class.new(data.delete(attribute) || {}, attributes[attribute], @caller + "#{attribute}:", debug)
      elsif attributes[attribute] == true
        @attributes[attribute] = data.delete(attribute)
      end
    end
    @leftovers = data.empty? ? nil : "#@caller:#{data}"
  end

  def csv
    csv_prepare = []
    @attributes.values.each do |x|
      csv_prepare.push(x.is_a?(NetworkEventData) ? x.csv : ("\"#{x}\""))
    end
    csv_prepare.join(", ") + (@debug ? ", #@leftovers" : "")
  end

  def csv_head
    csv_prepare = []
    @attributes.keys.each do |x|
      csv_prepare.push(@attributes[x].is_a?(NetworkEventData) ? @attributes[x].csv_head : x)
    end
    csv_prepare.join(", ") + (@debug ? ", #@caller data" : "")
  end

end
