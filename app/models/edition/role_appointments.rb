module Edition::RoleAppointments
  extend ActiveSupport::Concern

  class Trait < Edition::Traits::Trait
    def process_associations_before_save(edition)
      edition.role_appointments = @edition.role_appointments
    end
  end

  included do
    has_many :edition_role_appointments, foreign_key: :edition_id, dependent: :destroy
    has_many :role_appointments, through: :edition_role_appointments

    add_trait Trait
  end

  def can_be_associated_with_role_appointments?
    true
  end

  def search_index
    super.merge("people" => role_appointments.map(&:slug))
  end

  def metadata
    super.merge(role_appointments_metadata)
  end

private
  def role_appointments_metadata
    data = role_appointments.map do |appointment|
      person = appointment.person
      OpenStruct.new(text: person.name, href: person.search_link)
    end

    data.any? ? {role_appointments: data} : {}
  end
end
