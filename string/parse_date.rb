require 'date'
require 'chronic'

def parse_date_str(date_str)
  (Chronic.parse(date_str) || Date.parse(date_str)).to_date
end

p parse_date_str '20110101'
p parse_date_str 'yesterday'
p parse_date_str '1 week ago'
