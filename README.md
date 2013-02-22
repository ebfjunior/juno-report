# Juno Report

A simple, but efficient, YAML based report generator

## Installation

Add this line to your application's Gemfile:

    gem 'juno-report'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install juno-report

## Usage

The generating reports is based on a YAML file with all rules, with the fields and their settings, divided by sections.

### Body section

Represents the records which will be iterated to report generating

```yaml
# example.yml
body:
  settings: {posY: 40, height: 25}
  fields:
    test_field1: [10]
    test_field2: [220]
    test_field3: [430, {column: "Named Test Field 3"}]
  footer:
    label_total: [10, {value: "Total"}]
    totalizer: [220, {behavior: count}]
    test_field3: [430, {behavior: sum}]
```
The [body] section ***must*** have three rules:

* `settings`: Defines some configurations for body, like their height and ypos.
* `fields`: Describes each field of record to be iterated.
* `footer`: Drawn at the end of all printed records and calculates fields according behavior parameter.

Each of these rules receives a array, where the first position is an integer representing the field horizontal position and
the second position is a hash with some configurations.


##### Settings

* `height`: Set the of each row at report [Integer].
* `posY`: Relative vertical position of last row at report [Integer].
* `groups`: Describes which groups will be printed (More bellow) [Array].

##### Fields

* `size`: Font size of the field [Integer].
* `align`: Defines the text alignment for each value [left|center|right].
* `font`: Juno Report supports all font type provided by Prawn gem (See more in http://rubydoc.info/gems/prawn/Prawn/Font/AFM).
* `style`:  Stylistic variations of a font [bold|italic].
* `value`: Fixed text to be printed [string].
* `column`: The header are "humanized" automatically, but you can set other value manually [string].

##### Footer

* `behavior`: Specify a function to be performed, sending as parameter the fieldname value [string].
* `label`: Preppends a text to fieldname value specified [string].
* `value`: Fixed text to be printed (fieldname value will be ignored) [string].

### Page section

You may want to print a title every time that a page is created. You simply insert a [page] section. 

```yaml
# example.yml
page:
  fields:
    title1: [260, {size: 24, align: center, value: "Test Report"}]
    subtitle1: [260, {size: 20, posY: 20, align: center, value: "Generated by Juno Report"}]
body:
  settings: {posY: 40, height: 25}
  fields:
    test_field1: [10]
    test_field2: [220]
    test_field3: [430, {column: "Named Test Field 3"}]
  footer:
    label_total: [10, {value: "Total"}]
    totalizer: [220, {behavior: count}]
    test_field3: [430, {behavior: sum}]
```


## Contributors

2. Edson Júnior (http://github.com/ebfjunior)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

