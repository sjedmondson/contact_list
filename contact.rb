require 'csv'
require 'pry'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    @name = name
    @email = email
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      CSV.read("contacts.csv")
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      array = CSV.read("contacts.csv")
      next_id = array.length + 1
      new_contact = Contact.new(name, email)
      CSV.open("contacts.csv", "ab") do |row|
        row << [next_id, new_contact.name, new_contact.email]
      end
      new_contact
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      array = CSV.read("contacts.csv")
      array.find do |contact|
        # puts " DEBUG1: " + contact.to_s
        # puts " DEBUG2: #{contact[0] == 2}"
        # puts " #{contact[0].class} #{2.class}"
        contact[0].to_i == id
      end
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      array = CSV.read("contacts.csv")
      array.select do |contact|
        contact[1].include?(term) || contact[2].include?(term)
      end
    end

  end

end
