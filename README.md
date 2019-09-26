# Changelog

_Stop the changelog merge conflict madness!_

This tool helps you maintaining a CHANGELOG by creating one file per entry and
bundling them together before you release a new version of your application.

This tool was inspired by the article '[How we solved GitLab's CHANGELOG conflict crisis](https://about.gitlab.com/2018/07/03/solving-gitlabs-changelog-conflict-crisis/)' from Gitlab. And yeah well I used some of their code too... At this point, I want to say thank you to the Gitlab team for the great work you guys are doing. 👏👏👏

## Installation

Install _changelog_ using

```shell
gem install changelog-madness
```

## Usage

### New Entry

Create a new entry by running

```shell
changelog 

#this is an alias for `changelog gen`
```

this will create a new file in the `changelogs/unreleased/` folder.

Run `changelog help gen` to see all available options

### Bundling

Bundle all the unreleased entries by running

```shell
# changelog bundle <VERSION>
changelog bundle 2.3.1
```

this will create or update the `CHANGELOG.md`

Run `changelog help bundle` to see all available options

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KiloKilo/changelog. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Changelog project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/KiloKilo/changelog/blob/master/CODE_OF_CONDUCT.md).
