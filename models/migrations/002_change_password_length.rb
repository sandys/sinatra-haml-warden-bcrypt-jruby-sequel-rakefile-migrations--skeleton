Sequel.migration do
  up do
    alter_table(:users) do
      set_column_type :password, :varchar, {:size => 256, :null => false}
    end
  end
  down do
    alter_table(:users) do
      set_column_type :password, :varchar, {:size => 40, :null => false}
    end  end
end
