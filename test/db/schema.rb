
ActiveRecord::Schema.define do
  drop_table :enumerations
  
  create_table :enumerations, :force => true do |t|
    t.column :severity, :enum, :limit => [:low, :medium, :high, :critical],
       :default => :medium
    t.column :color, :enum, :limit => [:red, :blue, :green, :yellow]
    t.column :string_field, :string, :limit => 8, :null => false
    t.column :int_field, :integer
  end
end
