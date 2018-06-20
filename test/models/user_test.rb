require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'valid user creation' do
    user = User.new(username: 'John', email: 'john@example.com', password: 'hobbits123')
    assert user.valid?
  end

  test 'invalid without name' do
    user = User.new(email: 'john@example.com')
    refute user.valid?, 'user is valid without a name'
    assert_not_nil user.errors[:username], 'no validation error for name present'
  end

  test 'invalid without email' do
    user = User.new(username: 'John')
    refute user.valid?
    assert_not_nil user.errors[:email]
  end

  test 'invalid without password' do
    user = User.new(username: 'John', email: 'john@example.com')
    assert_not user.valid?
  end

end
