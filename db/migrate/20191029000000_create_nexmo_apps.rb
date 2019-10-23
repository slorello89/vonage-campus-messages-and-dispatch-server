class CreateNexmoApps < ActiveRecord::Migration[6.0]
  def change
    create_table :nexmo_apps do |t|

      t.string :api_key
      
      t.string :app_id
      t.string :name
      t.text   :public_key
      t.text   :private_key

      t.string :inbound_url
      t.string :inbound_url_method
      t.string :status_url
      t.string :status_url_method

      t.string :number_msisdn
      t.string :number_country

      t.string :whatsapp_number
      t.string :viber_id

      t.timestamps
    end

    add_index :nexmo_apps, :app_id, unique: true
  end
end
