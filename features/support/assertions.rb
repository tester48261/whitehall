module Assertions
  def assert_current_url(url, message=nil)
    assert_equal URI.split(url)[3..-1], URI.split(current_url)[3..-1], message
  end

  def assert_page_has_definition(label, value)
    dd = page.find(:xpath, "//dt[.='#{label}']/following-sibling::dd")
    assert dd.text == value, "Expected definition for \"#{label}\" to be \"#{value}\", but was \"#{dd.text}\""
  end
end

World(Assertions)
