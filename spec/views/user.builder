xml.user do
  xml.name(@user.name)
  xml.email(@user.email)

  xml.project do
    xml.name(@project.name)
  end
end
