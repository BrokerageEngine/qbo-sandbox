# Qbo::Sandbox

### Stripped Down

This version of the library has been modified to take in a Qbo::Connection object. This removes all the code that setups up environments and connection logic.  That way they OAuth2 settings can be handled in a different path.

## FAQ

- What if I set they wrong credentials and copy entities from the sandbox to the production QuickBooks Online account?

    There is a bit of protection against [this] (https://github.com/minimul/qbo-sandbox/blob/master/lib/qbo/sandbox.rb#L31) but use of this library is at your own risk so be careful to set your credentials correctly.

- Will this library generate a ton of requests and hit API throttle requirements?

    No, to create the sandbox entities this library uses [batch requests](https://developer.intuit.com/docs/api/accounting/batch).

- My QBO Sub-customers, certain Items, etc. are not copying over to the sandbox?

    Name list and transaction entities that have references are going to fail because the reference id is not going to be available on the sandbox. This library is not going to support references anytime soon but pull requests are very welcome. This library is only tested with QuickBooks Online Customer, Vendor, and Items. Sub-customers and inventory items that have required references to accounts will not be copied to your sandbox.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To run the command locally:

```
bundle exec ./bin/qbo-sandbox vendors
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/minimul/qbo-sandbox.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

