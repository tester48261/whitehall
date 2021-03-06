require "test_helper"
require "gds_api/test_helpers/publishing_api"
require "gds_api/test_helpers/panopticon"

class PublishingTest < ActiveSupport::TestCase
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Panopticon

  setup do
    @draft_edition = create(:draft_edition)
    @presenter = PublishingApiPresenters::Edition.new(@draft_edition)
    stub_panopticon_registration(@draft_edition)
  end

  test "When publishing an edition, it is registered in the publishing api" do
    expected_attributes = @presenter.as_json.merge(
      public_updated_at: Time.zone.now.iso8601
    )
    @request = stub_publishing_api_put_item(@presenter.base_path, expected_attributes)

    perform_force_publishing_for(@draft_edition)

    assert_requested @request
  end

  private

  def perform_force_publishing_for(edition)
    Whitehall.edition_services.force_publisher(edition).perform!
  end
end
