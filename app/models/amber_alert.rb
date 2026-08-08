class AmberAlert < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :pet
end
