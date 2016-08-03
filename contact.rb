require 'csv'
require 'pry'
require 'pg'

class Contact

  @@connection = nil

  attr_reader :id
  attr_accessor :name, :email
  
  def initialize(row={})
    @id = row["id"]
    @name = row["name"]
    @email = row["email"]
  end

  def to_s
    "ID: #{id} Name: #{name}"
  end

  def save
    if id
      result = Contact.connection.exec_params(
        'UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int', 
        [name, email, id]
      )
    else
      result = Contact.connection.exec_params(
        'INSERT INTO contacts (name, email) VALUES ($1, $2)', 
        [name, email]
      )
    end
  end

  def destroy
    result = Contact.connection.exec_params(
      'DELETE FROM contacts WHERE id = $1::int', 
      [id]
    )
  end

  class << self

    def connection
      @@connection = @@connection || PG.connect(
      host: 'localhost',
      dbname: 'contact_list',
      user: 'development',
      password: 'development'
      )
    end

    def all
      result = Contact.connection.exec('SELECT * FROM contacts')
      result.each { |row| puts row }
    end

    def create(name, email)
      new_contact = Contact.new(name, email)
      new_contact.save
      new_contact
    end
    
    def find(id)
      result = Contact.connection.exec_params('SELECT * FROM contacts WHERE id = $1::int', [id])
      if result.ntuples == 1
        Contact.new(result[0])
      else
        "The ID #{id} does not exist"
      end
    end
    
    def search(term)
      result = Contact.connection.exec_params('SELECT * FROM contacts WHERE name ILIKE $1 ORDER BY id', ["%#{term}%"])
      if result.ntuples >= 1
        Contact.new(result.first)
      else
        "There are no matches for #{term}"
      end
      # array = CSV.read("contacts.csv")
      # array.select do |contact|
      #   contact[1].include?(term) || contact[2].include?(term)
      # end
    end

  end

end
