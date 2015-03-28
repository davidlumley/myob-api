require 'spec_helper'

describe Myob::Api::Model::Base do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:company_file) { {id: '123', token: 'abc'} }
  let(:params) { {redirect_uri: 'redirect_uri', consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token', selected_company_file: company_file} }
  let(:client) { Myob::Api::Client.new(params) }

  subject { Myob::Api::Model::Base.new(client, 'base') }

  let(:expected_header) { {'Accept'=>'application/json', 'Authorization'=>'Bearer access_token', 'Content-Type'=>'application/json', 'X-Myobapi-Cftoken'=>'abc', 'X-Myobapi-Key'=>'key', 'X-Myobapi-Version'=>'v2'} }
  
  describe ".all_items" do 
    let(:page1) { {'NextPageLink' => 'https://api.myob.com/accountright/123/base$top=2&$skip=2', 'Items' => [{'UID' => '1'}, {'UID' => '2'}]}.to_json }
    let(:page2) { {'Items' => [{'UID' => '3'}, {'UID' => '4'}]}.to_json }

    context 'get all items' do
      it "fetches all the objects pages" do
        stub_request(:get, "https://api.myob.com/accountright/123/base").with(:headers => expected_header).to_return(:status => 200, :body => page1)
        stub_request(:get, "https://api.myob.com/accountright/123/base$top=2&$skip=2").with(:headers => expected_header).to_return(:status => 200, :body => page2)

        actual_iems = subject.all_items
        
        expect(actual_iems).to eql([{'UID' => '1'}, {'UID' => '2'}, {'UID' => '3'}, {'UID' => '4'}])
      end

      it "fetches all the objects pages with filter string" do
        opts = {filter: "LastModified gt datetime'2015-03-29T03:31:57.19'"}

        stub_request(:get, "https://api.myob.com/accountright/123/base?$filter=LastModified%20gt%20datetime%272015-03-29T03%3A31%3A57.19%27")
          .with(:headers => expected_header).to_return(:status => 200, :body => page2)
        
        filtered_iems = subject.all_items(opts)
        
        expect(filtered_iems).to eql([{'UID' => '3'}, {'UID' => '4'}])
      end

      it "fetches all the objects pages with filter options" do
        opts = {filter: {'type' => 'Customer', 'category' => 'Individual'}}

        stub_request(:get, "https://api.myob.com/accountright/123/base?$filter=type%20eq%20'Customer'%20and%20category%20eq%20'Individual'")
          .with(:headers => expected_header).to_return(:status => 200, :body => page2)
        
        filtered_iems = subject.all_items(opts)
        
        expect(filtered_iems).to eql([{'UID' => '3'}, {'UID' => '4'}])
      end
    end
  end

  describe ".save" do 
    let(:base_hash) { {'key' => 'value'} }

    context 'create a new object' do
      before { stub_request(:post, "https://api.myob.com/accountright/123/base")
        .with(:body => base_hash.to_json, :headers => expected_header)
        .to_return(:status => 200, :body => {}.to_json, :headers => {})
      }

      it "posts the object" do
        subject.save(base_hash)
      end
    end

    context 'update an existing object' do
      let(:uid) { '892341' }
      
      before { base_hash['UID'] = uid }
      before { stub_request(:put, "https://api.myob.com/accountright/123/base/#{uid}")
        .with(:body => base_hash.to_json, :headers => expected_header)
        .to_return(:status => 200, :body => {}.to_json, :headers => {})
      }
      
      it "puts the object" do
        subject.save(base_hash)
      end
    end
  end

end
