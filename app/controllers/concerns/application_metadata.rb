module ApplicationMetadata
  extend ActiveSupport::Concern

  included do
    helper_method :pass_to_frontend
  end

  def pass_to_frontend(data)
    %{ <script type="text/javascript">
        if(!window.rails_data) {
          window.rails_data = {};
        }
        Object.assign(window.rails_data, #{data.to_json});
       </script> }.html_safe
  end
end
