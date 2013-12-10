class Policy < Edition
  include Edition::Images
  include Edition::NationalApplicability
  include Edition::Topics
  include Edition::TopicalEvents
  include Edition::Ministers
  include Edition::FactCheckable
  include Edition::Organisations
  include Edition::SupportingPages
  include Edition::WorldLocations
  include Edition::WorldwidePriorities

  has_many :edition_relations, through: :document
  has_many :related_editions, through: :edition_relations, source: :edition
  has_many :published_related_editions, through: :edition_relations, source: :edition, conditions: {editions: {state: 'published'}}
  has_many :published_related_publications, through: :edition_relations, source: :edition, conditions: {editions: {type: Publicationesque.sti_names, state: 'published'}}
  has_many :published_related_announcements, through: :edition_relations, source: :edition, conditions: {document: {editions: {type: Announcement.sti_names, state: 'published'}}}
  has_many :case_studies, through: :edition_relations, source: :edition, conditions: {editions: {type: 'CaseStudy', state: 'published'}}


  has_many :edition_policy_groups, foreign_key: :edition_id
  has_many :policy_teams, through: :edition_policy_groups, class_name: 'PolicyTeam', source: :policy_group
  has_many :policy_advisory_groups, through: :edition_policy_groups, class_name: 'PolicyAdvisoryGroup', source: :policy_group

  def self.having_announcements
    where("EXISTS (
      SELECT * FROM edition_relations er_check
      JOIN editions announcement_check
        ON announcement_check.id=er_check.edition_id
          AND announcement_check.state='published'
      WHERE
        er_check.document_id=editions.document_id AND
        announcement_check.type in (?)
        )", Announcement.sti_names)
  end

  class Trait < Edition::Traits::Trait
    def process_associations_before_save(edition)
      @edition.edition_policy_groups.each do |association|
        edition.edition_policy_groups.build(association.attributes.except(["id", "edition_id"]))
      end
    end
  end

  add_trait Trait

  after_destroy :remove_edition_relations

  def search_format_types
    super + ['policy']
  end

  def presenter
    PolicyPresenter
  end

  def can_apply_to_local_government?
    true
  end

  def update_published_related_publication_count
    update_column(:published_related_publication_count, published_related_publications.count)
  end

  def policy_team
    policy_teams.first
  end

  def translatable?
    true
  end

  def metadata
    super.merge(policy_teams_metadata).merge(policy_advisory_groups_metadata)
  end

private

  def remove_edition_relations
    edition_relations.each(&:destroy)
  end

  def policy_teams_metadata
    data = policy_teams.map do |team|
      OpenStruct.new(text: team.name, href: team.search_link)
    end

    data.any? ? {policy_teams: data} : {}
  end

  def policy_advisory_groups_metadata
    data = policy_advisory_groups.map do |group|
      OpenStruct.new(text: group.name, href: group.search_link)
    end

    data.any? ? {policy_advisory_groups: data} : {}
  end
end
