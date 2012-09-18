Billomat API Client
===================

Simple but working API client for the [Billomat API](http://www.billomat.com/api/).

See the [API documentation][apidocu] for full documentation of all resources.

## Features

* Fast and easy access to all resources the API provides
  (not all resources are Ruby classes, yet)
* Full documentation.
* Test coverage as best as I can.
* Production-ready (it's for a job project).

## What's working right now

The basic Billomat class allows access to all resources. It includes no syntactic sugar to work with, instead it just returns the data as a hash. This works for basic usage.

The following resources are currently implemented as its own class:

* [clients](http://www.billomat.com/en/api/invoices/) (`Billomat::Client`)
* [invoices](http://www.billomat.com/en/api/invoices/) (`Billomat::Invoices`)

These are the two I need right now.
Implementing new resources is easy. Pull Requests for others are welcome.

## Requirements

Requirements are listed in the `Gemfile`.

## Examples

### Basic Usage

    bill = Billomat.new "billo", "18e40e14"
    # => #<Billomat:0x00000001319d30 ...>
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

    Billomat.new "billo", "18e40e14"

    Billomat::Invoice.all
    # => [#<Billomat::Invoice:0x000000024caf98 @id="1" @data={...}>],
          ...]

    invoice = Billomat::Invoice.find(1)
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

    Billomat::Invoice.create client_id: 1, date: "2012-09-18", note: "Thank you for your order", ...

## Documentation

For now the documentation is just inline.
Required Parameters and possible values won't be documentated here. See the [API documentation][apidocu] for that.

## Contribute

See `CONTRIBUTE.md` for info.

## License

See `LICENSE` for info.

[apidocu]: http://www.billomat.com/en/api/settings/
