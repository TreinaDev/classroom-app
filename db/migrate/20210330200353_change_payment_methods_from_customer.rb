class ChangePaymentMethodsFromCustomer < ActiveRecord::Migration[6.1]
  def change
    change_column :customers, :payment_methods, :integer
  end
end
