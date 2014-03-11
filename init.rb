require 'redmine'
require 'mailer_patch'

Redmine::Plugin.register :redmine_per_project_sender do
  name 'Redmine per Project Sender plugin'
  author 'Christian A. Rodriguez'
  description 'Redmine per Project Sender plugin for overriding notification settings per project'
  version '0.0.1'
  requires_redmine :version_or_higher => '2.3.0'
end
