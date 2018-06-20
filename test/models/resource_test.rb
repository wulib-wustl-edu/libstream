require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test 'should not save a record without a title and as superadmin' do
    user = User.find_by(:id => 1)
    resource = Resource.new
    assert_not resource.save, 'Did not save the resource without a title'
  end

  test 'valid record creation' do
    user = User.find_by(:id => 1)
    resource = Resource.new(title: 'Test McTest', item_id: '163198', subtitles: 'Spanish', course_id: '8301', course_name: 'Film Sucks', semester: 'Winter 2099', instructor: 'Voldemort, Tom', content_type: 'video')
    assert resource.valid?, 'Resource is valid'
  end

  test 'record creation should fail without title' do
    user = User.find_by(:id => 1)
    resource = Resource.new(item_id: '163198', subtitles: 'Spanish', course_id: '8301', course_name: 'Film Sucks', semester: 'Winter 2099', instructor: 'Voldemort, Tom', content_type: 'video')
    assert_not resource.valid?, 'Resource is not valid'
  end


  test 'record creation should fail without item_id' do
    user = User.find_by(:id => 1)
    resource = Resource.new(title: 'Test McTest', subtitles: 'Spanish', course_id: '8301', course_name: 'Film Sucks', semester: 'Winter 2099', instructor: 'Voldemort, Tom', content_type: 'video')
    assert_not resource.valid?, 'Resource is not valid'
  end

  test 'record creation should fail without instructor' do
    user = User.find_by(:id => 1)
    resource = Resource.new(title: 'Test McTest', item_id: '163198', subtitles: 'Spanish', course_id: '8301', course_name: 'Film Sucks', semester: 'Winter 2099', content_type: 'video')
    assert_not resource.valid?, 'Resource is not valid'
  end

  test 'valid record save' do
    user = User.find_by(:id => 1)
    resource = Resource.new(title: 'Test McTest', item_id: '163198', subtitles: 'Spanish', course_id: '8301', course_name: 'Film Sucks', semester: 'Winter 2099', instructor: 'Voldemort, Tom', content_type: 'video')
    resource.save
    assert resource.persisted?, 'Resource saved'
  end


end
