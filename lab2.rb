require 'json'

# create database file if not exist function
def createDatabaseFile
  filename = 'users.json'
  if !File.exist?(filename)
    File.write(filename, [].to_json)
  end
end

# contactable module
module Contactable
  def contact_details
    "#{email} | #{mobile}"
  end
end

# person class
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  # validate person name function
  def valid_name?
    /^[a-zA-Z ]+$/.match?(name)
  end
end

# user class
class User < Person
  include Contactable
  attr_accessor :email, :mobile

  def initialize(name, email, mobile)
    super(name)
    @email = email
    @mobile = mobile
  end

  # create user function
  def create
    if valid_name?
      if self.class.valid_mobile?(mobile)
        allUsers = JSON.parse(File.read('users.json'))
        allUsers << { name: name, email: email, mobile: mobile }
        File.write('users.json', JSON.generate(allUsers))
        puts "Welcome #{name}"
        self
      else
        puts "Sorry, Mobile number is invalid"
      end
    else
      puts "Sorry, Name is invalid"
      false
    end
  end

  # validate user mobile number function
  def self.valid_mobile?(mobile)
    /^0\d{10}$/.match?(mobile)
  end

  # list users data function
  def self.list(n = 0)
    allUsers= JSON.parse(File.read('users.json'))
    if n > 0
      allUsers.first(n).each do |user|
        user = User.new(user['name'], user['email'], user['mobile'])
        puts "#{user.name} : #{user.contact_details}"
      end
    else
      allUsers.each do |user|
        user = User.new(user['name'], user['email'], user['mobile'])
        puts "#{user.name} : #{user.contact_details}"
      end
    end
  end

end

# prompt function
def prompt(message)
  print "#{message}: "
  gets.chomp
end

# user register function
def userRegister
  name = prompt('Enter Your Name')
  email = prompt('Enter Your Email')
  mobile = prompt('Enter Your Mobile')

  user = User.new(name, email, mobile)
  user.create
end

# list users data
def listUser
  input = prompt("Enter (*) to list all registered users or the number of users you would like to list")
  if input == '*'
    User.list
  elsif input.to_i> 0
    User.list(input.to_i)
  else
    print "invalid input"
  end
end

# calling functions

# call database file if not exists
createDatabaseFile

# call register user function
userRegister

# call list user function
listUser
