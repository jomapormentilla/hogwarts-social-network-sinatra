# Hogwarts Social Network - Sinatra Edition
Phase Two Project for Flatiron School's Software Engineering Bootcamp Program. This application allows a User to create a Hogwarts account, which allows them to
- add or remove Friends
- create, edit, and delete Posts
- leave Comments or Upvotes on Posts
- view other wizard profiles
- edit or delete their own profile
- purchase Wands and Spells in the Hogwarts Shop (using Hogwarts currency)

## Requirements
[Ruby](https://www.ruby-lang.org/en/)

## Installation
Clone this repository into your developer environment, then install the required Ruby Gems using the following command:
```ruby
bundle install
```
In order to populate the database with information, you'll need to run the seed file using this command:
```ruby
rake db:seed
```

## Usage
This application uses 'shotgun' to run a local server. Type the following in your terminal:
```ruby
shotgun
```
With the server running, open up your favorite web browser and navigate to the following URL:
```ruby
http://localhost:9393
```
Sign up for an account on the Sign Up page, and you're all set to explore the Hogwarts Social Network.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This CLI project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## API & Web References
http://hp-api.herokuapp.com/api/

https://www.pojo.com/harry-potter-spell-list/

https://pottermore.fandom.com/wiki/Houses
