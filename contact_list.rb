require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  def initialize

    #menu
    case ARGV[0]
    when "list"
      puts Contact.all
    when "show"
      puts Contact.find(ARGV[1].to_i)
    when "search"
      result = Contact.search(ARGV[1])
      result.each {|row| puts row}
    when "new"
      puts "Please enter the full name of the new contact"
      name = STDIN.gets.strip 
      puts "Please enter the contact's e-mail address"
      email = STDIN.gets.strip
      puts Contact.create(name, email)
    when "update"
      contact = Contact.find(ARGV[1].to_i)
      puts "Please enter new full name"
      contact.name = STDIN.gets.strip
      puts "Please enter new email address"
      contact.email = STDIN.gets.strip
      contact.save
    when "delete"
      contact = Contact.find(ARGV[1].to_i)
      contact.destroy
    else
      menu
    end
  end

  def menu
    puts "Here is a list of available commands:"
    puts ""
    puts "new    - Create a new contact"
    puts "list   - List all contacts"
    puts "show   - Show an individual contact"
    puts "search - Search contacts"
    puts "update - Update an existing contact"
    puts "delete - Delete a contact"
  end  

end

# p Contact.create("Jeremy", "legendinhisownmind@gmail.com")
# p Contact.find(2)
# p Contact.search("imon")

ContactList.new
