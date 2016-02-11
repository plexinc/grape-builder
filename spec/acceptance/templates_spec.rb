require 'spec_helper'

describe Grape::Builder do
  let(:app) { Class.new(Grape::API) }

  before do
    app.format :xml
    app.formatter :xml, Grape::Formatter::Builder
    app.before do
      env['api.tilt.root'] = "#{File.dirname(__FILE__)}/../views"
    end
  end

  it 'should work without builder template' do
    app.get('/home') { { hello: 'world' } }

    pattern = Nokogiri::XML('<hash><hello>world</hello></hash>')
    get '/home'
    
    expect(last_response.body).to be_equivalent_to(pattern)
  end

  it 'should work with dynamically set templates' do
    app.get('/home') { env['api.tilt.template'] = 'test' }

    pattern = Nokogiri::XML('<foo>bar</foo>')
    get '/home'

    expect(last_response.body).to be_equivalent_to(pattern)
  end

  it 'should respond with proper content-type' do
    app.get('/home', jbuilder: 'user') do
      @user    = OpenStruct.new(name: 'LTe', email: 'email@example.com')
      @project = OpenStruct.new(name: 'First')
    end

    get('/home')

    expect(last_response.headers['Content-Type']).to eq('application/xml')
  end

  it "renders the template's content" do
    app.get('/home', builder: 'user') do
      @user    = OpenStruct.new(name: 'LTe', email: 'email@example.com')
      @project = OpenStruct.new(name: 'First')
    end

    get('/home')

    pattern = Nokogiri::XML::Builder.new do |xml|
      xml.user do 
        xml.name 'LTe'
        xml.email 'email@example.com'
        xml.project do
          xml.name 'First'
        end
      end
    end

    expect(last_response.body).to be_equivalent_to(pattern.to_xml)
  end
end
