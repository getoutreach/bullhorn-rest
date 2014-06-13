# Bullhorn::Rest

[![Code Climate](https://codeclimate.com/github/MrMattWright/bullhorn-rest.png)](https://codeclimate.com/github/MrMattWright/bullhorn-rest)


Ruby wrapper for the [Bullhorn REST API](http://developer.bullhorn.com/articles/getting_started). For additional information on the API itself, see the official [Bullhorn documentation](http://developer.bullhorn.com/documentation).

## Installation

Add this line to your application's Gemfile:

    gem 'bullhorn-rest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bullhorn-rest

## Usage

```ruby
require 'bullhorn/rest'

client = Bullhorn::Rest::Client.new(username: '<USERNAME>', password: '<PASSWORD>', client_id: '<CLIENT_ID>', client_secret: '<CLIENT_SECRET>')

# Returns all candidates
client.candidates

# Returns all candidates belonging to the current user
client.user_candidates

# Returns all candidates belonging to the user's department
client.department_candidates

# Get data for a particular candidate
client.candidate(id)

# Geta for multiple candidates
client.candidate([id1, id2])

# Update a candidate
client.update_candidate(id, attributes)

# Create a candidate
client.create_candidate(attributes)

# Delete a candidate
client.delete_candidate(id)

# Query for candidates
client.query_candidates(where: "email = 'brogrammer@bigco.com'")
```

The above api methods generalize to all entities in the system. E.g. for the `JobOrder` entity simple replace occurences of `candidate` with `job_order` in all of the above methods.

### Entities

The following entities are exposed via the API:

* appointment
* appointment_attendee
* business_sector
* candidate
* candidate_certification
* candidate_education
* candidate_reference
* candidate_work_history
* category
* client_contact
* client_corporation
* corporate_user
* corporation_department
* country
* custom_action
* job_order
* job_submission
* note
* note_entity
* placement
* placement_change_request
* placement_commission
* sendout
* skill
* specialty
* state
* task
* tearsheet
* tearsheet_recipient
* time_unit

### User Entities

Additionally, the following entities have `user_<entity>` and `department_<entity>` methods available:

* candidate
* client_contact
* client_corporation
* job_order
* note
* placement

### Immutable Entities

The following entities are immutable and do not have any of the update/create/delete methods available:

* category
* corporate_user
* country
* skill
* specialty
* state
* time_unit

### Hashie's
By adding the magic that is: https://github.com/intridea/hashie we can now refer to the JSON responses directly in ruby. 
```
res = client.candidates 

start = res.start
total = res.total
```
You can go as deeply nested in the response as you like and all the array/collection goodness Ruby supports is yours. 

### Pagination

Any request that returns multiple items will be paginated to 100 items by default. Any query will return 500 by default. You can override these. 

In order to iterate through the entire result set page by page, you can use convenience methods: has_next_page? and next_page like in the following:
```
res = client.candidates 

while res.has_next_page?
  ... process response ...
  res.next_page
end
```
### Associations

"Has Many" associations can be accessed by passing in the name of the association in the `association` key of the options hash on the normal entity method. For instance, in order to get all of the candidates associated with a tearsheet:

```
candidates = client.tearsheet(id, association: 'candidates')
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/bullhorn-rest/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
