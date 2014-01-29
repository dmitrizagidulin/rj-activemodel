require 'test_helper'

describe "an Active Document" do
  it "can be composed of other embedded ActiveDocuments" do
    address_book = AddressBook.new user_key: 'earl-123'
    c1 = Contact.new contact_name: 'Joe', contact_email: 'joe@test.net'
    c2 = Contact.new contact_name: 'Jane', contact_email: 'jane@test.net'
    address_book.contacts << c1
    address_book.contacts << c2
    json_str = address_book.to_json_document
    
    new_book = AddressBook.from_json json_str
    new_book.contacts.count.must_equal 2
    contact = new_book.contacts.first
    contact.contact_name.must_equal 'Joe'
    contact.must_be_kind_of Contact
  end
end