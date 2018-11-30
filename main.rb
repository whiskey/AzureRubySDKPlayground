require 'azure_sdk'

options = {
    tenant_id: ENV['AZURE_TENANT_ID'],
    client_id: ENV['AZURE_CLIENT_ID'],
    client_secret: ENV['AZURE_CLIENT_SECRET'],
    subscription_id: ENV['AZURE_SUBSCRIPTION_ID']
}

client = Azure::Profiles::V2017_03_09::Mgmt::Client.new(options)
client.resource_groups.list.value.each{ |group| print_item(group) }

### Helpers

def print_item(group)
  puts "\tName: #{group.name}"
  puts "\tId: #{group.id}"
  puts "\tLocation: #{group.location}"
  puts "\tTags: #{group.tags}"
  print_properties(group.properties)
end

def print_properties(props)
  puts "\tProperties:"
  props.instance_variables.sort.each do |ivar|
    str = ivar.to_s.gsub /^@/, ''
    if props.respond_to? str.to_sym
      puts "\t\t#{str}: #{props.send(str.to_sym)}"
    end
  end
  puts "\n\n"
end
