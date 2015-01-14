class CreateRelatedWords < ActiveRecord::Migration
  def change
    create_table :related_words do |t|
      t.string :title

      t.timestamps
    end
  end
end
