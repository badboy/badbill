BadBill - Billomat API Client
===================

Simple but working API client for the [Billomat API][apidocu].

See the [API documentation][apidocu] for full documentation of all resources.

## Features

* Fast and easy access to all resources the API provides
  (not all resources are Ruby classes, yet)
* Full documentation.
* Test coverage as best as I can.
* Production-ready (it's for a job project).

## What's working right now

The basic BadBill class allows access to all resources. It includes no syntactic sugar to work with, instead it just returns the data as a hash. This works for basic usage.

The following resources are currently implemented as its own class:

* [clients](http://www.billomat.com/en/api/invoices/) (`BadBill::Client`)
* [invoices](http://www.billomat.com/en/api/invoices/) (`BadBill::Invoices`)

These are the two I need right now.
Implementing new resources is easy. Pull Requests for others are welcome.

## Requirements

* [yajl-ruby](https://github.com/brianmario/yajl-ruby)
* [faraday](https://github.com/technoweenie/faraday)
* [faraday_middleware](https://github.com/pengwynn/faraday_middleware)
* [hashie](https://github.com/intridea/hashie)

## Examples

### Basic Usage

    bill = BadBill.new "billo", "18e40e14"
    # => #<BadBill:0x00000001319d30 ...>
    bill.get 'settings'
    # => {"settings"=>
    #   {"invoice_intro"=>"",
    #    "invoice_note"=>"",
    #    ...}}
    bill.put 'settings', settings: { invoice_intro: "Intro" }
    # => {"settings"=>
    #   {"invoice_intro"=>"Intro",
    #    "invoice_note"=>"",
    #    ...}}

### Using defined resource classes

    BadBill.new "billo", "18e40e14"

    BadBill::Invoice.all
    # => [#<BadBill::Invoice:0x000000024caf98 @id="1" @data={...}>], ...]

    invoice = BadBill::Invoice.find(1)
    invoice.pdf
    # => {"id"=>"1",
    #     "created"=>"2012-09-17T13:58:42+02:00",
    #     "invoice_id"=>"322791",
    #     "filename"=>"Invoice 322791.pdf",
    #     "mimetype"=>"application/pdf",
    #     "filesize"=>"90811",
    #     "base64file"=>"JVBERi0xLjM..."}
    invoice.delete
    # => true

    BadBill::Invoice.create client_id: 1, date: "2012-09-18", note: "Thank you for your order", ...

## Documentation

Documentation is online at [rubydoc.info](http://rubydoc.info/github/badboy/badbill/master/frames).

Generate locale documentation with `rake doc` ([yard](http://yardoc.org/) required).
Required Parameters and possible values won't be documentated here. See the [API documentation][apidocu] for that.

## Contribute

See [CONTRIBUTING.md](/badboy/badbill/blob/master/CONTRIBUTING.md) for info.

## License

See [LICENSE](/badboy/badbill/blob/master/LICENSE) for info.

[apidocu]: http://www.billomat.com/en/api/
