require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/todo')
require('./lib/list')
require('pg')

DB = PG.connect(dbname: 'to_do')
# connetced it to the database
get('/') do
  erb(:index)
end

get('/lists/new') do
  erb(:list_form)
end
# to display the list form

post('/lists') do
  name = params.fetch('name')
  list = List.new(name: name, id: nil)
  list.save
  erb(:success)
end
# fetches the name from the input
# the id is set to nil so as to let the db do the id assigning

get('/lists') do
  @lists = List.all
  erb(:lists)
end

get('/lists/:id') do
  @list = List.find(params.fetch('id').to_i)
  erb(:list)
end

post('/tasks') do
  description = params.fetch('description')
  list_id = params.fetch('list_id').to_i
  @list = List.find(list_id)
  @task = Task.new(description: description, list_id: list_id)
  @task.save
  erb(:success)
end
