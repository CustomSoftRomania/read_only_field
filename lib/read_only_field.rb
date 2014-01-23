module ReadOnlyField
  extend ActiveSupport::Concern

  module ClassMethods
    def has_read_only_field(attr_name, options={})
      roles = options.fetch(:allow){ [] }
      class_eval("def self.#{attr_name}_readonly_roles; #{roles.to_s}; end")
      readonly_fields << attr_name
    end
  end

  def self.included(base)
    base.send(:class_attribute, :readonly_fields)
    base.readonly_fields = []
    base.send(:before_validation, :check_read_only_fields)
  end

  def check_read_only_fields
    # changes is returning something like
    # {"name" => [nil, "Test name"]}
    changes.each do |attr_name, values|
      next unless self.class.readonly_fields.include? attr_name.to_sym
      orig, _ = values
      allowed_roles = readonly_roles_for(attr_name)

      next if orig == nil # users should be allowed to change nil values

      roles = user_roles.collect(&:name)

      unless (roles & allowed_roles).any?
        self.errors.add(attr_name, "Your roles (#{roles.to_s}) cannot edit #{attr_name.to_s}")
      end
    end
  end

  def readonly_roles_for(attr_name)
    self.class.send("#{attr_name.to_s}_readonly_roles")
  end

  module RedmineUserRoles
    def user_roles
      self.project.members.includes(:user, :roles).find_by_user_id(User.current).roles
    end
  end
end
