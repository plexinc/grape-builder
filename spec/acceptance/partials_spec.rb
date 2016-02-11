require 'spec_helper'

describe 'Grape::Builder partials' do
  let(:app) { Class.new(Grape::API) }

  before :each do
    app.format :xml
    app.formatter :xml, Grape::Formatter::Builder
    app.before do
      env['api.tilt.root'] = "#{File.dirname(__FILE__)}/../views"
    end
  end

  it 'proper render partials' do
    app.get('/home', builder: 'project') do
      @author   = OpenStruct.new(author: 'LTe')
      @type     = OpenStruct.new(type: 'paper')
      @project  = OpenStruct.new(name: 'First', type: @type, author: @author)
    end

    pattern = Nokogiri::XML::Builder.new do |xml|
      xml.project do 
        xml.name 'First'
        xml.info do
          xml.type 'paper'
        end
        xml.author 'LTe'
      end
    end

    get('/home')
    expect(pattern.to_xml).to be_equivalent_to(Nokogiri::XML(last_response.body))
  end
end
