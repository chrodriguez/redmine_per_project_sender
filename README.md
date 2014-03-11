# Redmine Per Project Sender

Per Project Sender plugin for redmine. Adds project configuration parameter to specify a different email 
address to be used when notifying users.
From addres can now be specify per project configuration and not as a global
configuration.
This feature is achieved using  the custom field 'project-sender-email'

## Redmine versions

* 2.3 or high

## Installation

To install the plugin clone the repo from github and migrate the database:

```
cd /path/to/redmine/
git clone git://github.com/chrodriguez/redmine_per_project_sender.git plugins/redmine_per_project_sender
rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_per_project_sender
```

To uninstall the plugin migrate the database back and remove the plugin:

```
cd /path/to/redmine/
rake redmine:plugins:migrate NAME=redmine_per_project_sender VERSION=0 RAILS_ENV=production
rm -rf plugins/redmine_per_project_sender
```


