xml.project do
  xml.name(@project.name)

  xml.info do
    xml << partial.render('_partial', :type => @type )
  end

  xml.author @author.author
end
