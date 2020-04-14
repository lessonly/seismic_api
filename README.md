# SeismicAPI

SeismicAPI is a wrapper around the API Seismic exposes for integrations. It was extracted from the Lessonly connector to Seismic.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'seismic_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seismic_api

## Usage

There is a base client class that you can access parts of the API through. For example, you can access teamsites:

```
SeismicAPI::Client.new(oauth_token: "token").teamsites.all
```

You can also access the teamsite client directly:

```
SeismicAPI::Teamsites.new(oauth_token: "token").all
```

The attributes for the any particular endpoint mimic the structure and style (using camel case) found in the Seismic docs. For example, to add url content to a teamsite:

```
SeismicAPI::Teamsites.new(oauth_token: "token").add_url(
  teamsiteId: "1",
  name: "My Link",
  url: { url: "www.google.com", openInNewWindow: true }
)
```

Documentation for each of the endpoints individually is available inline with the code (you can also optionally generate docs from that in line documentation locally)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To generate docs, run `bundle exec yard doc`

To view docs, run `bundle exec yard server` and then go to [localhost:8808](localhost:8808) in your browser

There are a few things that have guided work so far:

- The clients are modular, so everything with "teamsites" is within a specific `Teamsites` client. It's possible that there are even divisions I could make in there?

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lessonly/seismic_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Please squash the code in your PR down into a commit with a sensible message before requesting review (or after making updates based on review).

Here are some tips on good commit messages:
[Thoughtbot](https://thoughtbot.com/blog/5-useful-tips-for-a-better-commit-message)
[Tim Pope](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)

Once you are ready for review, ping the @lessonly/apps team to get our attention.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SeismicApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lessonly/seismic_api/blob/master/CODE_OF_CONDUCT.md).
