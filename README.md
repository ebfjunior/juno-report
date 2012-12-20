# Juno Reports

A simple, but efficient, YAML based report generator

## Installation

Add this line to your application's Gemfile:

    gem 'juno-report'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install juno-report

## Usage

The generating reports is based on a YAML file with all rules, wiht the fields and their settings.

Rules are divided by sections, and the basic structure to generates a report is:

```yaml
# example.yml
body:
  settings: {posY: 40, height: 25}
  fields:
    test_field1: [10]
    test_field2: [220]
    test_field3: [450, {column: "Named Test Field 3"}]
  footer:
    label_total: [5, {text: "Total"}]
    totalizer: [200, {behavior: count}]
    campo4: [450, {behavior: sum}]
```
The [body] section represents the record which will be iterated to report generating and ***must*** have more three rules:

* `settings (required)`: Defines some configurations for body, like their height and ypos.
* `fields (required)`: Describes each field of record to be iterated.
* `footer (required)`: Drawn at the end of all printed records and calculates fields according behavior parameter.

You may want to print a title every time that a page is created. You simply insert a [page] section. 

The [page] section have follow rules:

* `fields`: 


## Contributors

2. Edson Júnior (http://github.com/ebfjunior)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

