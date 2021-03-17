class AddColumnToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :full_name, :string
    add_column :customers, :cpf, :string, unique: true
    add_column :customers, :age, :integer
  end
end
