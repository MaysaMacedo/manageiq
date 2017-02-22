class PhysicalServer < ApplicationRecord
  include NewWithTypeStiMixin
  include MiqPolicyMixin
  include_concern 'Operations'

  acts_as_miq_taggable
  belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "ManageIQ::Providers::PhysicalInfraManager"
  has_many :firmwares, :foreign_key => "ph_server_uuid", :primary_key => "uuid"
  has_one :host, :foreign_key => "service_tag", :primary_key => "serialNumber"

  VENDOR_TYPES = {
    # DB            Displayed
    "lenovo"          => "lenovo",
    "unknown"         => "Unknown",
    nil               => "Unknown",
  }

  def name_with_details
    details % {
      :name => name,
    }
  end

  def has_compliance_policies?
    _, plist = MiqPolicy.get_policies_for_target(self, "compliance", "physicalserver_compliance_check")
    !plist.blank?
  end

  def health_status
    self.healthState
  end

  def label_for_vendor
   # "lenovo"
    VENDOR_TYPES[self.vendor]
  end

  def is_refreshable?
    refreshable_status[:show]
  end

  def is_refreshable_now?
    refreshable_status[:enabled]
  end

  def is_refreshable_now_error_message
    refreshable_status[:message]
  end

  def is_available?(address)
    #TODO (walteraa) remove bypass
    true
  end

  def smart?
    #TODO (walteraa) remove bypass
    true
  end



  def my_zone
    ems = ext_management_system
    ems ? ems.my_zone : MiqServer.my_zone
  end
end
