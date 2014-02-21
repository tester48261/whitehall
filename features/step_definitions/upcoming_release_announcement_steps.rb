When(/^I announce the release date of the publication$/) do
  @announced_release_date = 1.year.from_now.iso8601
  @announced_release_date_text = "In a year or so, maybe..."
  @announced_release_summary = "Life.to_i"

  visit admin_publication_path(@publication)

  within ".upcoming-release-announcement" do
    check "Announce the release date of this document"
    select_date @announced_release_date, from: "Release date"
    fill_in "Display release date as", with: @announced_release_date_text
    fill_in "Summary", with: @announced_release_summary
    click_on "Announce this upcoming release"
  end

  @publication.reload
end

Then(/^I should see that the publication is announced$/) do
  visit admin_publication_path(@publication)
  assert_page_has_definition("Announced release date:", "#{@announced_release_date.to_s(:long)} (displayed as: \"#{@announced_release_date_text}\")")
end

Then(/^I should see the change to the announcement date in the change notes$/) do
  pending
  # within "#history" do
  #   assert page.has_content?("Announcement changed by #{@user.name}"), "Expected page to have content '#{"Announced by #{@user.name}"}'"
  # end
end
