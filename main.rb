require 'azure_sdk'
require 'azure_mgmt_resources'
require 'rspec'

module SpecHelper
  class Azure
    ##
    # See https://github.com/Azure/azure-sdk-for-ruby
    class SDK
      ##
      # Azure client that allows direct access to the underliyng SDK
      # @param [Object] clazz The Azure class to use, e.g. `Azure::Compute`
      # @param [Object] version The SDK version to use. Defaults to `Latest`
      # @param [String] tenant_id Azure credentials from env vars
      # @param [String] client_id Azure credentials from env vars
      # @param [String] client_secret Azure credentials from env vars
      # @param [String] subscription_id Azure credentials from env vars
      def self.client(clazz, version = :Latest, tenant_id = ENV['AZURE_TENANT_ID'],  client_id = ENV['AZURE_CLIENT_ID'],
                 client_secret = ENV['AZURE_CLIENT_SECRET'], subscription_id = ENV['AZURE_SUBSCRIPTION_ID'])
        options = {
            tenant_id: tenant_id,
            client_id: client_id,
            client_secret: client_secret,
            subscription_id: subscription_id
        }
        client_clazz = Module.const_get(clazz.to_s + '::Profiles::' + version.to_s + '::Mgmt::Client')
        client_clazz.new(options)
      end
    end
  end
end


profile_client = SpecHelper::Azure::SDK.client(Azure::Resources)
profile_client.resource_groups.list.each do |group|

  describe group do
    it "#{group.name} has a valid name" do
      expect(group.name).to be_truthy
    end

    it "#{group.name} has a valid location" do
      expect(group.location).to be_truthy
      # EU-only locations
      expect(%w(northeurope westeurope francecentral)).to include(group.location)
    end

    it "#{group.id} should have proper tagging" do
      tags = group.tags
      #expect(tags&.has_key?(:Name)).to be_truthy
      expect(tags&.has_key?(:Owner)).to be_truthy
      expect(tags&.has_key?(:EnvironmentType)).to be_truthy
    end
  end

end
