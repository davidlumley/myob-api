# MYOB Api

[MYOB Api](https://github.com/davidlumley/myob-api) is an interface for accessing [MYOB](http://developer.myob.com/api/accountright/v2/)'s  AccountRight Live API.

## Installation

Add this line to your application's Gemfile:

    gem 'myob-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install myob-api

## Usage

### OAuth Authentication

If you've already got an OAuth access token, feel free to skip to API Client Setup.

The MYOB API uses 3 legged OAuth2. If you don't want to roll your own, or use the [OmniAuth strategy](https://github.com/davidlumley/omniauth-myob) you can authenticate using the `get_access_code_url` and `get_access_token` methods that [ghiculescu](https://github.com/ghiculescu) has provided like so:

    class MYOBSessionController  
      def new
        redirect_to myob_client.get_access_code_url
      end

      def create
        @token         = myob_client.get_access_token(params[:code])
        @company_files = myob_client.company_file.all
        # then show the user a view where they can log in to their company file
      end

      def myob_client
        @api_client = Myob::Api::Client.new({
          :consumer => {
            :key    => YOUR_CONSUMER_KEY,
            :secret => YOUR_CONSUMER_SECRET,
          },
        })
      end
    end

### API Client Setup

Create an api_client:

    api_client = Myob::Api::Client.new({
      :consumer => {
        :key    => YOUR_CONSUMER_KEY,
        :secret => YOUR_CONSUMER_SECRET,
      },
      :access_token => YOUR_OAUTH_ACCESS_TOKEN,
    })

If you have a refresh token (the Myob API returns one by default) you can use that too:

    api_client = Myob::Api::Client.new({
      :consumer => {
        :key    => YOUR_CONSUMER_KEY,
        :secret => YOUR_CONSUMER_SECRET,
      },
      :access_token  => YOUR_OAUTH_ACCESS_TOKEN,
      :refresh_token => YOUR_OAUTH_REFRESH_TOKEN,
    })

Or if you know which Company File you want to access too:

    api_client = Myob::Api::Client.new({
      :consumer => {
        :key    => YOUR_CONSUMER_KEY,
        :secret => YOUR_CONSUMER_SECRET,
      },
      :access_token  => YOUR_OAUTH_ACCESS_TOKEN,
      :refresh_token => YOUR_OAUTH_REFRESH_TOKEN,
      :company_file  => {
        :name     => COMPANY_FILE_NAME,
        :username => COMPANY_FILE_USERNAME,
        :password => COMPANY_FILE_PASSWORD,
      },
    })

### API Methods

#### Company Files

Before using the majority of API methods you will need to have selected a Company File. If you've already selected one when creating the client, feel free to ignore this.

Return a list of company files:

    api_client.company_file.all

Select a company file to work with

    api_client.select_company_file({
      :id       => COMPANY_FILE_ID,
      :username => COMPANY_FILE_USERNAME,
      :password => COMPANY_FILE_PASSWORD,
    })

####  Contacts

Return a list of all contacts

    api_client.contact.all

#### Customers

Return a list of all customers (a subset of contacts)

    api_client.customer.all

#### Employees

Return a list of all employees

    api_client.employee.all

#### Creating an entity

To create a new entity, call #save on its model, passing through a hash that represents the entity. Refer to the MYOB API documentation for required fields.

    api_client.employee.save({'FirstName' => 'John', 'LastName' => 'Smith', 'IsIndividual' => true})

#### Updating an entity

To update an existing entity, call #save on its model, passing through a hash you got from the API. This hash should include a `UID` parameter (which is included by default when you get the data).
  
    user = api_client.employee.all["Items"].last
    user['FirstName'] = 'New First Name'
    api_client.employee.save(user)


## Todo

* Expand API methods
* Refactor client factory architecture
* Tests


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
