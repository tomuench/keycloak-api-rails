module Keycloak
  class ControllerWithAuthorization < ActionController::API

    # Validate roles for user
    # @param [String[]] roles
    # @return boolean
    def validate_roles(roles)
      roles.map { |role| has_access?(role) }
          .reduce(:|)
    end

    class << self
      # Autorizize a specific Method
      # @param [Symbol] name - Name of the Method
      # @param [String[]] roles - Role names to Verify
      def authorize(name, roles = [])
        before_action only: [name] do
          roles = [roles] if roles.class == String
          head(401) unless validate_roles(roles)
        end
      end
    end

    private

    # Check Access for Role
    # @param [String] role
    # @return [boolean]
    def has_access?(role)
      Keycloak::Helper.access_to_role?(request.env, role)
    end
  end
end