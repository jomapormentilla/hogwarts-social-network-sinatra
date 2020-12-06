class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table :houses do |t|
      t.string :name
      t.string :founder
      t.string :head_master
      t.string :mascot
    end

    create_table :wizards do |t|
      t.string :username
      t.string :name
      t.integer :balance
      t.integer :house_id
      t.integer :friend_id
    end

    create_table :spells do |t|
      t.string :name
      t.string :effect
      t.integer :price
    end

    create_table :wizard_spells do |t|
      t.integer :wizard_id
      t.integer :spell_id
    end

    create_table :wands do |t|
      t.string :name
      t.integer :price
      t.integer :wizard_id
    end

    create_table :posts do |t|
      t.string :title
      t.string :content
      t.datetime :timestamp
      t.integer :wizard_id
    end

    create_table :comments do |t|
      t.string :content
      t.datetime :timestamp
      t.integer :wizard_id
      t.integer :post_id
    end

    create_table :upvotes do |t|
      t.integer :wizard_id
      t.integer :post_id
    end
  end
end
