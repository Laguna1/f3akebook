# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friend_sent, class_name => 'Friendship', foreign_key: 'sent_by_id'
  has_many :friend_request, class_name => 'Friendship', foreign_key: 'sent_to_id'

  validates :fname, presence: true, length: { in: 3..15 }
  validates :lname, presence: true, length: { in: 3..15 }
end
