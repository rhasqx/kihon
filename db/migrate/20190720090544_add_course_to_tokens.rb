class AddCourseToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :course, :string
  end
end
