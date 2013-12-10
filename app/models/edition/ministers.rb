module Edition::Ministers
  extend ActiveSupport::Concern

  class Trait < Edition::Traits::Trait
    def process_associations_before_save(edition)
      edition.ministerial_roles = @edition.ministerial_roles
    end
  end

  included do
    has_many :edition_ministerial_roles, foreign_key: :edition_id, dependent: :destroy
    has_many :ministerial_roles, through: :edition_ministerial_roles

    add_trait Trait
  end

  def can_be_associated_with_ministers?
    true
  end

  def metadata
    super.merge(ministerial_roles_metadata)
  end

  module ClassMethods
    def in_ministerial_role(role)
      joins(:ministerial_roles).where('roles.id' => role.to_model)
    end
  end

private
  def ministerial_roles_metadata
    data = ministerial_roles.map do |minister|
      OpenStruct.new(text: minister.current_person_name(minister.name),
                     href: minister.search_link)
    end

    data.any? ? {ministerial_roles: data} : {}
  end
end
