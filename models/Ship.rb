class Ship < ActiveRecord::Base
	validates :sunken, presence: true
	validates :x, presence:true
	validates :y, presence:true
	belongs_to :board
end