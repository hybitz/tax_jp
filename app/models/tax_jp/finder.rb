class TaxJp::Finder
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :from, :date, default: Date.today
  attribute :prefecture_code, :string
end
