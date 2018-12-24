require 'action_view'

class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::AssetTagHelper

  def t_date_field(method, options = {})
    @template.render 'tax_jp/common/date_field', f: self, method: method
  end

end