
class Enumeration < ActiveRecord::Base
  validates_columns :color, :severity, :string_field, :int_field
end
