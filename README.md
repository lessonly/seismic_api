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

For now, please check out the inline documentation for usage. If you would like to help add some usage examples here from those, that would be awesome!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To generate docs, run `bundle exec yard doc`

To view docs, run `bundle exec yard server` and then go to [localhost:8808](localhost:8808) in your browser

There are a few things that have guided work so far:

- The clients are modular, so everything with "teamsites" is within a specific `Teamsites` client. It's possible that there are even divisions I could make in there?
- It does not raise exceptions based on http codes. This prevents us from using exceptions as control flow and defers to the user of the library on how to handle any give request (even in cases of 4xx or 5xx codes)

PRs are welcome!

Please squash the code in your PR down into a commit with a sensible message before requesting review (or after making updates based on review).

Here are some tips on good commit messages:
[Thoughtbot](https://thoughtbot.com/blog/5-useful-tips-for-a-better-commit-message)
[Tim Pope](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lessonly/seismic_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SeismicApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lessonly/seismic_api/blob/master/CODE_OF_CONDUCT.md).
