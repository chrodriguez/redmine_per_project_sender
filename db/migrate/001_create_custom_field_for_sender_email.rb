class CreateCustomFieldForSenderEmail < ActiveRecord::Migration
  def self.up
    c = CustomField.new(
      :name => 'project-sender-email',
      :editable => true,
      :visible => true,
      :field_format => 'string')
    c.type = 'ProjectCustomField' # cannot be set by mass assignement!
    c.save
  end

  def self.down
    CustomField.find_by_name('project-sender-email').delete
  end
end
