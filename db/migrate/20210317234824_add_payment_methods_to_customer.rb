class AddPaymentMethodsToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :payment_methods, :string
  end
end
