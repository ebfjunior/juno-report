require 'juno-report'

data = [
    {:test_field1 => 'Test Value 1', :test_field2 => "Test Value 1", :test_field3 => 50, :group_field1 => 'Group 1', :group_field2 => 'Subgroup 1'},
    {:test_field1 => 'Test Value 2', :test_field2 => "Test Value 2", :test_field3 => 16, :group_field1 => 'Group 1', :group_field2 => 'Subgroup 1'},
    {:test_field1 => 'Test Value 5', :test_field2 => "Test Value 3", :test_field3 => 7, :group_field1 => 'Group 1', :group_field2 => 'Subgroup 1'},
    {:test_field1 => 'Test Value 3', :test_field2 => "Test Value 9", :test_field3 => 10, :group_field1 => 'Group 1', :group_field2 => 'Subgroup 2'},
    {:test_field1 => 'Test Value 3', :test_field2 => "Test Value 2", :test_field3 => 4, :group_field1 => 'Group 1', :group_field2 => 'Subgroup 2'},
    {:test_field1 => 'Test Value 9', :test_field2 => "Test Value 4", :test_field3 => 10, :group_field1 => 'Group 1', :group_field2 => 'Subgroup 2'},
    {:test_field1 => 'Test Value 7', :test_field2 => "Test Value 5", :test_field3 => 5, :group_field1 => 'Group 1', :group_field2 => 'Subgroup 3'},
    {:test_field1 => 'Test Value 3', :test_field2 => "Test Value 5", :test_field3 => 2, :group_field1 => 'Group 1', :group_field2 => 'Subgroup 3'},
    {:test_field1 => 'Test Value 3', :test_field2 => "Test Value 2", :test_field3 => 27, :group_field1 => 'Group 2', :group_field2 => 'Subgroup 1'},
    {:test_field1 => 'Test Value 3', :test_field2 => "Test Value 5", :test_field3 => 2, :group_field1 => 'Group 2', :group_field2 => 'Subgroup 1'},
    {:test_field1 => 'Test Value 0', :test_field2 => "Test Value 4", :test_field3 => 13, :group_field1 => 'Group 2', :group_field2 => 'Subgroup 1'},
    {:test_field1 => 'Test Value 4', :test_field2 => "Test Value 7", :test_field3 => 7, :group_field1 => 'Group 2', :group_field2 => 'Subgroup 1'},
    {:test_field1 => 'Test Value 1', :test_field2 => "Test Value 3", :test_field3 => 28, :group_field1 => 'Group 2', :group_field2 => 'Subgroup 1'},
    {:test_field1 => 'Test Value 4', :test_field2 => "Test Value 5", :test_field3 => 4, :group_field1 => 'Group 2', :group_field2 => 'Subgroup 2'},
    {:test_field1 => 'Test Value 5', :test_field2 => "Test Value 6", :test_field3 => 24, :group_field1 => 'Group 2', :group_field2 => 'Subgroup 2'}
]

JunoReport::generate(data, :report => 'report')