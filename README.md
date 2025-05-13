# Collaborative Text Editor

## Install Ruby:

[Download Ruby](https://rubyinstaller.org/downloads/)

## Install Rails using gem:

```bash
gem install rails
```

##  Setup Rails Project

# Create new Rails project with PostgreSQL
```bash
rails new collaborative-editor --database=postgresql --webpack=react
```

## Install additional dependencies:

```bash
bundle add redis
bundle add sidekiq
```

## To create test and development databases:

```bash
rails db:create

rails db:migrate
```

## Example usage:

```bash
# Creating a document
doc = Document.create(content: "Hello", version: 1)

# Inserting text
operation = OpenStruct.new(type: :insert, position: 5, text: " World")
doc.apply_operation(operation)
# Result: "Hello World"

# Deleting text
operation = OpenStruct.new(type: :delete, position: 5, length: 6)
doc.apply_operation(operation)
# Result: "Hello"
```
## Let's set up the WebSocket channel for real-time communication. We'll create this step by step

# First, generate the Action Cable channel:
```bash
rails generate channel Document
```

## We'll create two main operation types: Insert and Delete for our collaborative text editor

```bash
app/operations/insert_operation.rb
app/operations/delete_operation.rb
app/operations/transform_utility.rb
```
## These operations handle:
Inserting text at a specific position <br>
Deleting text from a specific position<br>
Transforming operations when they conflict<br>
Handling overlapping deletions<br>
Maintaining consistency across all clients
