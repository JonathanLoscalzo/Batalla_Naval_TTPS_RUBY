class Ship < ActiveRecord::Base
	validates :sunken, presence: true
	belongs_to :board
end