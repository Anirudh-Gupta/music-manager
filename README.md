# Assumptions!

   - An API hit with a url like <host>:<port>/../../../pink-floyd, should return the band information as well as the albums they released.. Retrieval of band by its name('-' separated, lower case) instead of Id.
   - A url hit to <host>:<port>/../../../dark-side-of-the-moon, shall return information of the album. Again, retrieval by name('-' separated, lower case).
   - Editing a band or an album uses the same params as used for creating it. Assumed that the same frontend form will be used for it and hence will get all the params. For example: editing just the website of a band requires the new website param as well as the old params as part of the request.
   - Edit and Delete Requests doesn't return anything in response with status as 204. Could have returned 200 with Entity as the response.
   - Followed Rest Routing Convention. Have kept Bands and Albums as nested resource. Refer to the attached Postman Collection Link.


Band Attributes :
  - Name : String
  - Members: Text (Input Array, Serialized and stored as text in DB)
  - Origin: String
  - Website - String
  - Years Active - String
  
Album Attributes: 
  - Title : String
  - Year: Int
  - Genre: String
  - Number of Tracks - Int
  - Number of Discs - Int
  - BandId - Int

### Language Specs

* [Rails 5.0.6] 
* [Ruby 2.3.1] 
* [Rspec-rails] - For Unit Tests.
* [Mysql] - Datastore
* [Puma] - Default App Server


### Installation
Install the dependencies and devDependencies and start the server.

```sh
$ cd music-manager
$ bundle install
$ export DATABASE_USERNAME = 'your mysql username'
$ export DATABASE_PASSWORD = 'your mysql password'
$ rake db:create db:migrate
$ bundle exec rspec - for running unit tests.
$ rails s
```

### Postman Collection Link

[Import] (https://www.getpostman.com/collections/638a45e7b5e8d2a8a5b9)




