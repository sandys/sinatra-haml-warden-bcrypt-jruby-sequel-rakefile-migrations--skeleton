Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      text :username, :unique => true, :null => false
      text :email, :unique => true, :null => false
      varchar :password, :size => 40, :null => false
      text :salt, :default => true, :null => true
      boolean :disabled, :default => false
      timestamp :created_at
      timestamp :updated_at
    end
  end
  down do
    drop_table(:users)
  end
end
