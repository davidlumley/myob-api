require 'spec_helper'

describe Myob::Api::Client do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:params) { {redirect_uri: 'redirect_uri', consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token'} }

  subject { Myob::Api::Client.new(params) }

  describe ".get_access_code_url" do 
    it "generates the access code url" do
      expect(subject.get_access_code_url).to eql('https://secure.myob.com/oauth2/account/authorize?client_id=key&redirect_uri=redirect_uri&response_type=code&scope=CompanyFile')
    end
  end

  describe ".get_access_token" do 
    let(:access_code) { '123' }

    before { Timecop.freeze(Time.parse("2015-01-01T00:00:00")) }
    after { Timecop.return }

    it "requests the access_token" do
      stub_request(:post, "https://secure.myob.com/oauth2/v1/authorize").
         to_return(:status => 200, :body => { 'access_token'=>'access_code','token_type'=>'bearer','expires_in'=>1200,'refresh_token'=>'refresh_token',
                                              'scope'=>'CompanyFile','user'=>{'uid'=>'uid','username'=>'username'}}.to_json, 
                                   :headers => {"content-type"=>"application/json; charset=utf-8"})

      actual_token = subject.get_access_token(access_code)
      expect(actual_token.token).to eql('access_code')
      expect(actual_token.refresh_token).to eql('refresh_token')
      expect(actual_token.expires_at).to eql((Time.now+1200).to_i)
    end
  end
end
