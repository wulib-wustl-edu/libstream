# LibStream (Streaming Reserves application)

> This application allows library staff to upload music and video files to the University Library
Wowza Server as requested by Faculty for Course Reserves materials (on a semester basis). The uploaded files
can be streamed to students in the faculty's classes via links provided in the Ares Course Reserves systems.

## Prerequisites:

- [Wowza Streaming Reserves Engine application & server](https://www.wowza.com/docs/wowza-streaming-engine-getting-started)
- [JW Player Account and API keys](jwplayer.com)
- AD/LDAP connections with Devise Gem (variables set in devise's ldap.yml file)
- Note: for email alert functionality, you will need an SMTP email account
- FreeTDS is required for the Tiny_TDS gem to install.
    - [TinyTDS](https://www.rubydoc.info/gems/tiny_tds/0.7.0)
    - [FreeTDS](http://www.freetds.org/userguide/install.htm)
    - FreeTDS via Homebrew:

            $ brew install freetds

- Ruby version: ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin17]
- Bundler needs to be installed

## Installation:

Once prerequisites are in place:

1. Clone git repo to your localhost

            $ git clone <git project url>

2. Move to project directory & run bundle install

            $ cd project_name
            $ bundle install

3. Supply application.yml file and ldap.yml file required for devise ldap configuration, Wowza, and JW Player configuration

4. Run DB:Migrate

            $ rails db:migrate

5. Test running development server

            $ rails s

6. Navigate to localhost:3000 in your browser



## Tests

> Tests are written using Rails default Minitests

For example, to run model tests:

            $ rails test test/models/resource_test.rb

## Deployment

> Currently, we use Passenger/Nginx/Rbenv deployment with Ansible Playbook

## Built with:

- Rails 5.1.6
- [Jquery File Upload Plugin](https://github.com/blueimp/jQuery-File-Upload)
- See Gemfile for other dependencies
- Tiny_TDS is used to connect to Ares Course Reserve Database
- See Prerequisites


## License

LibStream is available under MIT License. See License.md.

