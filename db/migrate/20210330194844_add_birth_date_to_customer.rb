class AddBirthDateToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :birth_date, :date
  end
end
